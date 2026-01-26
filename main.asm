%include ".\strucs.inc"

global main

section .data
    key1 db "Key1", 0
    key2 db "Key2", 0

    value1 db "Value1", 0
    value2 db "Value2", 0

section .text
    extern hash_map_static_vtable, HASH_MAP_CONSTRUCTOR_OFFSET, HASH_MAP_ADD_ENTRY_OFFSET, HASH_MAP_SHOW_BUCKETS_OFFSET

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

    xor rax, rax

    mov rsp, rbp
    pop rbp
    ret