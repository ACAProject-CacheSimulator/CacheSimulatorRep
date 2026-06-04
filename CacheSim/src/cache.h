#ifndef CACHE_H
#define CACHE_H

#include <stdint.h>

/*
 * Replacement policies for Phase 2 experiments.
 */
typedef enum {
    CACHE_REPL_LRU,      // Evict least recently used block
    CACHE_REPL_MRU,      // Evict most recently used block
    CACHE_REPL_FIFO,     // Evict first inserted block
    CACHE_REPL_RANDOM    // Evict random block
} CacheReplacementPolicy;

/*
 * Insertion policies for Phase 2 experiments.
 */
typedef enum {
    CACHE_INSERT_MRU,    // Insert new block as most recently used
    CACHE_INSERT_LRU     // Insert new block as least recently used
} CacheInsertionPolicy;

/*
 * Global variables used to change policies for experiments.
 *
 * Default behavior:
 * CACHE_REPL_LRU + CACHE_INSERT_MRU
 */
extern CacheReplacementPolicy CACHE_REPLACEMENT_POLICY;
extern CacheInsertionPolicy CACHE_INSERTION_POLICY;

/*
 * Cache_Block represents one cache line/block.
 */
typedef struct Cache_Block {
    uint32_t tag;
    int valid;
    int dirty;

    unsigned long long last_used;    // used for LRU/MRU
    unsigned long long inserted_at;  // used for FIFO
} Cache_Block;

typedef struct Cache {
    Cache_Block **sets;

    int num_sets;
    int associativity;
    int block_size;

    int offset_bits;
    int index_bits;

    unsigned long long timer;

    unsigned long long accesses;
    unsigned long long hits;
    unsigned long long misses;
    unsigned long long dirty_evictions;
} Cache;

void cache_init(Cache *cache, int num_sets, int associativity, int block_size);

int cache_access(Cache *cache, uint32_t address, int is_store);

void cache_free(Cache *cache);

void cache_print_stats(Cache *cache, const char *name);

void cache_print_set(Cache *cache, int set_index);

void cache_set_policies(CacheReplacementPolicy repl_policy,
                        CacheInsertionPolicy insert_policy);

#endif