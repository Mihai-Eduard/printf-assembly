.data

output: .byte 0

.text

sample: .asciz "My friends are %s, %s, %s, and my favourite %t numbers are %d, %d, %u, and he is %s!"
input1: .asciz "Piet"
input2: .asciz "Robert"
input3: .asciz "Raul"
input4: .asciz "Ion"
outputDeciaml: .asciz "%d"

.global main

main:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    #call the function
    movq $sample, %rdi
    movq $input1, %rsi
    movq $input2, %rdx
    movq $input3, %rcx
    movq $-10, %r8
    movq $-50, %r9
    pushq $input4
    pushq $input4
    pushq $42
    pushq $42

    call my_printf

end:
    #epilogue
    movq %rbp, %rsp
    popq %rbp

    #exit the program
    movq $0, %rdi
    call exit

my_printf:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    #store the callee-saved registers
    pushq %rbx
    pushq %rbx
    pushq %r12
    pushq %r12
    pushq %r13
    pushq %r13

    movq %rdi, %rbx #pointer to the string address
    movq %rbp, %r12 #first <RBP> address, used to access parameters passed through stack
    movq $0, %r13 #number of parameters used

    #save the parameters of the function
    pushq %r9
    pushq %r9
    pushq %r8
    pushq %r8
    pushq %rcx
    pushq %rcx
    pushq %rdx
    pushq %rdx
    pushq %rsi
    pushq %rsi

    loopMy_Printf:
        #get the character
        movq $0, %rax
        movb (%rbx), %al

        #compare to null character
        cmp $0, %rax
        je endLoopMy_Printf

        #verify if it's a special case
        cmp $37, %rax
        je specialCase
        jne normalCase

        normalCase:
            #print the character
            movq %rax, %rdi
            call printNormalChar

            jmp moveOn

        specialCase:
            #get the next character
            add $1, %rbx  
            movq $0, %rax
            movb (%rbx), %al

            #%%
            cmp $37, %rax
            je printHashTag
            #%d
            cmp $100, %rax
            je printSignedInteger
            #%u
            cmp $117, %rax
            je printUnisngedInteger
            #%s
            cmp $115, %rax
            je printString
            jne printNoneOfTheAbove
            
                printHashTag:
                    #print the %
                    movq $37, %rdi
                    call printNormalChar

                    jmp moveOn
                
                printSignedInteger:
                    #increase the number of parameters used
                    inc %r13
                    cmp $5, %r13
                    jg signedGetAbove6

                    signedGetFirst6:
                        popq %rdi
                        popq %rdi
                        jmp signedCall
                    signedGetAbove6:
                        add $16, %r12
                        movq (%r12), %rdi
                        jmp signedCall
                    signedCall:
                        cmp $0, %rdi
                        jl negative
                        positive:
                            call printUnsignedIntegerMethod

                            jmp moveOn
                        negative:
                            push %rdi
                            push %rdi

                            #print a minus
                            movq $45, %rdi
                            call printNormalChar

                            popq %rdi
                            popq %rdi
                            movq %rdi, %rax
                            movq $-1, %rcx
                            mul %rcx
                            movq %rax, %rdi
                            call printUnsignedIntegerMethod

                            jmp moveOn

                printUnisngedInteger:
                    #increase the number of parameters used
                    inc %r13
                    cmp $5, %r13
                    jg unsignedGetAbove6

                    unsignedGetFirst6:
                        popq %rdi
                        popq %rdi
                        jmp unsignedCall
                    unsignedGetAbove6:
                        add $16, %r12
                        movq (%r12), %rdi
                        jmp unsignedCall
                    unsignedCall:
                        call printUnsignedIntegerMethod

                    jmp moveOn

                printString:
                    #increase the number of parameters used
                    inc %r13
                    cmp $5, %r13
                    jg stringGetAbove6

                    stringGetFirst6:
                        popq %rdi
                        popq %rdi
                        jmp stringCall
                    stringGetAbove6:
                        add $16, %r12
                        movq (%r12), %rdi
                        jmp stringCall
                    stringCall:
                        #store the callee-saved register
                        pushq %r14
                        pushq %r14

                        movq %rdi, %r14
                        
                        loopPrintString:
                            #get the character
                            movq $0, %rax
                            movb (%r14), %al

                            #compare to null character
                            cmp $0, %rax
                            je endLoopPrintString
                            
                            #print the character
                            movq %rax, %rdi
                            call printNormalChar

                            #go to the next character
                            add $1, %r14
                            jmp loopPrintString

                        endLoopPrintString:
                            #pop the callee-saved register
                            popq %r14
                            popq %r14
                            jmp moveOn
                    
                printNoneOfTheAbove:
                    pushq %rax
                    pushq %rax

                    #print the %
                    movq $37, %rdi
                    call printNormalChar

                    popq %rax
                    popq %rax

                    #print the character
                    movq %rax, %rdi
                    call printNormalChar

                    jmp moveOn

        moveOn:
            #go to the next character
            add $1, %rbx
            jmp loopMy_Printf

    endLoopMy_Printf:
        #add and endline
        movq $10, %rax
        movq %rax, %rdi
        call printNormalChar

        inc %r13

        cleanTheParamtersFromStack:
            cmp $5, %r13
            jg endCleaning

            inc %r13
            popq %rdi
            popq %rdi
            jmp cleanTheParamtersFromStack
        endCleaning:
            #resore the value of callee-saved register
            popq %r13
            popq %r13
            popq %r12
            popq %r12
            popq %rbx
            popq %rbx

            #epilogue
            movq %rbp, %rsp
            popq %rbp

            #return to main
            ret

printNormalChar:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    #sysacll for write
    movb %dil, output
    movq $1, %rax
    movq $1, %rdi 
    movq $output, %rsi
    movq $1, %rdx
    syscall

    #epilogue
    movq %rbp, %rsp
    popq %rbp

    #return
    ret

printUnsignedIntegerMethod:
    #prologue
    pushq %rbp
    movq %rsp, %rbp

    cmp $10, %rdi
    jl baseCaseUnsignedInteger

    movq $0, %rdx
    movq %rdi, %rax
    movq $10, %rcx
    div %rcx
    pushq %rdx
    pushq %rdx

    movq %rax, %rdi
    call printUnsignedIntegerMethod

    popq %rdi
    popq %rdi
    add $48, %rdi
    call printNormalChar
    jmp endUnsignedInteger

    baseCaseUnsignedInteger:
        add $48, %rdi
        call printNormalChar

    endUnsignedInteger:
        #epilogue
        movq %rbp, %rsp
        popq %rbp

        #return
        ret
