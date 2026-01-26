%include ".\strucs.inc"

global HASH_MAP_ADD_ENTRY_OFFSET, HASH_MAP_SHOW_BUCKETS_OFFSET, hash_map_static_vtable, HASH_MAP_CONSTRUCTOR_OFFSET, Hash_Map

HASH_MAP_ADD_ENTRY_OFFSET equ 0
HASH_MAP_SHOW_BUCKETS_OFFSET equ 8
HASH_MAP_CONSTRUCTOR_OFFSET equ 0

section .rodata
    pointer_format db "%p", 13, 10, 0
    hash_format db "%llu", 13, 10, 0

section .text
    extern calloc, malloc, free
    extern printf

hash_map_static_vtable:
    dq hash_map_new

hash_map_public_methods_vtable:
    dq hash_map_add_entry
    dq hash_map_show_buckets

;;;;;; PUBLIC METHODS ;;;;;;
hash_map_new:
    .set_up:
        ; Set up stack frame.
        ; * 16 bytes local variables.
        push rbp
        mov rbp, rsp
        sub rsp, 16

        ; Save non-volatile regs:
        mov [rbp - 8], rbx

        ; Reserve 32 bytes shadow space for called functions.
        sub rsp, 32

    .reserve_memory_space_for_map:
        mov rcx, Hash_Map_size
        call malloc
        ; Save pointer to map in RBX.
        mov rbx, rax

    .set_up_attributes:
        lea rcx, [rel hash_map_public_methods_vtable]
        mov [rbx + Hash_Map.public_methods_vtable_ptr], rcx
        mov qword [rbx + Hash_Map.length], 8
    
    .reserve_memory_space:
        mov rcx, [rbx + Hash_Map.length]
        mov rdx, rcx
        call calloc

    .set_up_bucket_list:
        mov [rbx + Hash_Map.bucket_list_ptr], rax

    .complete:
        ; Return pointer to hash map in RAX.
        mov rax, rbx

        ; Restore old stack frame and return to caller.
        mov rsp, rbp
        pop rbp
        ret

hash_map_destroy:
    ; * Expect pointer to map in RCX.
    .set_up:
        ; Set up stack frame without local variables.
        push rbp
        mov rbp, rsp

        ; Reserve 32 bytes shadow space for called functions.
        sub rsp, 32

    .free_memory_space:
        call free

    .complete:
        ; Return pointer to hash map in RAX.

        ; Restore old stack frame and return to caller.
        mov rsp, rbp
        pop rbp
        ret

hash_map_add_entry:
    ; * Expect pointer to map in RCX.
    ; * Expect pointer to key in RDX.
    ; * Expect pointer to value in R8.
    .set_up:
        ; Set up stack frame.
        ; * 16 bytes for local variables.
        push rbp
        mov rbp, rsp
        sub rsp, 16

        ; Save params into shadow space.
        mov [rbp + 16], rcx
        mov [rbp + 24], rdx
        mov [rbp + 32], r8

        ; Reserve 32 bytes shadow space for called functions.
        sub rsp, 32

    .get_memory_space_for_entry:
        mov rcx, Map_Entry_size
        call malloc
        ; * First local variable: pointer to MapEntry.
        mov [rbp - 8], rax

    .hash_key:
        mov rcx, [rbp + 24]
        call _hash
        ; * Second local variable: hash value.
        mov [rbp - 16], rax

    .set_up_entry:
        mov rcx, [rbp - 8]
        mov r8, [rbp + 24]
        mov r9, [rbp + 32]

        mov [rcx + Map_Entry.hash], rax
        mov [rcx + Map_Entry.key], r8
        mov [rcx + Map_Entry.value], r9
        mov qword [rcx + Map_Entry.next_entry_ptr], 0

    .get_index:
        mov r8, [rbp + 16]
        mov r9, [r8 + Hash_Map.length]

        mov r8, [r8 + Hash_Map.bucket_list_ptr]

        xor rdx, rdx
        div r9

        cmp qword [r8 + rdx * 8], 0
        jne .append_entry

        mov [r8 + rdx * 8], rcx
        jmp .complete

    .append_entry:
        mov r9, [r8 + rdx * 8]
        mov [rcx + Map_Entry.next_entry_ptr], r9
        mov [r8 + rdx * 8], rcx

    .complete:
        ; Restore old stack frame and return to caller.
        mov rsp, rbp
        pop rbp
        ret

hash_map_show_buckets:
; * Expect pointer to Map in RCX.
    push rbp
    mov rbp, rsp
    sub rsp, 32

    sub rsp, 32

    mov [rbp - 8], rbx
    mov [rbp - 16], r12
    mov [rbp - 24], r13

    mov rbx, rcx
    mov r12, [rbx + Hash_Map.length]
    dec r12
    mov r13, [rbx + Hash_Map.bucket_list_ptr]

    .loop:
        lea rcx, [rel pointer_format]
        mov rdx, [r13 + r12 * 8]
        call printf
    .loop_handle:
        test r12, r12
        jz .complete
        dec r12
        jmp .loop

.complete:
    mov r13, [rbp - 24]
    mov r12, [rbp - 16]
    mov rbx, [rbp - 8]

    mov rsp, rbp
    pop rbp
    ret

; Hash key with djb2 (Dan Bernstein) algorithm.
_hash:
    ; * Expect pointer to null terminated key (string) in RCX.
    .set_up:
        ; Set up stack frame.
        ; * 8 bytes local variables.
        ; * 8 bytes to keep stack 16-byte aligned.
        push rbp
        mov rbp, rsp
        sub rsp, 16

        ; Reserve 32 bytes shadow space for called functions.
        sub rsp, 32

        ; Save non-volatile regs.
        mov [rbp - 8], rsi

        ; Save pointer to RSI.
        mov rsi, rcx

        ; Set loop counter 0.
        xor rcx, rcx

    .hash_calculation:
        ; Magic number for djb2 algorithm.
        mov rax, 5381

        .hash_calculation_loop:
            cmp byte [rsi + rcx], 0
            je .complete
            mov rdx, rax
            shl rax, 5
            add rax, rdx
            movzx rdx, byte [rsi + rcx]
            add rax, rdx
        .hash_calculation_loop_handle:
            inc rcx
            jmp .hash_calculation_loop
        
    .complete:
        ; Restore non-volatile regs.
        mov rsi, [rbp - 8]

        ; Returning hash value in RAX.
        mov [rbp - 8], rax

        lea rcx, [rel hash_format]
        mov rdx, rax
        call printf

        mov rax, [rbp - 8]

        ; Restore old stack frame and return to caller.
        mov rsp, rbp
        pop rbp
        ret