; Sulit, Anne Gabrielle S17
; Torio, Ysobella S17

%include "io64.inc"
section .text
global main
main:
    mov rbp, rsp; for correct debugging
    PRINT_STRING "Input Number: "
    GET_UDEC 8, rax
    mov rdi, rax; 
    mov r11, 0 ; total
        
    cmp rax, 0             ; Check if the input is positive
    jl error               ; Show error message and prompt to restart.
    mov rcx, 0             ; Initialize counter for count_digits.
    jmp count_digits       ; Calculate the number of digits in the input number.
 
error:
    PRINT_STRING "Error: negative number input"
    NEWLINE
    jmp repeat
    
count_digits: 
    cmp rax, 0            ; Check if the number is zero
    je innit_div          ; If zero, jump to the end of the counting
    inc rcx               ; Increment digit count
    mov rdx, 0            ; Clear upper 32 bits of the dividend
    mov rbx, 10           ; Divisor
    div rbx               ; Divide rdx:rax by rbx; quotient in rax, remainder in rdx
    mov r8, rcx
    jmp count_digits      ; Repeat the loop

innit_div: ; innitialize values for divisor
    mov rax, 10
    mov r9, rcx ; counter
    dec r9
    dec r9
    jmp divisor
    
divisor: ; multiply 10 to the number of digits
    cmp r9, 0
    je first_digit
    imul rax, 10 ; Multiply RAX by 10
    dec r9
    mov rbx, rax ; divisor
    jmp divisor
    
first_digit: ; get first digit from input
    mov rdx, 0  ; remainder
    mov rax, rdi ; input
    div rbx ; divide rax by divisor, quotient in rax, remainder rdx
    mov r9, rdx
    mov r10, 1
    PRINT_STRING "m-th power of each digit: "
    jmp power_of_n
    jmp div_10
    
power_of_n:
    cmp r8, 0
    je display_power
    imul r10, rax
    dec r8
    
    cmp r9, 0
    jz check_r8
    jmp power_of_n
    
display_power:
    PRINT_DEC 8, R10
    
    ADD r11, r10
    cmp r9, 0
    jz check_armstrong
    PRINT_STRING ', '
    jmp div_10
    
check_r8:
    cmp r8, 0
    jz display_power
    jmp power_of_n
    
div_10: ; divide the divisor by 10 to get the next digit
    mov rax, rbx
    mov rbx, 10 ; Divisor
    mov rdx, 0
    div rbx
    mov rbx, rax
    mov rax, r9
    jmp remainder

remainder: ; get 1st digit from divisor
    
    mov rdx, 0
    div rbx
    mov r9, rdx
    ;PRINT_DEC 8, RAX
    mov r8, rcx
    mov r10, 1
    cmp rdx, 0
    je power_of_n
    ;mov rax, rdx
    mov r8, rcx
    mov r10, 1
    jmp power_of_n
    
check_armstrong:
    NEWLINE
    PRINT_STRING "Sum of the m-th power digits: "
    PRINT_DEC 8, r11     ; Display the total sum of all the m-th power digits
    NEWLINE
    PRINT_STRING "Armstrong Number: "
    
    ; Compare the sum to the original number
    cmp r11, rdi          ; Compare the sum to the original number
    je armstrong          ; If equal, it's an Armstrong number
    jmp not_armstrong     ; If not equal, it's not an Armstrong number
    
armstrong:
    PRINT_STRING "Yes"
    NEWLINE
    jmp repeat

not_armstrong:
    PRINT_STRING "No"
    NEWLINE
    jmp repeat
    
repeat:
    GET_CHAR AL           ; remove newline character
    PRINT_STRING "Do you want to continue (Y/N)? "
    GET_CHAR AL           ; Get the character input from the user
    cmp AL, 'Y'
    GET_CHAR AL           ; remove newline character
    je main               ; If 'Y', jump back to main to get a new input
    cmp AL, 'N'
    je exit               ; If 'N', end the program
    jmp repeat            ; If neither 'Y' nor 'N', loop back to repeat
    
exit:
    xor rax, rax
    ret
    
    
    
    
    
    
    
    
    
    
    
    
    
    