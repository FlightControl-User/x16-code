#pragma var_model(mem)

#include <stdio.h>
#include <string.h>
#include <cx16.h>
#include <lru-cache.h>
#include <division.h>

lru_cache_table_t lru_ht;

void key() {
	printf("print any key ...\n");
	while(!kbhit());
}


void main() {

    lru_cache_init(&lru_ht);

    lru_cache_display(&lru_ht);

}

