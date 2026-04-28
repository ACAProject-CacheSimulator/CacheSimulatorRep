#include <stdio.h>
#include "cache.h"

static void test_basic_hits_and_misses() {
    Cache cache;

    printf("\n===== BASIC HIT/MISS TEST =====\n");

    cache_init(&cache, 64, 4, 32);

    printf("Access 0x00000000: %s\n",
           cache_access(&cache, 0x00000000, 0) ? "hit" : "miss");

    printf("Access 0x00000000: %s\n",
           cache_access(&cache, 0x00000000, 0) ? "hit" : "miss");

    printf("Access 0x00000020: %s\n",
           cache_access(&cache, 0x00000020, 0) ? "hit" : "miss");

    printf("Access 0x00000020: %s\n",
           cache_access(&cache, 0x00000020, 0) ? "hit" : "miss");

    cache_print_stats(&cache, "Basic test cache");

    cache_free(&cache);
}

static void test_lru_eviction() {
    Cache cache;

    printf("\n===== LRU EVICTION TEST =====\n");

    /*
     * 64 sets, 4-way, 32-byte blocks.
     *
     * Addresses separated by 64 * 32 = 2048 = 0x800
     * map to the same set but have different tags.
     */
    cache_init(&cache, 64, 4, 32);

    printf("Fill set with 4 different blocks:\n");

    printf("0x0000: %s\n", cache_access(&cache, 0x0000, 0) ? "hit" : "miss");
    printf("0x0800: %s\n", cache_access(&cache, 0x0800, 0) ? "hit" : "miss");
    printf("0x1000: %s\n", cache_access(&cache, 0x1000, 0) ? "hit" : "miss");
    printf("0x1800: %s\n", cache_access(&cache, 0x1800, 0) ? "hit" : "miss");

    printf("\nCurrent set 0 after filling:\n");
    cache_print_set(&cache, 0);

    /*
     * Access 0x0000 again.
     * This makes it recently used.
     */
    printf("\nAccess 0x0000 again to make it recently used:\n");
    printf("0x0000: %s\n", cache_access(&cache, 0x0000, 0) ? "hit" : "miss");

    /*
     * Insert a fifth block mapping to same set.
     * Since associativity is 4, one block must be evicted.
     *
     * LRU should evict 0x0800, because 0x0000 was refreshed.
     */
    printf("\nInsert 0x2000, should evict least recently used block:\n");
    printf("0x2000: %s\n", cache_access(&cache, 0x2000, 0) ? "hit" : "miss");

    printf("\nSet 0 after eviction:\n");
    cache_print_set(&cache, 0);

    printf("\nCheck expected results:\n");

    printf("0x0000 should hit: %s\n",
           cache_access(&cache, 0x0000, 0) ? "hit" : "miss");

    printf("0x0800 should miss: %s\n",
           cache_access(&cache, 0x0800, 0) ? "hit" : "miss");

    cache_print_stats(&cache, "LRU test cache");

    cache_free(&cache);
}

static void test_store_dirty_bit() {
    Cache cache;

    printf("\n===== STORE / DIRTY BIT TEST =====\n");

    cache_init(&cache, 64, 4, 32);

    /*
     * Store to a new address:
     * miss, inserted block should be dirty.
     */
    printf("Store to 0x0000: %s\n",
           cache_access(&cache, 0x0000, 1) ? "hit" : "miss");

    cache_print_set(&cache, 0);

    /*
     * Store again:s
     * hit, remains dirty.
     */
    printf("Store again to 0x0000: %s\n",
           cache_access(&cache, 0x0000, 1) ? "hit" : "miss");

    cache_print_set(&cache, 0);

    cache_print_stats(&cache, "Dirty bit test cache");

    cache_free(&cache);
}

int main() {
    test_basic_hits_and_misses();
    test_lru_eviction();
    test_store_dirty_bit();

    return 0;
}