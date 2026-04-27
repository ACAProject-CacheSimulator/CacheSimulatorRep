#ifndef CACHE_H
#define CACHE_H

#include <stdint.h>

/*
 * Cache_Block represents one cache line/block.
 *
 * The cache does not store real data bytes.
 * It only stores metadata needed to decide hit/miss.
 */
typedef struct Cache_Block {
    uint32_t tag;                    // identifies which memory block is stored
    int valid;                       // 0 = empty/invalid, 1 = contains valid block
    int dirty;                       // 1 = block was written by a store
    unsigned long long last_used;    // timestamp for LRU replacement
} Cache_Block;

/*
 * Cache represents a generic set-associative cache.
 *
 * It can represent both:
 * - instruction cache: 64 sets, 4-way, 32-byte blocks
 * - data cache: 256 sets, 8-way, 32-byte blocks
 */
typedef struct Cache {
    Cache_Block **sets;              // 2D array: sets[set_index][way]

    int num_sets;                    // number of sets
    int associativity;               // number of ways per set
    int block_size;                  // block size in bytes

    int offset_bits;                 // log2(block_size)
    int index_bits;                  // log2(num_sets)

    unsigned long long timer;        // global timestamp for this cache

    unsigned long long accesses;     // total cache accesses
    unsigned long long hits;         // total hits
    unsigned long long misses;       // total misses
    unsigned long long dirty_evictions; // number of dirty blocks evicted
} Cache;

/*
 * Initializes a cache.
 *
 * Example:
 * cache_init(&icache, 64, 4, 32);
 * cache_init(&dcache, 256, 8, 32);
 */
void cache_init(Cache *cache, int num_sets, int associativity, int block_size);

/*
 * Accesses the cache.
 *
 * Parameters:
 * cache    = pointer to cache
 * address  = memory address being accessed
 * is_store = 0 for instruction fetch/load, 1 for store
 *
 * Return:
 * 1 = hit
 * 0 = miss
 *
 * On miss, this function automatically inserts the new block.
 */
int cache_access(Cache *cache, uint32_t address, int is_store);

/*
 * Frees memory allocated by cache_init.
 */
void cache_free(Cache *cache);

/*
 * Prints cache statistics.
 * Useful for debugging and later report.
 */
void cache_print_stats(Cache *cache, const char *name);

/*
 * Debug helper.
 * Prints one set of the cache.
 */
void cache_print_set(Cache *cache, int set_index);

#endif