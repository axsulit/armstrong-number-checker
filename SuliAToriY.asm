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
    GET_STRING [input_rem], 8 
    ; Check if valid integer   
    cmp qword [input_rem], 0xA          
    jne error_string
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
    mov qword [input], 0
    mov qword [sum], 0
    mov qword [digit_count], 0
    mov qword [input_rem], 0xA
    ret

repeat:
    ; Get user input
    PRINT_STRING "Do you want to continue (Y/N)? "
    GET_CHAR [repeat_flag]       
    GET_STRING [input_rem], 8 
    ; Check if valid input
    cmp qword [input_rem], 0xA
    jne error_string
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
    imul rax, 10 
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
    mov r10, 1 ; contain nth power
    jmp power_of_n
    
power_of_n:
    ; display nth power
    cmp r8, 0
    je display_power
    dec r8
    ; multiply current power by current digit
    imul r10, rax
    jmp power_of_n ; loop
    
display_power:
    ; display power
    PRINT_DEC 8, R10
    PRINT_STRING ', '
    ; update sum
    ADD [sum], r10
    ; check if power of all digits done
    cmp rdi, 0
    jz check_armstrong
    ; update registers and variables
    mov r8, rcx 
    dec qword [digit_count]
    mov r9, [digit_count]
    
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
    xor rax, rax
    ret