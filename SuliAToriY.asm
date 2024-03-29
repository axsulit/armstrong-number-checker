; Sulit, Anne Gabrielle S17   Torio, Ysobella S17

%include "io64.inc"

section .data
input dq 0
input_rem dq 0xA
repeat_flag db 0xA
digit_count dq 0
sum dq 0

section .text
global main

main:
    mov rbp, rsp; for correct debugging  
    ; Get user input
    PRINT_STRING "Input Number: "       
    GET_UDEC 8, [input]    
    GET_CHAR [input_rem]
    ; Check if input has non-integer value
    cmp qword [input_rem], 0xA          
    jne clear_string
    ; Check if input < 0
    cmp qword [input], 0                              
    jl error_int
    ; Check if input = 0       
    cmp qword [input], 0                               
    jE error_string                                         
    ; Initialize needed registers
    mov rax, [input]                    
    mov rdi, rax               
    mov rcx, 0       
    ; Start
    jmp count_digits               

clear_string:
    ; Capture all non-integer values until '\n'
    GET_CHAR [input_rem]
    mov rax, [input_rem]
    cmp AL, 0xA
    jne clear_string
    jmp error_string
    
error_string:
    ; display error msg for string/0 input
    PRINT_STRING "Error: Invalid input"
    call reset
    jmp repeat
    
error_int:
    ; display error msg for negative input
    PRINT_STRING "Error: negative number input"
    call reset
    jmp repeat
    
reset:
    ; reset all necessary variables
    NEWLINE
    mov qword [input], 0
    mov qword [sum], 0
    mov qword [digit_count], 0
    mov qword [input_rem], 0xA
    ret

repeat:
    ; Get user input
    PRINT_STRING "Do you want to continue (Y/N)? "
    GET_CHAR [repeat_flag]   
    ; Check if valid input
    cmp byte [repeat_flag], 0xA 
    je error_string    
    GET_CHAR [input_rem]
    ; Check if there are extra characters
    cmp qword [input_rem], 0xA
    jne clear_string
    ;reset vars
    call reset
    ; loop if user inputs Y
    cmp byte [repeat_flag], 'Y'
    je main   
    ; exit if user inputs N            
    cmp byte [repeat_flag], 'N'
    je exit       
    ; show error msg
    jmp error_string                 
    
count_digits: 
    ; Check if input is already zero
    cmp rax, 0                      
    je digit_power                 
    ; Increment digit count
    inc rcx                    
    ; Divide rax by rbx
    mov rdx, 0                      
    mov rbx, 10                     
    div rbx             
    ; loop
    jmp count_digits                

digit_power:
    PRINT_STRING "m-th power of each digit: "    
    ; set digit counter
    mov r8, rcx
    mov r9, rcx 
    dec r9
    ; initialize divisor
    jmp init_divisor
    
init_divisor:    
    ; Setup required registers for the divisor                   
    mov rax, 1     
    mov rbx, 1                
    mov [digit_count], r9
    jmp divisor

divisor: 
    ; Check if pointer is already at first digit
    cmp r9, 0
    je first_digit
    dec r9
    ; multiply divisor by 10
    mov rdx, 10
    mul rdx 
    ; move divisor in rbx
    mov rbx, rax 
    jmp divisor ; start divisor again

first_digit: 
    ; rbx/rax; rax=quotient, rdx=remainder
    mov rdx, 0  
    mov rax, rdi 
    div rbx 
    ; update remaining number
    mov rdi, rdx 
    ;computer nth power of digit
    mov r11, rax
    mov r10, 1 
    mov rax, r10 ; contain nth power
    jmp power_of_n
    
power_of_n:
    ; display nth power
    cmp r8, 0
    je display_power
    dec r8
    ; multiply current power by current digit
    mul r11
    jmp power_of_n ; loop
    
display_power:
    ; display power
    PRINT_UDEC 8, rax
    ; update sum
    ADD [sum], rax
    ; check if power of all digits done
    cmp rdi, 0
    jz check_armstrong
    PRINT_STRING ', '
    ; update registers and variables
    mov r8, rcx 
    dec qword [digit_count]
    mov r9, [digit_count]
    ; loop back to initialize divisor
    jmp init_divisor
    
check_armstrong:
    ; Display the total sum
    NEWLINE
    PRINT_STRING "Sum of the m-th power digits: "
    PRINT_UDEC 8, [sum]     
    mov r11, [sum]
    NEWLINE
    ; Check if sum == input
    cmp r11, [input]          
    je armstrong          
    jmp not_armstrong     
    
armstrong:
    ; input is armstrong number
    PRINT_STRING "Armstrong Number: Yes"
    NEWLINE
    jmp repeat

not_armstrong:
    ; input is not armstrong number
    PRINT_STRING "Armstrong Number: No"
    NEWLINE
    jmp repeat
    
exit:
    ; exit program
    PRINT_STRING "Press Enter to exit..."
    GET_CHAR ax
    cmp ax, 0xA
    xor rax, rax
    ret