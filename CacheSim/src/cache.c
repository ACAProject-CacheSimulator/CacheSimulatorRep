#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include "cache.h"

/*
 * Returns log2(x), assuming x is a power of two.
 *
 * Example:
 * log2_int(32)  = 5
 * log2_int(64)  = 6
 * log2_int(256) = 8
 */
static int log2_int(int x) {
    int result = 0;

    while (x > 1) {
        x = x >> 1;
        result++;
    }

    return result;
}

/*
 * Checks whether x is a power of two.
 *
 * Caches usually require block size and number of sets
 * to be powers of two so that address bits can be split
 * cleanly into tag/index/offset.
 */
static int is_power_of_two(int x) {
    if (x <= 0) {
        return 0;
    }

    return (x & (x - 1)) == 0;
}

/*
 * Initializes every field of a cache.
 *
 * This function creates a 2D array:
 *
 * cache->sets[set_index][way]
 *
 * Example:
 * For a 64-set, 4-way cache:
 *
 * cache->sets[0][0]
 * cache->sets[0][1]
 * cache->sets[0][2]
 * cache->sets[0][3]
 *
 * ...
 *
 * cache->sets[63][0]
 * cache->sets[63][1]
 * cache->sets[63][2]
 * cache->sets[63][3]
 */
void cache_init(Cache *cache, int num_sets, int associativity, int block_size) {
    int i;
    int j;

    if (cache == NULL) {
        fprintf(stderr, "cache_init error: cache pointer is NULL\n");
        exit(1);
    }

    if (!is_power_of_two(num_sets)) {
        fprintf(stderr, "cache_init error: num_sets must be a power of two\n");
        exit(1);
    }

    if (!is_power_of_two(block_size)) {
        fprintf(stderr, "cache_init error: block_size must be a power of two\n");
        exit(1);
    }

    if (associativity <= 0) {
        fprintf(stderr, "cache_init error: associativity must be positive\n");
        exit(1);
    }

    cache->num_sets = num_sets;
    cache->associativity = associativity;
    cache->block_size = block_size;

    cache->offset_bits = log2_int(block_size);
    cache->index_bits = log2_int(num_sets);

    cache->timer = 0;

    cache->accesses = 0;
    cache->hits = 0;
    cache->misses = 0;
    cache->dirty_evictions = 0;

    cache->sets = malloc(num_sets * sizeof(Cache_Block *));

    if (cache->sets == NULL) {
        fprintf(stderr, "cache_init error: could not allocate cache sets\n");
        exit(1);
    }

    for (i = 0; i < num_sets; i++) {
        cache->sets[i] = malloc(associativity * sizeof(Cache_Block));

        if (cache->sets[i] == NULL) {
            fprintf(stderr, "cache_init error: could not allocate cache ways\n");
            exit(1);
        }

        for (j = 0; j < associativity; j++) {
            cache->sets[i][j].tag = 0;
            cache->sets[i][j].valid = 0;
            cache->sets[i][j].dirty = 0;
            cache->sets[i][j].last_used = 0;
        }
    }
}

/*
 * Accesses the cache and returns hit/miss.
 *
 * Address format:
 *
 * tag | index | offset
 *
 * offset bits = log2(block_size)
 * index bits  = log2(num_sets)
 * tag bits    = remaining upper bits
 *
 * Example instruction cache:
 * block size = 32 bytes -> offset bits = 5
 * num sets   = 64       -> index bits  = 6
 *
 * index = address[10:5]
 * tag   = address[31:11]
 *
 * Example data cache:
 * block size = 32 bytes -> offset bits = 5
 * num sets   = 256      -> index bits  = 8
 *
 * index = address[12:5]
 * tag   = address[31:13]
 */
