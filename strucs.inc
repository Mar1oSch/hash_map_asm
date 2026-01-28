struc Map_Entry 
    .hash resq 1
    .key resq 1
    .value resq 1
    .next_entry_ptr resq 1
endstruc

struc Hash_Map
    .public_methods_vtable_ptr resq 1
    .entries_count resq 1
    .capacity resq 1
    .bucket_list_ptr resq 1
endstruc