; Sulit, Anne Gabrielle S17
; Torio, Ysobella S17

%include "io64.inc"
section .text
global main
main:
    PRINT_STRING "Input Number: "
    GET_UDEC 8, rax
    mov rdi, rax; 
    
    ; TODO: Check if the input is a valid integer
        ; call error func
        
    cmp rax, 0             ; Check if the input is positive
    jl error               ; Show error message and prompt to restart.
    mov rcx, 0             ; Initialize counter for count_digits.
    jmp count_digits       ; Calculate the number of digits in the input number.
 
error:
    PRINT_STRING "Error: negative number input"
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

count_digits: 
    cmp rax, 0            ; Check if the number is zero
    je exit               ; If zero, jump to the end of the counting
    inc rcx               ; Increment digit count
    mov rdx, 0            ; Clear upper 32 bits of the dividend
    mov rbx, 10           ; Divisor
    div rbx               ; Divide rdx:rax by rbx; quotient in rax, remainder in rdx
    jmp count_digits      ; Repeat the loop

process_digit:
    ; write your code here
    
    ; TODO: Loop through each digit of the number.
        ; calculate its nth power, 
        ; add it to the total sum;
        
result:
    ; TODO: Compare the total sum to the input number to determine if it's an Armstrong number;
    
    
    ; TODO: display results
    PRINT_STRING "m-th power of each digits: "
    NEWLINE
    PRINT_STRING "Sum of the m-th power digits: "
    NEWLINE
    PRINT_STRING "Armstrong Number: "
    NEWLINE
    
    jmp exit
    
exit:
    PRINT_HEX 8, rcx
    xor rax, rax         ; Exit the program
    ret