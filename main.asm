%include ".\strucs.inc"

global main

section .data
    key1 db "Key1", 0
    key2 db "Key2", 0
    key3 db "Key3", 0
    key4 db "Key1.1", 0
    key5 db "Key2.1", 0
    unused_key db "Unused_Key", 0

    value1 db "Value1", 0
    value1_2 db "Value1.2", 0
    value2 db "Value2", 0
    value3 db "Value3", 0
    value4 db "Value4", 0
    value5 db "Value5", 0

section .text
    extern hash_map_static_vtable, HASH_MAP_CONSTRUCTOR_OFFSET, HASH_MAP_ADD_ENTRY_OFFSET, HASH_MAP_REMOVE_ENTRY_OFFSET,HASH_MAP_SHOW_BUCKETS_OFFSET, HASH_MAP_SHOW_ENTRIES_OFFSET, HASH_MAP_CONTAINS_KEY_OFFSET

main:
    push rbp
    mov rbp, rsp
    sub rsp, 16

    sub rsp, 32

    lea rcx, [rel hash_map_static_vtable]
    call [rcx + HASH_MAP_CONSTRUCTOR_OFFSET]
    mov [rbp - 8], rax

    mov rcx, rax
    lea rdx, [rel key1]
    lea r8, [rel value1]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_ADD_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key2]
    lea r8, [rel value2]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_ADD_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_BUCKETS_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_ENTRIES_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key1]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_CONTAINS_KEY_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key1]
    lea r8, [rel value1_2]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_ADD_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_ENTRIES_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key1]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_CONTAINS_KEY_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key3]
    lea r8, [rel value3]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_ADD_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_BUCKETS_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_ENTRIES_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key3]
    lea r8, [rel value3]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_ADD_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key4]
    lea r8, [rel value4]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_ADD_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key5]
    lea r8, [rel value5]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_ADD_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_BUCKETS_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_ENTRIES_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel key4]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_REMOVE_ENTRY_OFFSET]

    mov rcx, [rbp - 8]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_SHOW_ENTRIES_OFFSET]

    mov rcx, [rbp - 8]
    lea rdx, [rel unused_key]
    mov r9, [rcx + Hash_Map.public_methods_vtable_ptr]
    call [r9 + HASH_MAP_REMOVE_ENTRY_OFFSET]
    
    mov rsp, rbp
    pop rbp
    ret