int cache_access(Cache *cache, uint32_t address, int is_store) {
    uint32_t index;
    uint32_t tag;
    uint32_t index_mask;

    int i;
    int victim;
    unsigned long long oldest_time;

    Cache_Block *set;

    if (cache == NULL || cache->sets == NULL) {
        fprintf(stderr, "cache_access error: cache is not initialized\n");
        exit(1);
    }

    /*
     * Every call to cache_access counts as one cache access.
     */
    cache->accesses++;

    /*
     * Increase timer before assigning it.
     * This means newer accesses always have larger timestamps.
     */
    cache->timer++;

    /*
     * Build index mask.
     *
     * If index_bits = 6:
     * (1 << 6) - 1 = 0b111111 = 0x3F
     *
     * If index_bits = 8:
     * (1 << 8) - 1 = 0b11111111 = 0xFF
     */
    index_mask = (1u << cache->index_bits) - 1u;

    /*
     * Extract index.
     *
     * First shift away the offset bits.
     * Then mask only the index bits.
     */
    index = (address >> cache->offset_bits) & index_mask;

    /*
     * Extract tag.
     *
     * Shift away both offset and index bits.
     */
    tag = address >> (cache->offset_bits + cache->index_bits);

    /*
     * Select the set we need to search.
     */
    set = cache->sets[index];

    /*
     * Step 1: Search all ways in the selected set.
     *
     * If we find a valid block with matching tag,
     * this is a cache hit.
     */
    for (i = 0; i < cache->associativity; i++) {
        if (set[i].valid && set[i].tag == tag) {
            cache->hits++;

            /*
             * Update LRU timestamp.
             * This block is now the most recently used.
             */
            set[i].last_used = cache->timer;

            /*
             * If this is a store, mark the block dirty.
             */
            if (is_store) {
                set[i].dirty = 1;
            }

            return 1;
        }
    }

    /*
     * Step 2: If we reach here, it is a miss.
     */
    cache->misses++;

    /*
     * Step 3: Prefer inserting into an invalid/empty way.
     *
     * The PDF says:
     * If any way in the set is invalid, insert there.
     */
    victim = -1;

    for (i = 0; i < cache->associativity; i++) {
        if (!set[i].valid) {
            victim = i;
            break;
        }
    }

    /*
     * Step 4: If all ways are valid, choose the LRU victim.
     *
     * With timestamp LRU:
     * smaller last_used = older = less recently used
     */
    if (victim == -1) {
        victim = 0;
        oldest_time = set[0].last_used;

        for (i = 1; i < cache->associativity; i++) {
            if (set[i].last_used < oldest_time) {
                oldest_time = set[i].last_used;
                victim = i;
            }
        }

        /*
         * Dirty eviction tracking.
         *
         * The project says dirty evictions are instantaneous,
         * so this counter is only for stats/debugging.
         */
        if (set[victim].dirty) {
            cache->dirty_evictions++;
        }
    }

    /*
     * Step 5: Insert the new block into the chosen victim way.
     *
     * On both load misses and store misses, the block is brought
     * into cache.
     *
     * If the access was a store, the inserted block becomes dirty.
     */
    set[victim].tag = tag;
    set[victim].valid = 1;
    set[victim].dirty = is_store ? 1 : 0;
    set[victim].last_used = cache->timer;

    return 0;
}

/*
 * Frees all memory allocated for the cache.
 */
void cache_free(Cache *cache) {
    int i;

    if (cache == NULL || cache->sets == NULL) {
        return;
    }

    for (i = 0; i < cache->num_sets; i++) {
        free(cache->sets[i]);
    }

    free(cache->sets);
    cache->sets = NULL;
}

/*
 * Prints statistics about a cache.
 */
void cache_print_stats(Cache *cache, const char *name) {
    double hit_rate;
    double miss_rate;

    if (cache == NULL) {
        return;
    }

    if (cache->accesses == 0) {
        hit_rate = 0.0;
        miss_rate = 0.0;
    } else {
        hit_rate = ((double) cache->hits / (double) cache->accesses) * 100.0;
        miss_rate = ((double) cache->misses / (double) cache->accesses) * 100.0;
    }

    printf("\n%s statistics:\n", name);
    printf("Accesses:        %llu\n", cache->accesses);
    printf("Hits:            %llu\n", cache->hits);
    printf("Misses:          %llu\n", cache->misses);
    printf("Hit rate:        %.2f%%\n", hit_rate);
    printf("Miss rate:       %.2f%%\n", miss_rate);
    printf("Dirty evictions: %llu\n", cache->dirty_evictions);
}

/*
 * Debug function to inspect one set.
 */
void cache_print_set(Cache *cache, int set_index) {
    int i;

    if (cache == NULL || cache->sets == NULL) {
        printf("Cache is not initialized\n");
        return;
    }

    if (set_index < 0 || set_index >= cache->num_sets) {
        printf("Invalid set index %d\n", set_index);
        return;
    }

    printf("\nSet %d:\n", set_index);

    for (i = 0; i < cache->associativity; i++) {
        printf(
            "Way %d | valid=%d tag=0x%08x dirty=%d last_used=%llu\n",
            i,
            cache->sets[set_index][i].valid,
            cache->sets[set_index][i].tag,
            cache->sets[set_index][i].dirty,
            cache->sets[set_index][i].last_used
        );
    }
}