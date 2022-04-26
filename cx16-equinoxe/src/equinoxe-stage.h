
void StageInit();
void StageReset();

vera_sprite_offset NextOffset(vera_sprite_id sprite_start, vera_sprite_id sprite_end, vera_sprite_id* sprite_id, unsigned char* count);
void FreeOffset(vera_sprite_offset sprite_offset, unsigned char* count);

void LogicStage();

