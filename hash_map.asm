struc Map_Entry 
    .hash resq 1
    .key resq 1
    .value resq 1
    .next_entry_ptr resq 1
endstruc

section .text
    extern calloc, malloc, free


;;;;;; PUBLIC METHODS ;;;;;;
hash_map_new:
    .set_up:
        ; Set up stack frame without local variables.
        push rbp
        mov rbp, rsp

        ; Reserve 32 bytes shadow space for called functions.
        sub rsp, 32
    
    .reserve_memory_space:
        mov rcx, 8
        mov rdx, rcx
        call calloc

    .complete:
        ; Return pointer to hash map in RAX.

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

        xor rdx, rdx
        div 8

        cmp qword [r8 + rdx * 8], 0
        jne .append_entry

        mov [r8 + rdx * 8], rcx
        jmp .complete

    .append_entry:
        mov r9, [r8 + rdx * 8]
        mov [rcx + Map_entry.next_entry_ptr], r9
        mov [r8 + rdx * 8], rcx

    .complete:
        ; Return pointer to hash map in RAX.

        ; Restore old stack frame and return to caller.
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

        ; Restore old stack frame and return to caller.
        mov rsp, rbp
        pop rbp
        ret