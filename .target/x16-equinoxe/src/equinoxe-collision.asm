  //
#importonce
  // File Comments
  // Library
.namespace equinoxe_collision {
  // Upstart
.cpu _65c02
#if !__asm_import__equinoxe_collision__
.segmentdef Basic                   [start=$0801]
.segmentdef Code                    [start=$80d]
.segmentdef CodeBramHeap            [startAfter="Code"] 
.segmentdef CodeVeraHeap            [startAfter="CodeBramHeap"] 
.segmentdef CodeLruCache            [startAfter="CodeVeraHeap"] 
.segmentdef CodeEngineFlight        [startAfter="CodeLruCache"] 
.segmentdef CodeEngineFloor         [startAfter="CodeEngineFlight"] 
.segmentdef CodeEngineAnimate       [startAfter="CodeEngineFloor"] 
.segmentdef CodeEnginePalette       [startAfter="CodeEngineAnimate"] 

.segmentdef Data                    [startAfter="CodeEnginePalette", align=$100]
.segmentdef DataBramHeap            [startAfter="Data"] 
.segmentdef DataVeraHeap            [startAfter="DataBramHeap"] 
.segmentdef DataEngineAnimate       [startAfter="DataVeraHeap"] 
.segmentdef DataEnginePalette       [startAfter="DataEngineAnimate"] 
.segmentdef DataEngineFloor         [startAfter="DataEnginePalette"] 
.segmentdef DataEngineStages        [startAfter="DataEngineFloor"]
.segmentdef DataEngineBullets       [startAfter="DataEngineStages"]
.segmentdef DataEnginePlayers       [startAfter="DataEngineBullets"]
.segmentdef DataEngineEnemies       [startAfter="DataEnginePlayers"]
.segmentdef DataEngineTowers        [startAfter="DataEngineEnemies"]
.segmentdef DataEngineFlight        [startAfter="DataEngineTowers", align=$100] 
.segmentdef DataSpriteCache         [startAfter="DataEngineFlight", align=$100]


//.segmentdef BramEngineFloor       [startAfter=""] 


.segmentdef Hash                    [start=$0400, min=$0400, max=$06FF, align=$100]

.segmentdef Debug                   [startAfter="Hash", align=$100]

.segmentdef BramBramHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramVeraHeap            [start=$A000, min=$A000, max=$BFFF, align=$100]

//.segmentdef CodeVeraHeap            [startAfter="BramVeraHeap", min=$A000, max=$BFFF, align=$100] 
//.segmentdef DataVeraHeap            [startAfter="CodeVeraHeap", min=$A000, max=$BFFF, align=$100] 

.segmentdef CodeEngineStages        [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef BramEngineStages        [startAfter="CodeEngineStages", min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEnginePlayers       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineBullets       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineEnemies       [start=$A000, min=$A000, max=$BFFF, align=$100]
.segmentdef CodeEngineTowers        [start=$A000, min=$A000, max=$BFFF, align=$100]

.segmentdef BramEngineFloor         [start=$A000, min=$A000, align=$100]
.segmentdef BramEngineFlight        [start=$A000, min=$A000, max=$BF00, align=$100]
.segmentdef BramEnginePalette       [start=$A000, min=$A000, max=$BFFF, align=$100]

//.segmentdef CodeEngineFloor         [start=$A000, min=$A000, max=$BF00, align=$100]
//.segmentdef CodeEngineFlight        [start=$A000, min=$A000, max=$BFFF, align=$100]

#endif

  // Global Constants & labels
  .label SIZEOF_STRUCT_COLLISION_DECISION_T = $a
  .label OFFSET_STRUCT_HT_ITEM_T_NEXT = $100
  .label OFFSET_STRUCT_HT_LIST_S_NEXT = $100
  .label OFFSET_STRUCT_FLIGHT_T_XI = $300
  .label OFFSET_STRUCT_FLIGHT_T_YI = $380
  .label OFFSET_STRUCT_FLIGHT_T_CX = $200
  .label OFFSET_STRUCT_FLIGHT_T_CY = $240
  .label OFFSET_STRUCT_FLIGHT_T_COLLIDED = $140
  .label OFFSET_STRUCT_FLIGHT_T_TYPE = $180
  .label OFFSET_STRUCT_FLIGHT_T_SIDE = $1c0
  .label OFFSET_STRUCT_COLLISION_DECISION_T_S = 1
  .label OFFSET_STRUCT_COLLISION_DECISION_T_X = 2
  .label OFFSET_STRUCT_COLLISION_DECISION_T_Y = 3
  .label OFFSET_STRUCT_COLLISION_DECISION_T_SIDE = 5
  .label OFFSET_STRUCT_COLLISION_DECISION_T_TYPE = 4
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN = $210
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X = 6
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN = $220
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y = 7
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX = $230
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X = 8
  .label OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX = $240
  .label OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y = 9
  .label SIZEOF_STRUCT_HT_LIST_S = $200
  .label SIZEOF_STRUCT_HT_ITEM_T = $200
  .label SIZEOF_STRUCT_COLLISION_QUADRANT_T = $100
  .label BRAM = 0
  .label BROM = 1
  .label ht_list_pool = $2c
.segment Code
  // __equinoxe_collision_start
// void __equinoxe_collision_start()
__equinoxe_collision_start: {
    // __equinoxe_collision_start::__init1
    // __export volatile __address(0x00) unsigned char BRAM = 0
    // [1] BRAM = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z BRAM
    // __export volatile __address(0x01) unsigned char BROM = 4
    // [2] BROM = 4 -- vbuz1=vbuc1 
    lda #4
    sta.z BROM
    // volatile unsigned char ht_list_pool
    // [3] ht_list_pool = 0 -- vbuz1=vbuc1 
    lda #0
    sta.z ht_list_pool
    // __equinoxe_collision_start::@return
    // [4] return 
    rts
}
  // collision_detect
/**
 * @brief Equinoxe main collision detection routine.
 *
 * A spacial grid approach is implemented in the equinoxe gaming engine, to ensure
 * blazing performance during collision detection between all the game objects on the screen.
 *
 * Previously, at each frame, we have executed the during the object logic,
 * the movement calculations and image animations for the screen.
 * As part of this object logic, we have also created a spacial grid, using the collision_insert routines.
 * The grid_ routines uses the routine set ht.h, which is a set of routines to create a has table.
 *
 * This collision_detect detection routine, uses the created spacial grid to efficiently compare the positions of each
 * object relative to each other, and will only compare those objects which have opposite party sides.
 *
 * Each cell in the spacial grid is 64x64 pixels wide in terms of screen dimensions.
 * The dimensions of our screen is 640x480, so there are 10 spacial grid cells on the x axis and 8 spacial grid cells on the y axis.
 * For efficiency reasons to store the spacial grid into memory and to optimize the utilization of the byte architecture of the 6502,
 * we reduced the spacial grid resolution with 2 bits to the right, so we divided by 4 both the x and y coordinates,
 * resulting in the spacial grid dimension to be 160x120. Now the spacial grid has table can
 * be built up using only byte values, not integers. So the x and y coordinate in the spacial grid can now be stored in 4 bits each,
 * where the x coordinate takes the lower nibble of the coordinate byte, and the y coordinate the higher nibble of the coordinate byte.
 *
 * So the spacial grid coordinate system **is stored in a hash table** with the x and y coordinates as the key, which is one byte wide!
 * This results in a very fast calculation algorithm for the 6502, where searching through the has table only requires one byte to be hashed.
 * For further efficiency reasons, the has table implements for duplicate keys a linked list, where the links are stored in a pre-defined
 * array of again only byte sized indexes. Again very efficient for the 6502! the spacial grid uses only absolute addressiing,
 * so pointers are completely avoided, which results in fast processing on the 6502.
 *
 * Because the coordinates in the spacial grid are they in the spacial grid hash table,
 * each object stored in the grid cell will result in a linked list to be built up in the spacial grid hash table!
 * So again very efficient, as now we can take the first element of a spacial grid cell linked list, and iterate through that list to
 * verify each object in that list!
 *
 * The collision detection loops through each cell in the spacial grid. Thus, it will loop horizontally 10 cells and vertically 8 cells.
 * 80 cells in total, however this loop is very efficient as it is only on byte level.
 *
 * During each spacial grid cell evaluation, it performs an outer and an inner loop,
 * where it compares the positions and the properties of the objects in the spacial grid cell against each other
 * using the linked list in the spacial grid hash table.
 *
 * And it does it in a special way, so that no object will be compared twice!
 * The outer loop will loop the complete linked list of the hashed grid cell.
 * The inner loop will only loop from the start position of the outer loop and taking the next element in that list as the start.
 *
 * For example, consider we have in the spacial grid cell the following objects A, B, C, D, E.
 * Then the outer loop will loop from A to E, while the inner loop will take for each element of the outer loop the next starting position.
 * So it will loop as follows:
 *
 *   | LOOP ITERATION | 1       | 2     | 3   | 4 |
 *   | -------------: | :-----: | :---: | :-: | - |
 *   | OUTER LOOP     | A       | B     | C   | D |
 *   | INNER LOOP     | B C D E | C D E | D E | E |
 *
 * This results in the minimal sets of objects to be compared wit? each other, and thus, the most optimizal performance!
 *
 * On top of this comparison the properties of each object are evaluated. Each object as a coalition side,
 * which can be SIDE_FRIENDLY or SIDE_ENEMY. The game setup will only require objects to be compared with different coalitions.
 * So objects of the same coalition are never compared. SIDE_FRIENDLY is never compared with SIDE_FRIENDLY and SIDE_ENEMY is never compared with SIDE_ENEMY.
 *
 * Each object has an AABB or bounding box defined, that contains the dimensions of each object to be taken into account when comparing
 * the bounding box overlap between the objects in the spacial grid cell.
 *
 *
 */
// void collision_detect()
collision_detect: {
    .label collision_outer = $30
    .label collision_inner = $3a
    .label gy = $2d
    .label gx = $24
    .label ht_index_outer = $2a
    .label ht_index_inner = $28
    .label ht_get_next2_return = $2a
    .label outer = $23
    .label inner = $2b
    .label ht_get_next3_ht_index = $28
    .label ht_get_next3_return = $28
    // [6] phi from collision_detect to collision_detect::@1 [phi:collision_detect->collision_detect::@1]
    // [6] phi collision_detect::gy#2 = 0 [phi:collision_detect->collision_detect::@1#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gy
  // The collision key needs the gx and gy so that the key can be calculated using a simple addition.
  // We walk each row on the grid on the y-asis using the gy variable. There are in total 8 rows (480+64)/64.
  // However, we ensure that gy contains the sum of all the cells of each row considered,
  // so gy is incremented with a precision of 16, assuming that each row contains 16 cells.
    // collision_detect::@1
  __b1:
    // for (unsigned char gy = 0; gy < ((480 + 64) >> 2); gy += (64 >> 2))
    // [7] if(collision_detect::gy#2<(char)$1e0+$40>>2) goto collision_detect::@2 -- vbuz1_lt_vbuc1_then_la1 
    lda.z gy
    cmp #$1e0+$40>>2
    bcc __b3
    // collision_detect::@return
    // }
    // [8] return 
    rts
  // we walk each column on the row using the gx variable. Each row has 11 (640+64)/64 cells, (to deal with border collisions too).
  // We consider gx to be incremented for each cell in the column/row combination, so gx is incremented by 1!
    // [9] phi from collision_detect::@1 to collision_detect::@2 [phi:collision_detect::@1->collision_detect::@2]
  __b3:
    // [9] phi collision_detect::gx#10 = 0 [phi:collision_detect::@1->collision_detect::@2#0] -- vbuz1=vbuc1 
    lda #0
    sta.z gx
    // collision_detect::@2
  __b2:
    // for (unsigned char gx = 0; gx < ((640 + 64) >> (2 + 4)); gx += (64 >> (2 + 4)))
    // [10] if(collision_detect::gx#10<(char)$280+$40>>2+4) goto collision_detect::collision_count1 -- vbuz1_lt_vbuc1_then_la1 
    lda.z gx
    cmp #$280+$40>>2+4
    bcc collision_count1
    // collision_detect::@3
    // gy += (64 >> 2)
    // [11] collision_detect::gy#1 = collision_detect::gy#2 + $40>>2 -- vbuz1=vbuz1_plus_vbuc1 
    lda #$40>>2
    clc
    adc.z gy
    sta.z gy
    // [6] phi from collision_detect::@3 to collision_detect::@1 [phi:collision_detect::@3->collision_detect::@1]
    // [6] phi collision_detect::gy#2 = collision_detect::gy#1 [phi:collision_detect::@3->collision_detect::@1#0] -- register_copy 
    jmp __b1
    // collision_detect::collision_count1
  collision_count1:
    // gx + gy
    // [12] collision_detect::collision_count1_$0 = collision_detect::gx#10 + collision_detect::gy#2 -- vbuaa=vbuz1_plus_vbuz2 
    lda.z gx
    clc
    adc.z gy
    // return collision_quadrant.cell[gx + gy];
    // [13] collision_detect::collision_count1_return#0 = ((char *)&collision_quadrant)[collision_detect::collision_count1_$0] -- vbuaa=pbuc1_derefidx_vbuaa 
    tay
    lda collision_quadrant,y
    // collision_detect::@36
    // if (collision_count(gx, gy))
    // [14] if(0==collision_detect::collision_count1_return#0) goto collision_detect::@4 -- 0_eq_vbuaa_then_la1 
    cmp #0
    beq __b4
    // collision_detect::@35
    // ht_key_t ht_key_outer = collision_key(gx, gy)
    // [15] collision_key::gx#1 = collision_detect::gx#10 -- vbuaa=vbuz1 
    lda.z gx
    // [16] collision_key::gy#1 = collision_detect::gy#2 -- vbuxx=vbuz1 
    ldx.z gy
    // [17] call collision_key
    // [135] phi from collision_detect::@35 to collision_key [phi:collision_detect::@35->collision_key]
    // [135] phi collision_key::gx#2 = collision_key::gx#1 [phi:collision_detect::@35->collision_key#0] -- register_copy 
    // [135] phi collision_key::gy#2 = collision_key::gy#1 [phi:collision_detect::@35->collision_key#1] -- register_copy 
    jsr collision_key
    // ht_key_t ht_key_outer = collision_key(gx, gy)
    // [18] collision_key::return#3 = collision_key::return#0
    // collision_detect::@40
    // [19] collision_detect::ht_key_outer#0 = collision_key::return#3
    // ht_index_t ht_index_outer = ht_get(&collision_hash, ht_key_outer)
    // [20] ht_get::key#0 = collision_detect::ht_key_outer#0 -- vbuz1=vbuaa 
    sta.z ht_get.key
    // [21] call ht_get
    // [138] phi from collision_detect::@40 to ht_get [phi:collision_detect::@40->ht_get]
    jsr ht_get
    // ht_index_t ht_index_outer = ht_get(&collision_hash, ht_key_outer)
    // [22] ht_get::return#3 = ht_get::return#2
    // collision_detect::@41
    // [23] collision_detect::ht_index_outer#0 = ht_get::return#3 -- vbuz1=vbuaa 
    sta.z ht_index_outer
    // [24] phi from collision_detect::@41 collision_detect::ht_get_next2 to collision_detect::@5 [phi:collision_detect::@41/collision_detect::ht_get_next2->collision_detect::@5]
    // [24] phi collision_detect::ht_index_outer#10 = collision_detect::ht_index_outer#0 [phi:collision_detect::@41/collision_detect::ht_get_next2->collision_detect::@5#0] -- register_copy 
    // collision_detect::@5
  __b5:
    // while (ht_index_outer)
    // [25] if(0!=collision_detect::ht_index_outer#10) goto collision_detect::ht_get_next1 -- 0_neq_vbuz1_then_la1 
    lda.z ht_index_outer
    bne ht_get_next1
    // collision_detect::@4
  __b4:
    // gx += (64 >> (2 + 4))
    // [26] collision_detect::gx#1 = collision_detect::gx#10 + $40>>2+4 -- vbuz1=vbuz1_plus_vbuc1 
    lda #$40>>2+4
    clc
    adc.z gx
    sta.z gx
    // [9] phi from collision_detect::@4 to collision_detect::@2 [phi:collision_detect::@4->collision_detect::@2]
    // [9] phi collision_detect::gx#10 = collision_detect::gx#1 [phi:collision_detect::@4->collision_detect::@2#0] -- register_copy 
    jmp __b2
    // collision_detect::ht_get_next1
  ht_get_next1:
    // return ht_list.next[ht_index];
    // [27] collision_detect::ht_index_inner#0 = ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[collision_detect::ht_index_outer#10] -- vbuz1=pbuc1_derefidx_vbuz2 
    ldy.z ht_index_outer
    lda ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    sta.z ht_index_inner
    // collision_detect::@37
    // if (ht_index_inner)
    // [28] if(0==collision_detect::ht_index_inner#0) goto collision_detect::ht_get_next2 -- 0_eq_vbuz1_then_la1 
    beq ht_get_next2
    // collision_detect::@34
    // collision_decision_t collision_outer
    // [29] *(&collision_detect::collision_outer) = memset(collision_decision_t, SIZEOF_STRUCT_COLLISION_DECISION_T) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT_COLLISION_DECISION_T
    lda #0
  !:
    dey
    sta collision_outer,y
    bne !-
    // collision_detect::ht_get_data1
    // return ht_list.data[ht_index];
    // [30] collision_detect::ht_get_data1_return#0 = ((char *)&ht_list)[collision_detect::ht_index_outer#10] -- vbuxx=pbuc1_derefidx_vbuz1 
    ldy.z ht_index_outer
    ldx ht_list,y
    // collision_detect::@38
    // collision_data(outer, &collision_outer)
    // [31] collision_data::collision#0 = collision_detect::ht_get_data1_return#0
    // [32] call collision_data
    // [150] phi from collision_detect::@38 to collision_data [phi:collision_detect::@38->collision_data]
    // [150] phi collision_data::collision_decision#2 = &collision_detect::collision_outer [phi:collision_detect::@38->collision_data#0] -- pssz1=pssc1 
    lda #<collision_outer
    sta.z collision_data.collision_decision
    lda #>collision_outer
    sta.z collision_data.collision_decision+1
    // [150] phi collision_data::return#0 = collision_data::collision#0 [phi:collision_detect::@38->collision_data#1] -- register_copy 
    jsr collision_data
    // collision_data(outer, &collision_outer)
    // [33] collision_data::return#2 = collision_data::return#0
    // collision_detect::@42
    // outer = collision_data(outer, &collision_outer)
    // [34] collision_detect::outer#1 = collision_data::return#2 -- vbuz1=vbuxx 
    stx.z outer
    // [35] phi from collision_detect::@42 collision_detect::ht_get_next3 to collision_detect::@6 [phi:collision_detect::@42/collision_detect::ht_get_next3->collision_detect::@6]
    // [35] phi collision_detect::ht_get_next3_ht_index#0 = collision_detect::ht_index_inner#0 [phi:collision_detect::@42/collision_detect::ht_get_next3->collision_detect::@6#0] -- register_copy 
    // collision_detect::@6
  __b6:
    // while (ht_index_inner)
    // [36] if(0!=collision_detect::ht_get_next3_ht_index#0) goto collision_detect::@7 -- 0_neq_vbuz1_then_la1 
    lda.z ht_get_next3_ht_index
    bne __b7
    // collision_detect::ht_get_next2
  ht_get_next2:
    // return ht_list.next[ht_index];
    // [37] collision_detect::ht_get_next2_return#0 = ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[collision_detect::ht_index_outer#10] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z ht_get_next2_return
    lda ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    sta.z ht_get_next2_return
    jmp __b5
    // collision_detect::@7
  __b7:
    // collision_decision_t collision_inner
    // [38] *(&collision_detect::collision_inner) = memset(collision_decision_t, SIZEOF_STRUCT_COLLISION_DECISION_T) -- _deref_pssc1=_memset_vbuc2 
    ldy #SIZEOF_STRUCT_COLLISION_DECISION_T
    lda #0
  !:
    dey
    sta collision_inner,y
    bne !-
    // collision_detect::ht_get_data2
    // return ht_list.data[ht_index];
    // [39] collision_detect::ht_get_data2_return#0 = ((char *)&ht_list)[collision_detect::ht_get_next3_ht_index#0] -- vbuaa=pbuc1_derefidx_vbuz1 
    ldy.z ht_get_next3_ht_index
    lda ht_list,y
    // collision_detect::@39
    // collision_data(inner, &collision_inner)
    // [40] collision_data::collision#1 = collision_detect::ht_get_data2_return#0 -- vbuxx=vbuaa 
    tax
    // [41] call collision_data
    // [150] phi from collision_detect::@39 to collision_data [phi:collision_detect::@39->collision_data]
    // [150] phi collision_data::collision_decision#2 = &collision_detect::collision_inner [phi:collision_detect::@39->collision_data#0] -- pssz1=pssc1 
    lda #<collision_inner
    sta.z collision_data.collision_decision
    lda #>collision_inner
    sta.z collision_data.collision_decision+1
    // [150] phi collision_data::return#0 = collision_data::collision#1 [phi:collision_detect::@39->collision_data#1] -- register_copy 
    jsr collision_data
    // collision_data(inner, &collision_inner)
    // [42] collision_data::return#3 = collision_data::return#0
    // collision_detect::@43
    // inner = collision_data(inner, &collision_inner)
    // [43] collision_detect::inner#1 = collision_data::return#3 -- vbuz1=vbuxx 
    stx.z inner
    // if (collision_outer.side != collision_inner.side)
    // [44] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE)==*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_eq__deref_pbuc2_then_la1 
    lda.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    bne !ht_get_next3+
    jmp ht_get_next3
  !ht_get_next3:
    // collision_detect::@30
    // if (collision_inner.min_x > collision_outer.max_x || collision_inner.min_y > collision_outer.max_y ||
    //                                     collision_inner.max_x < collision_outer.min_x || collision_inner.max_y < collision_outer.min_y)
    // [45] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X)>*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_gt__deref_pbuc2_then_la1 
    lda.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X
    bcs !ht_get_next3+
    jmp ht_get_next3
  !ht_get_next3:
    // collision_detect::@46
    // [46] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y)>*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_gt__deref_pbuc2_then_la1 
    lda.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y
    bcs !ht_get_next3+
    jmp ht_get_next3
  !ht_get_next3:
    // collision_detect::@45
    // [47] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X)<*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X
    cmp.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X
    bcc ht_get_next3
    // collision_detect::@44
    // [48] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y)<*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y)) goto collision_detect::ht_get_next3 -- _deref_pbuc1_lt__deref_pbuc2_then_la1 
    lda.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y
    cmp.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y
    bcc ht_get_next3
    // collision_detect::@31
    // if (collision_outer.side == SIDE_ENEMY)
    // [49] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE)==1) goto collision_detect::@8 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #1
    cmp.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    bne !__b8+
    jmp __b8
  !__b8:
    // collision_detect::@32
    // case FLIGHT_BULLET:
    //                                             if (collision_inner.type == FLIGHT_ENEMY) {
    //                                                 collision_detected++;
    //                                             }
    //                                             if (collision_inner.type == FLIGHT_TOWER) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [50] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==3) goto collision_detect::@9 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #3
    cmp.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b9
    // collision_detect::@33
    // case FLIGHT_PLAYER:
    //                                             if (collision_inner.type == FLIGHT_ENEMY) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [51] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==0) goto collision_detect::@10 -- _deref_pbuc1_eq_0_then_la1 
    lda.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b10
    // [52] phi from collision_detect::@10 collision_detect::@16 collision_detect::@18 collision_detect::@27 collision_detect::@33 to collision_detect::@15 [phi:collision_detect::@10/collision_detect::@16/collision_detect::@18/collision_detect::@27/collision_detect::@33->collision_detect::@15]
  __b12:
    // [52] phi collision_detect::collision_detected#11 = 0 [phi:collision_detect::@10/collision_detect::@16/collision_detect::@18/collision_detect::@27/collision_detect::@33->collision_detect::@15#0] -- vbuxx=vbuc1 
    ldx #0
    // [52] phi from collision_detect::@11 collision_detect::@13 collision_detect::@19 collision_detect::@22 to collision_detect::@15 [phi:collision_detect::@11/collision_detect::@13/collision_detect::@19/collision_detect::@22->collision_detect::@15]
    // [52] phi collision_detect::collision_detected#11 = collision_detect::collision_detected#17 [phi:collision_detect::@11/collision_detect::@13/collision_detect::@19/collision_detect::@22->collision_detect::@15#0] -- register_copy 
    // collision_detect::@15
  __b15:
    // if(collision_detected)
    // [53] if(0==collision_detect::collision_detected#11) goto collision_detect::ht_get_next3 -- 0_eq_vbuxx_then_la1 
    cpx #0
    beq ht_get_next3
    // collision_detect::@28
    // flight_has_collided(outer)
    // [54] flight_has_collided::f = collision_detect::outer#1 -- vbum1=vbuz2 
    lda.z outer
    sta equinoxe_flightengine.flight_has_collided.f
    // [55] callexecute flight_has_collided  -- call_var_near 
    jsr equinoxe_flightengine.flight_has_collided
    // [56] collision_detect::$37 = flight_has_collided::return -- vbuaa=vbum1 
    lda equinoxe_flightengine.flight_has_collided.return
    // if(!flight_has_collided(outer))
    // [57] if(0!=collision_detect::$37) goto collision_detect::@24 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b24
    // collision_detect::@29
    // stage_impact(outer, inner)
    // [58] stage_impact::f = collision_detect::outer#1 -- vbum1=vbuz2 
    lda.z outer
    sta equinoxe_stage_flight.stage_impact.f
    // [59] stage_impact::h = collision_detect::inner#1 -- vbum1=vbuz2 
    lda.z inner
    sta equinoxe_stage_flight.stage_impact.h
    // [60] callexecute stage_impact  -- call_var_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #3
    sta.z 0
    lda.z $ff
    jsr equinoxe_stage_flight.stage_impact
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // collision_detect::@24
  __b24:
    // flight_has_collided(inner)
    // [61] flight_has_collided::f = collision_detect::inner#1 -- vbum1=vbuz2 
    lda.z inner
    sta equinoxe_flightengine.flight_has_collided.f
    // [62] callexecute flight_has_collided  -- call_var_near 
    jsr equinoxe_flightengine.flight_has_collided
    // [63] collision_detect::$41 = flight_has_collided::return -- vbuaa=vbum1 
    lda equinoxe_flightengine.flight_has_collided.return
    // if(!flight_has_collided(inner))
    // [64] if(0!=collision_detect::$41) goto collision_detect::ht_get_next3 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne ht_get_next3
    // collision_detect::@25
    // stage_impact(inner, outer)
    // [65] stage_impact::f = collision_detect::inner#1 -- vbum1=vbuz2 
    lda.z inner
    sta equinoxe_stage_flight.stage_impact.f
    // [66] stage_impact::h = collision_detect::outer#1 -- vbum1=vbuz2 
    lda.z outer
    sta equinoxe_stage_flight.stage_impact.h
    // [67] callexecute stage_impact  -- call_var_close_cx16_ram 
    sta.z $ff
    lda.z 0
    pha
    lda #3
    sta.z 0
    lda.z $ff
    jsr equinoxe_stage_flight.stage_impact
    sta.z $ff
    pla
    sta.z 0
    lda.z $ff
    // collision_detect::ht_get_next3
  ht_get_next3:
    // return ht_list.next[ht_index];
    // [68] collision_detect::ht_get_next3_return#0 = ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[collision_detect::ht_get_next3_ht_index#0] -- vbuz1=pbuc1_derefidx_vbuz1 
    ldy.z ht_get_next3_return
    lda ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    sta.z ht_get_next3_return
    jmp __b6
    // collision_detect::@10
  __b10:
    // if (collision_inner.type == FLIGHT_ENEMY)
    // [69] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=1) goto collision_detect::@15 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    bne __b12
    // [70] phi from collision_detect::@10 to collision_detect::@14 [phi:collision_detect::@10->collision_detect::@14]
    // collision_detect::@14
  __b14:
    // [52] phi from collision_detect::@14 collision_detect::@20 collision_detect::@23 to collision_detect::@15 [phi:collision_detect::@14/collision_detect::@20/collision_detect::@23->collision_detect::@15]
    // [52] phi collision_detect::collision_detected#11 = 1 [phi:collision_detect::@14/collision_detect::@20/collision_detect::@23->collision_detect::@15#0] -- vbuxx=vbuc1 
    ldx #1
    jmp __b15
    // collision_detect::@9
  __b9:
    // if (collision_inner.type == FLIGHT_ENEMY)
    // [71] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=1) goto collision_detect::@11 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #1
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    bne __b13
    // [72] phi from collision_detect::@9 to collision_detect::@12 [phi:collision_detect::@9->collision_detect::@12]
    // collision_detect::@12
    // [73] phi from collision_detect::@12 to collision_detect::@11 [phi:collision_detect::@12->collision_detect::@11]
    // [73] phi collision_detect::collision_detected#17 = 1 [phi:collision_detect::@12->collision_detect::@11#0] -- vbuxx=vbuc1 
    tax
    jmp __b11
    // [73] phi from collision_detect::@9 to collision_detect::@11 [phi:collision_detect::@9->collision_detect::@11]
  __b13:
    // [73] phi collision_detect::collision_detected#17 = 0 [phi:collision_detect::@9->collision_detect::@11#0] -- vbuxx=vbuc1 
    ldx #0
    // collision_detect::@11
  __b11:
    // if (collision_inner.type == FLIGHT_TOWER)
    // [74] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=2) goto collision_detect::@15 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #2
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b15+
    jmp __b15
  !__b15:
    // collision_detect::@13
    // collision_detected++;
    // [75] collision_detect::collision_detected#2 = ++ collision_detect::collision_detected#17 -- vbuxx=_inc_vbuxx 
    inx
    jmp __b15
    // collision_detect::@8
  __b8:
    // case FLIGHT_BULLET:
    //                                             if (collision_inner.type == FLIGHT_PLAYER) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [76] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==3) goto collision_detect::@16 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #3
    cmp.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b16
    // collision_detect::@26
    // case FLIGHT_ENEMY:
    //                                             if (collision_inner.type == FLIGHT_BULLET) {
    //                                                 collision_detected++;
    //                                             }
    //                                             if (collision_inner.type == FLIGHT_PLAYER) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [77] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==1) goto collision_detect::@17 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #1
    cmp.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b17
    // collision_detect::@27
    // case FLIGHT_TOWER:
    //                                             if (collision_inner.type == FLIGHT_BULLET) {
    //                                                 collision_detected++;
    //                                             }
    //                                             break;
    // [78] if(*((char *)&collision_detect::collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)==2) goto collision_detect::@18 -- _deref_pbuc1_eq_vbuc2_then_la1 
    lda #2
    cmp.z collision_outer+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq __b18
    jmp __b12
    // collision_detect::@18
  __b18:
    // if (collision_inner.type == FLIGHT_BULLET)
    // [79] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=3) goto collision_detect::@15 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #3
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b12+
    jmp __b12
  !__b12:
    // [80] phi from collision_detect::@18 to collision_detect::@23 [phi:collision_detect::@18->collision_detect::@23]
    // collision_detect::@23
    jmp __b14
    // collision_detect::@17
  __b17:
    // if (collision_inner.type == FLIGHT_BULLET)
    // [81] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=3) goto collision_detect::@19 -- _deref_pbuc1_neq_vbuc2_then_la1 
    lda #3
    cmp.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    bne __b20
    // [82] phi from collision_detect::@17 to collision_detect::@21 [phi:collision_detect::@17->collision_detect::@21]
    // collision_detect::@21
    // [83] phi from collision_detect::@21 to collision_detect::@19 [phi:collision_detect::@21->collision_detect::@19]
    // [83] phi collision_detect::collision_detected#14 = 1 [phi:collision_detect::@21->collision_detect::@19#0] -- vbuxx=vbuc1 
    ldx #1
    jmp __b19
    // [83] phi from collision_detect::@17 to collision_detect::@19 [phi:collision_detect::@17->collision_detect::@19]
  __b20:
    // [83] phi collision_detect::collision_detected#14 = 0 [phi:collision_detect::@17->collision_detect::@19#0] -- vbuxx=vbuc1 
    ldx #0
    // collision_detect::@19
  __b19:
    // if (collision_inner.type == FLIGHT_PLAYER)
    // [84] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=0) goto collision_detect::@15 -- _deref_pbuc1_neq_0_then_la1 
    lda.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b15+
    jmp __b15
  !__b15:
    // collision_detect::@22
    // collision_detected++;
    // [85] collision_detect::collision_detected#6 = ++ collision_detect::collision_detected#14 -- vbuxx=_inc_vbuxx 
    inx
    jmp __b15
    // collision_detect::@16
  __b16:
    // if (collision_inner.type == FLIGHT_PLAYER)
    // [86] if(*((char *)&collision_detect::collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE)!=0) goto collision_detect::@15 -- _deref_pbuc1_neq_0_then_la1 
    lda.z collision_inner+OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    beq !__b12+
    jmp __b12
  !__b12:
    // [87] phi from collision_detect::@16 to collision_detect::@20 [phi:collision_detect::@16->collision_detect::@20]
    // collision_detect::@20
    jmp __b14
}
  // collision_insert
/**
 * @brief Add a new coordinate to the spacial grid.
 * This routine is very tricky. It requires to carefully determine which sectors
 * in the spacial grid are to be inserted in the has table.
 * And this is not obvious, sometimes also negative coordinates are given, like -64.
 * This has a risk of ending in an endless loop!
 * So the xmin and ymin are taken as char values, while the xmax and ymax values are taken as int values.
 * This to carefully compare the increment of ymin from 0x00F0 to 0x0100 and not to 0x0000!
 * Same for the xmin value. So the gx and gy values are also int to ensure that the addition is taken in two bytes.
 * But note that only the lower bytes of the int values are actually stored in the spacial grid coordinate system!
 *
 * @param ht
 * @param group
 * @param xmin
 * @param ymin
 * @param f
 */
// void collision_insert(__zp($25) char f)
collision_insert: {
    .label f = $25
    .label xmin = $2d
    .label ymin = $2b
    .label ymax = $29
    .label xmax = $27
    .label gx = $2a
    .label gy = $28
    // unsigned char xmin = flight.xi[f] >> 2
    // [92] collision_insert::$12 = collision_insert::f << 1 -- vbuaa=vbuz1_rol_1 
    lda.z f
    asl
    // [93] collision_insert::xmin#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_XI)[collision_insert::$12] >> 2 -- vbuz1=pwuc1_derefidx_vbuaa_ror_2 
    tay
    clc
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI+1,y
    ror
    sta.z $ff
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_XI,y
    ror
    sta.z $fe
    clc
    ror.z $ff
    ror
    sta.z xmin
    // unsigned char ymin = flight.yi[f] >> 2
    // [94] collision_insert::$13 = collision_insert::f << 1 -- vbuaa=vbuz1_rol_1 
    lda.z f
    asl
    // [95] collision_insert::ymin#0 = ((unsigned int *)&flight+OFFSET_STRUCT_FLIGHT_T_YI)[collision_insert::$13] >> 2 -- vbuxx=pwuc1_derefidx_vbuaa_ror_2 
    tax
    clc
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI+1,x
    ror
    sta.z $ff
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_YI,x
    ror
    sta.z $fe
    clc
    ror.z $ff
    ror
    tax
    // flight.cx[f] = xmin
    // [96] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CX)[collision_insert::f] = collision_insert::xmin#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z xmin
    ldy.z f
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CX,y
    // flight.cy[f] = ymin
    // [97] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CY)[collision_insert::f] = collision_insert::ymin#0 -- pbuc1_derefidx_vbuz1=vbuxx 
    txa
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CY,y
    // flight.collided[f] = 0
    // [98] ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED)[collision_insert::f] = 0 -- pbuc1_derefidx_vbuz1=vbuc2 
    lda #0
    sta equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_COLLIDED,y
    // xmin += 16
    // [99] collision_insert::xmin#1 = collision_insert::xmin#0 + $10 -- vbuyy=vbuz1_plus_vbuc1 
    // The coordinates start at -63, so we add 16 to avoid negative numbers in the grid key.
    lda #$10
    clc
    adc.z xmin
    tay
    // ymin += 16
    // [100] collision_insert::ymin#1 = collision_insert::ymin#0 + $10 -- vbuz1=vbuxx_plus_vbuc1 
    txa
    clc
    adc #$10
    sta.z ymin
    // (unsigned char)xmin + 8
    // [101] collision_insert::$2 = collision_insert::xmin#1 + 8 -- vbuaa=vbuyy_plus_vbuc1 
    tya
    clc
    adc #8
    // unsigned char xmax = ((unsigned char)xmin + 8) & 0b11110000
    // [102] collision_insert::xmax#0 = collision_insert::$2 & $f0 -- vbuxx=vbuaa_band_vbuc1 
    and #$f0
    tax
    // (unsigned char)ymin + 8
    // [103] collision_insert::$4 = collision_insert::ymin#1 + 8 -- vbuaa=vbuz1_plus_vbuc1 
    lda #8
    clc
    adc.z ymin
    // unsigned char ymax = ((unsigned char)ymin + 8) & 0b11110000
    // [104] collision_insert::ymax#0 = collision_insert::$4 & $f0 -- vbuz1=vbuaa_band_vbuc1 
    and #$f0
    sta.z ymax
    // xmin >>= 4
    // [105] collision_insert::gx#0 = collision_insert::xmin#1 >> 4 -- vbuz1=vbuyy_ror_4 
    tya
    lsr
    lsr
    lsr
    lsr
    sta.z gx
    // xmax >>= 4
    // [106] collision_insert::xmax#1 = collision_insert::xmax#0 >> 4 -- vbuz1=vbuxx_ror_4 
    txa
    lsr
    lsr
    lsr
    lsr
    sta.z xmax
    // ymin = ymin & 0b11110000
    // [107] collision_insert::ymin#2 = collision_insert::ymin#1 & $f0 -- vbuz1=vbuz1_band_vbuc1 
    lda #$f0
    and.z ymin
    sta.z ymin
    // [108] phi from collision_insert collision_insert::@5 to collision_insert::@1 [phi:collision_insert/collision_insert::@5->collision_insert::@1]
    // [108] phi collision_insert::gx#2 = collision_insert::gx#0 [phi:collision_insert/collision_insert::@5->collision_insert::@1#0] -- register_copy 
    // collision_insert::@1
  __b1:
    // for (unsigned char gx = xmin; gx <= xmax; gx += 1)
    // [109] if(collision_insert::gx#2<=collision_insert::xmax#1) goto collision_insert::@2 -- vbuz1_le_vbuz2_then_la1 
    lda.z xmax
    cmp.z gx
    bcs __b2
    // collision_insert::@return
    // }
    // [110] return 
    rts
    // collision_insert::@2
  __b2:
    // [111] collision_insert::gy#6 = collision_insert::ymin#2 -- vbuz1=vbuz2 
    lda.z ymin
    sta.z gy
    // [112] phi from collision_insert::@2 collision_insert::@7 to collision_insert::@3 [phi:collision_insert::@2/collision_insert::@7->collision_insert::@3]
    // [112] phi collision_insert::gy#2 = collision_insert::gy#6 [phi:collision_insert::@2/collision_insert::@7->collision_insert::@3#0] -- register_copy 
    // collision_insert::@3
  __b3:
    // for (unsigned char gy = ymin; gy <= ymax; gy += 16)
    // [113] if(collision_insert::gy#2<=collision_insert::ymax#0) goto collision_insert::@4 -- vbuz1_le_vbuz2_then_la1 
    lda.z ymax
    cmp.z gy
    bcs __b4
    // collision_insert::@5
    // gx += 1
    // [114] collision_insert::gx#1 = collision_insert::gx#2 + 1 -- vbuz1=vbuz1_plus_1 
    inc.z gx
    jmp __b1
    // collision_insert::@4
  __b4:
    // ht_key_t ht_key = collision_key((unsigned char)gx, (unsigned char)gy)
    // [115] collision_key::gx#0 = collision_insert::gx#2 -- vbuaa=vbuz1 
    lda.z gx
    // [116] collision_key::gy#0 = collision_insert::gy#2 -- vbuxx=vbuz1 
    ldx.z gy
    // [117] call collision_key
    // [135] phi from collision_insert::@4 to collision_key [phi:collision_insert::@4->collision_key]
    // [135] phi collision_key::gx#2 = collision_key::gx#0 [phi:collision_insert::@4->collision_key#0] -- register_copy 
    // [135] phi collision_key::gy#2 = collision_key::gy#0 [phi:collision_insert::@4->collision_key#1] -- register_copy 
    jsr collision_key
    // ht_key_t ht_key = collision_key((unsigned char)gx, (unsigned char)gy)
    // [118] collision_key::return#2 = collision_key::return#0
    // collision_insert::@6
    // [119] collision_insert::ht_key#0 = collision_key::return#2
    // ht_insert(&collision_hash, ht_key, f)
    // [120] ht_insert::key#0 = collision_insert::ht_key#0 -- vbuz1=vbuaa 
    sta.z ht_insert.key
    // [121] ht_insert::data#0 = collision_insert::f -- vbuz1=vbuz2 
    lda.z f
    sta.z ht_insert.data
    // [122] call ht_insert
    // [171] phi from collision_insert::@6 to ht_insert [phi:collision_insert::@6->ht_insert]
    jsr ht_insert
    // collision_insert::@7
    // gy + gx
    // [123] collision_insert::$11 = collision_insert::gy#2 + collision_insert::gx#2 -- vbuaa=vbuz1_plus_vbuz2 
    lda.z gy
    clc
    adc.z gx
    // collision_quadrant.cell[gy + gx] += 1
    // [124] ((char *)&collision_quadrant)[collision_insert::$11] = ((char *)&collision_quadrant)[collision_insert::$11] + 1 -- pbuc1_derefidx_vbuaa=pbuc1_derefidx_vbuaa_plus_1 
    tay
    lda collision_quadrant,y
    inc
    sta collision_quadrant,y
    // gy += 16
    // [125] collision_insert::gy#1 = collision_insert::gy#2 + $10 -- vbuz1=vbuz1_plus_vbuc1 
    lda #$10
    clc
    adc.z gy
    sta.z gy
    jmp __b3
}
  // collision_init
// void collision_init()
collision_init: {
    .const memset_fast1_ch = 0
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = collision_quadrant
    // ht_init(&collision_hash)
    // [127] call ht_init
    // [186] phi from collision_init to ht_init [phi:collision_init->ht_init]
    jsr ht_init
    // [128] phi from collision_init to collision_init::memset_fast1 [phi:collision_init->collision_init::memset_fast1]
    // collision_init::memset_fast1
    // [129] phi from collision_init::memset_fast1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1]
    // [129] phi collision_init::memset_fast1_num#2 = 0 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [129] phi collision_init::memset_fast1_x#2 = 0 [phi:collision_init::memset_fast1->collision_init::memset_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [129] phi from collision_init::memset_fast1_@1 to collision_init::memset_fast1_@1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1]
    // [129] phi collision_init::memset_fast1_num#2 = collision_init::memset_fast1_num#1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1#0] -- register_copy 
    // [129] phi collision_init::memset_fast1_x#2 = collision_init::memset_fast1_x#1 [phi:collision_init::memset_fast1_@1->collision_init::memset_fast1_@1#1] -- register_copy 
    // collision_init::memset_fast1_@1
  memset_fast1___b1:
    // destination[x] = ch
    // [130] collision_init::memset_fast1_destination#0[collision_init::memset_fast1_x#2] = collision_init::memset_fast1_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast1_ch
    sta memset_fast1_destination,y
    // x++;
    // [131] collision_init::memset_fast1_x#1 = ++ collision_init::memset_fast1_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [132] collision_init::memset_fast1_num#1 = -- collision_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [133] if(0!=collision_init::memset_fast1_num#1) goto collision_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // collision_init::@return
    // }
    // [134] return 
    rts
}
  // collision_key
// __register(A) char collision_key(__register(A) char gx, __register(X) char gy)
collision_key: {
    // unsigned char key = gy + gx
    // [136] collision_key::return#0 = collision_key::gy#2 + collision_key::gx#2 -- vbuaa=vbuxx_plus_vbuaa 
    stx.z $ff
    clc
    adc.z $ff
    // collision_key::@return
    // }
    // [137] return 
    rts
}
  // ht_get
// ht_index_t ht_hash_next(ht_index_t index)
// {
//    asm{
//                    lda ht_seed
//                    beq !doEor+
//                    asl
//                    beq !noEor+
//                    bcc !noEor+
//        !doEor:    eor #$2b
//        !noEor:    sta ht_seed
//    }
//    return ht_seed;
// }
// __register(A) char ht_get(ht_item_t *ht, __zp($23) char key)
ht_get: {
    .label ht = collision_hash
    .label key = $23
    // [139] phi from ht_get to ht_get::ht_hash1 [phi:ht_get->ht_get::ht_hash1]
    // ht_get::ht_hash1
    // ht_get::@4
    // [140] ht_get::ht_index#6 = ht_get::key#0 -- vbuxx=vbuz1 
    ldx.z key
    // [141] phi from ht_get::@4 ht_get::ht_hash_next1 to ht_get::@1 [phi:ht_get::@4/ht_get::ht_hash_next1->ht_get::@1]
    // [141] phi ht_get::ht_index#2 = ht_get::ht_index#6 [phi:ht_get::@4/ht_get::ht_hash_next1->ht_get::@1#0] -- register_copy 
    // ht_get::@1
  __b1:
    // ht_next = ht->next[ht_index]
    // [142] ht_get::ht_next#1 = ((char *)ht_get::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_get::ht_index#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    // while ((ht_next = ht->next[ht_index]))
    // [143] if(0!=ht_get::ht_next#1) goto ht_get::@2 -- 0_neq_vbuaa_then_la1 
    cmp #0
    bne __b2
    // [144] phi from ht_get::@1 to ht_get::@return [phi:ht_get::@1->ht_get::@return]
    // [144] phi ht_get::return#2 = 0 [phi:ht_get::@1->ht_get::@return#0] -- vbuaa=vbuc1 
    lda #0
    // ht_get::@return
    // }
    // [145] return 
    rts
    // ht_get::@2
  __b2:
    // ht_key = ht->key[ht_index]
    // [146] ht_get::ht_key#1 = ((char *)ht_get::ht#0)[ht_get::ht_index#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda ht,x
    // if ((ht_key = ht->key[ht_index]) == key)
    // [147] if(ht_get::ht_key#1!=ht_get::key#0) goto ht_get::ht_hash_next1 -- vbuaa_neq_vbuz1_then_la1 
    cmp.z key
    bne ht_hash_next1
    // ht_get::@3
    // return ht->next[ht_index];
    // [148] ht_get::return#1 = ((char *)ht_get::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_get::ht_index#2] -- vbuaa=pbuc1_derefidx_vbuxx 
    lda ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    // [144] phi from ht_get::@3 to ht_get::@return [phi:ht_get::@3->ht_get::@return]
    // [144] phi ht_get::return#2 = ht_get::return#1 [phi:ht_get::@3->ht_get::@return#0] -- register_copy 
    rts
    // ht_get::ht_hash_next1
  ht_hash_next1:
    // index+1
    // [149] ht_get::ht_hash_next1_return#0 = ht_get::ht_index#2 + 1 -- vbuxx=vbuxx_plus_1 
    inx
    jmp __b1
}
  // collision_data
/*
inline void collision_debug() {
    gotoxy(0, 0);
    printf("hash root = %04p, ", &collision_hash);
    printf("hash list = %04p, ", &ht_list);
    printf("hash quadrant = %04p \n", &collision_quadrant);

    ht_display(&collision_hash);
}
*/
// __register(X) char collision_data(__register(X) char collision, __zp($2e) collision_decision_t *collision_decision)
collision_data: {
    .label type = $29
    .label side = $27
    .label x = $26
    .label y = $22
    .label s = $25
    .label collision_decision = $2e
    // unsigned char type = flight.type[collision]
    // [151] collision_data::type#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_TYPE)[collision_data::return#0] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_TYPE,x
    sta.z type
    // unsigned char side = flight.side[collision]
    // [152] collision_data::side#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_SIDE)[collision_data::return#0] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_SIDE,x
    sta.z side
    // unsigned char x = flight.cx[collision]
    // [153] collision_data::x#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CX)[collision_data::return#0] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CX,x
    sta.z x
    // unsigned char y = flight.cy[collision]
    // [154] collision_data::y#0 = ((char *)&flight+OFFSET_STRUCT_FLIGHT_T_CY)[collision_data::return#0] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight+OFFSET_STRUCT_FLIGHT_T_CY,x
    sta.z y
    // unsigned char s = flight.cache[collision]
    // [155] collision_data::s#0 = ((char *)&flight)[collision_data::return#0] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda equinoxe_flightengine.flight,x
    sta.z s
    // collision_decision->collision = collision
    // [156] *((char *)collision_data::collision_decision#2) = collision_data::return#0 -- _deref_pbuz1=vbuxx 
    // Which sprite is it in the cache...
    txa
    ldy #0
    sta (collision_decision),y
    // collision_decision->s = s
    // [157] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_S] = collision_data::s#0 -- pbuz1_derefidx_vbuc1=vbuz2 
    lda.z s
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_S
    sta (collision_decision),y
    // collision_decision->x = x
    // [158] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_X] = collision_data::x#0 -- pbuz1_derefidx_vbuc1=vbuz2 
    lda.z x
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_X
    sta (collision_decision),y
    // collision_decision->y = y
    // [159] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_Y] = collision_data::y#0 -- pbuz1_derefidx_vbuc1=vbuz2 
    lda.z y
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_Y
    sta (collision_decision),y
    // collision_decision->side = side
    // [160] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_SIDE] = collision_data::side#0 -- pbuz1_derefidx_vbuc1=vbuz2 
    lda.z side
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_SIDE
    sta (collision_decision),y
    // collision_decision->type = type
    // [161] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_TYPE] = collision_data::type#0 -- pbuz1_derefidx_vbuc1=vbuz2 
    lda.z type
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_TYPE
    sta (collision_decision),y
    // x + sprite_cache.xmin[s]
    // [162] collision_data::$0 = collision_data::x#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN)[collision_data::s#0] -- vbuaa=vbuz1_plus_pbuc1_derefidx_vbuz2 
    lda.z x
    ldy.z s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMIN,y
    // collision_decision->min_x = x + sprite_cache.xmin[s]
    // [163] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X] = collision_data::$0 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MIN_X
    sta (collision_decision),y
    // y + sprite_cache.ymin[s]
    // [164] collision_data::$1 = collision_data::y#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN)[collision_data::s#0] -- vbuaa=vbuz1_plus_pbuc1_derefidx_vbuz2 
    lda.z y
    ldy.z s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMIN,y
    // collision_decision->min_y = y + sprite_cache.ymin[s]
    // [165] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y] = collision_data::$1 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MIN_Y
    sta (collision_decision),y
    // x + sprite_cache.xmax[s]
    // [166] collision_data::$2 = collision_data::x#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX)[collision_data::s#0] -- vbuaa=vbuz1_plus_pbuc1_derefidx_vbuz2 
    lda.z x
    ldy.z s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_XMAX,y
    // collision_decision->max_x = x + sprite_cache.xmax[s]
    // [167] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X] = collision_data::$2 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MAX_X
    sta (collision_decision),y
    // y + sprite_cache.ymax[s]
    // [168] collision_data::$3 = collision_data::y#0 + ((char *)&sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX)[collision_data::s#0] -- vbuaa=vbuz1_plus_pbuc1_derefidx_vbuz2 
    lda.z y
    ldy.z s
    clc
    adc equinoxe_flightengine.sprite_cache+OFFSET_STRUCT_FE_SPRITE_CACHE_T_YMAX,y
    // collision_decision->max_y = y + sprite_cache.ymax[s]
    // [169] ((char *)collision_data::collision_decision#2)[OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y] = collision_data::$3 -- pbuz1_derefidx_vbuc1=vbuaa 
    ldy #OFFSET_STRUCT_COLLISION_DECISION_T_MAX_Y
    sta (collision_decision),y
    // collision_data::@return
    // }
    // [170] return 
    rts
}
  // ht_insert
// char ht_insert(ht_item_t *ht, __zp($24) char key, __zp($26) char data)
ht_insert: {
    .label ht = collision_hash
    .label ht_next = $22
    .label key = $24
    .label data = $26
    // [172] phi from ht_insert to ht_insert::ht_hash1 [phi:ht_insert->ht_insert::ht_hash1]
    // ht_insert::ht_hash1
    // ht_insert::@3
    // [173] ht_insert::ht_index#5 = ht_insert::key#0 -- vbuxx=vbuz1 
    ldx.z key
    // [174] phi from ht_insert::@3 ht_insert::ht_hash_next1 to ht_insert::@1 [phi:ht_insert::@3/ht_insert::ht_hash_next1->ht_insert::@1]
    // [174] phi ht_insert::ht_index#2 = ht_insert::ht_index#5 [phi:ht_insert::@3/ht_insert::ht_hash_next1->ht_insert::@1#0] -- register_copy 
    // ht_insert::@1
  __b1:
    // ht_next = ht->next[ht_index]
    // [175] ht_insert::ht_next#1 = ((char *)ht_insert::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_insert::ht_index#2] -- vbuz1=pbuc1_derefidx_vbuxx 
    lda ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    sta.z ht_next
    // ht_key = ht->key[ht_index]
    // [176] ht_insert::ht_key#1 = ((char *)ht_insert::ht#0)[ht_insert::ht_index#2] -- vbuyy=pbuc1_derefidx_vbuxx 
    ldy ht,x
    // while ((ht_next = ht->next[ht_index]) && (ht_key = ht->key[ht_index]) != key)
    // [177] if(0==ht_insert::ht_next#1) goto ht_insert::@2 -- 0_eq_vbuz1_then_la1 
    beq __b2
    // ht_insert::@4
    // [178] if(ht_insert::ht_key#1!=ht_insert::key#0) goto ht_insert::ht_hash_next1 -- vbuyy_neq_vbuz1_then_la1 
    cpy.z key
    bne ht_hash_next1
    // ht_insert::@2
  __b2:
    // ht->key[ht_index] = key
    // [179] ((char *)ht_insert::ht#0)[ht_insert::ht_index#2] = ht_insert::key#0 -- pbuc1_derefidx_vbuxx=vbuz1 
    lda.z key
    sta ht,x
    // ht_list.data[ht_list_pool] = data
    // [180] ((char *)&ht_list)[ht_list_pool] = ht_insert::data#0 -- pbuc1_derefidx_vbuz1=vbuz2 
    lda.z data
    ldy.z ht_list_pool
    sta ht_list,y
    // ht_list.next[ht_list_pool] = ht_next
    // [181] ((char *)&ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT)[ht_list_pool] = ht_insert::ht_next#1 -- pbuc1_derefidx_vbuz1=vbuz2 
    // Now the new node becomes the first node in the list;
    lda.z ht_next
    sta ht_list+OFFSET_STRUCT_HT_LIST_S_NEXT,y
    // ht->next[ht_index] = ht_list_pool
    // [182] ((char *)ht_insert::ht#0+OFFSET_STRUCT_HT_ITEM_T_NEXT)[ht_insert::ht_index#2] = ht_list_pool -- pbuc1_derefidx_vbuxx=vbuz1 
    tya
    sta ht+OFFSET_STRUCT_HT_ITEM_T_NEXT,x
    // ht_list_pool--;
    // [183] ht_list_pool = -- ht_list_pool -- vbuz1=_dec_vbuz1 
    dec.z ht_list_pool
    // ht_insert::@return
    // }
    // [184] return 
    rts
    // ht_insert::ht_hash_next1
  ht_hash_next1:
    // index+1
    // [185] ht_insert::ht_hash_next1_return#0 = ht_insert::ht_index#2 + 1 -- vbuxx=vbuxx_plus_1 
    inx
    jmp __b1
}
  // ht_init
// void ht_init(ht_item_t *ht)
ht_init: {
    .const memset_fast1_ch = 0
    .const memset_fast2_ch = 0
    .label ht = collision_hash
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast1_destination = ht
    // heap_segment_define(&ht_heap, &ht_heap_list, 8, ht_size, 8*ht_size); // Each list item is maximum 8 bytes on the heap!
    .label memset_fast2_destination = ht+OFFSET_STRUCT_HT_ITEM_T_NEXT
    // [187] phi from ht_init to ht_init::memset_fast1 [phi:ht_init->ht_init::memset_fast1]
    // ht_init::memset_fast1
    // [188] phi from ht_init::memset_fast1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1]
    // [188] phi ht_init::memset_fast1_num#2 = 0 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [188] phi ht_init::memset_fast1_x#2 = 0 [phi:ht_init::memset_fast1->ht_init::memset_fast1_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [188] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast1_@1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1]
    // [188] phi ht_init::memset_fast1_num#2 = ht_init::memset_fast1_num#1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1#0] -- register_copy 
    // [188] phi ht_init::memset_fast1_x#2 = ht_init::memset_fast1_x#1 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast1_@1#1] -- register_copy 
    // ht_init::memset_fast1_@1
  memset_fast1___b1:
    // destination[x] = ch
    // [189] ht_init::memset_fast1_destination#0[ht_init::memset_fast1_x#2] = ht_init::memset_fast1_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast1_ch
    sta memset_fast1_destination,y
    // x++;
    // [190] ht_init::memset_fast1_x#1 = ++ ht_init::memset_fast1_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [191] ht_init::memset_fast1_num#1 = -- ht_init::memset_fast1_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [192] if(0!=ht_init::memset_fast1_num#1) goto ht_init::memset_fast1_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast1___b1
    // [193] phi from ht_init::memset_fast1_@1 to ht_init::memset_fast2 [phi:ht_init::memset_fast1_@1->ht_init::memset_fast2]
    // ht_init::memset_fast2
    // [194] phi from ht_init::memset_fast2 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1]
    // [194] phi ht_init::memset_fast2_num#2 = 0 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1#0] -- vbuxx=vbuc1 
    ldx #0
    // [194] phi ht_init::memset_fast2_x#2 = 0 [phi:ht_init::memset_fast2->ht_init::memset_fast2_@1#1] -- vbuyy=vbuc1 
    ldy #0
    // [194] phi from ht_init::memset_fast2_@1 to ht_init::memset_fast2_@1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1]
    // [194] phi ht_init::memset_fast2_num#2 = ht_init::memset_fast2_num#1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1#0] -- register_copy 
    // [194] phi ht_init::memset_fast2_x#2 = ht_init::memset_fast2_x#1 [phi:ht_init::memset_fast2_@1->ht_init::memset_fast2_@1#1] -- register_copy 
    // ht_init::memset_fast2_@1
  memset_fast2___b1:
    // destination[x] = ch
    // [195] ht_init::memset_fast2_destination#0[ht_init::memset_fast2_x#2] = ht_init::memset_fast2_ch#0 -- pbuc1_derefidx_vbuyy=vbuc2 
    lda #memset_fast2_ch
    sta memset_fast2_destination,y
    // x++;
    // [196] ht_init::memset_fast2_x#1 = ++ ht_init::memset_fast2_x#2 -- vbuyy=_inc_vbuyy 
    iny
    // num--;
    // [197] ht_init::memset_fast2_num#1 = -- ht_init::memset_fast2_num#2 -- vbuxx=_dec_vbuxx 
    dex
    // while(num)
    // [198] if(0!=ht_init::memset_fast2_num#1) goto ht_init::memset_fast2_@1 -- 0_neq_vbuxx_then_la1 
    cpx #0
    bne memset_fast2___b1
    // ht_init::@1
    // ht_list_pool = HT_SIZE-1
    // [199] ht_list_pool = $100-1 -- vbuz1=vwuc1 
    lda #<$100-1
    sta.z ht_list_pool
    // ht_init::@return
    // }
    // [200] return 
    rts
}
  // Exported Global Data
.segment Data
  ht_list: .fill equinoxe_collision.SIZEOF_STRUCT_HT_LIST_S, 0
.segment Hash
  collision_hash: .fill equinoxe_collision.SIZEOF_STRUCT_HT_ITEM_T, 0
  collision_quadrant: .fill equinoxe_collision.SIZEOF_STRUCT_COLLISION_QUADRANT_T, 0
} // namespace
 // Asm import library equinoxe-layers:
#define __asm_import__equinoxe_layers__
#import "equinoxe-layers.asm"

 // Asm import library equinoxe-animate:
#define __asm_import__equinoxe_animate__
#import "equinoxe-animate.asm"

 // Asm import library equinoxe-palette:
#define __asm_import__equinoxe_palette__
#import "equinoxe-palette.asm"

 // Asm import library equinoxe-flightengine:
#define __asm_import__equinoxe_flightengine__
#import "equinoxe-flightengine.asm"

 // Asm import library equinoxe-waves:
#define __asm_import__equinoxe_waves__
#import "equinoxe-waves.asm"

 // Asm import library equinoxe-stage-flight:
#define __asm_import__equinoxe_stage_flight__
#import "equinoxe-stage-flight.asm"

 // Asm import library equinoxe-enemy:
#define __asm_import__equinoxe_enemy__
#import "equinoxe-enemy.asm"

 // Asm import library lib_conio:
#define __asm_import__lib_conio__
#import "lib_conio.asm"

 // Asm import library lib_lru_cache:
#define __asm_import__lib_lru_cache__
#import "lib_lru_cache.asm"

 // Asm import library lib_veraheap:
#define __asm_import__lib_veraheap__
#import "lib_veraheap.asm"

 // Asm import library lib_bramheap:
#define __asm_import__lib_bramheap__
#import "lib_bramheap.asm"

 // Asm import library lib_file:
#define __asm_import__lib_file__
#import "lib_file.asm"

