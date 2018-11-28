extern puts
extern printf
extern strlen
%include "io.inc"
%define BAD_ARG_EXIT_CODE -1

section .data
;filename: db "./input0.dat", 0
filename: db "/home/master/Desktop/iocla-tema2-resurse/IOCLA-02/input3.dat", 0

inputlen: dd 2263

fmtstr:            db "Key: %d",0xa, 0
usage:             db "Usage: %s <task-no> (task-no can be 1,2,3,4,5,6)", 10, 0
error_no_file:     db "Error: No input file %s", 10, 0
error_cannot_read: db "Error: Cannot read input file %s", 10, 0

section .text
global main

xor_strings:
	; TODO TASK 1
        push ebp
        mov ebp, esp
 
        mov ecx, [ebp + 8]
        mov ebx, [ebp + 12]
        
        mov eax, ecx
        
loop_enc:
        xor edx,edx
        mov dl, byte[ecx]
        xor dl, byte[ebx]
        mov byte[ecx], dl
        inc ecx
        inc ebx
        cmp byte[ecx],0
        je lv
        jmp loop_enc
lv:
        leave
        ret

rolling_xor:
	; TODO TASK 2
        push ebp
        mov ebp, esp
 
        mov ecx, [ebp + 8]
        mov eax, ecx
        mov dl, byte[ecx]
        inc ecx
loop_enc1:
        xor dl, byte[ecx]
        mov bl, byte[ecx] 
        mov byte[ecx],dl
        mov dl, bl       
        inc ecx
        cmp byte[ecx],0
        je lv1
        jmp loop_enc1
lv1:

        leave
        ret
xor_hex_strings:
	; TODO TASK 3
        push ebp
        mov ebp, esp
 
        mov ecx, [ebp + 8]
        mov ebx, [ebp + 12]
        
loop_hex:
        cmp byte[ecx], 97
        jge chr
        jmp num
chr:
        sub byte[ecx], 97
        add byte[ecx], 10
num:
        sub byte[ecx], 48
        xor edx, edx
        add dl, byte[ecx]
        shl edx,4
       
        inc ecx
        cmp byte[ecx], 97
        jge chr1
        jmp num1
chr1:
        sub byte[ecx], 97
        add byte[ecx], 10
num1:
        sub byte[ecx], 48
        xor edx, edx
        add dl, byte[ecx]
        ;PRINT_UDEC 4, edx
        
        cmp byte[ecx],0
        je loop_hex_done
        jmp loop_hex
        
loop_hex_done:
        leave
	ret

base32decode:
	; TODO TASK 4
	ret

bruteforce_singlebyte_xor:
	; TODO TASK 5
	ret

decode_vigenere:
	; TODO TASK 6
	ret

main:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	;mov eax, [ebp + 8]
	;cmp eax, 2
	;jne exit_bad_arg

	; get task no
	;mov ebx, [ebp + 12]
	;mov eax, [ebx + 4]
	;xor ebx, ebx
	;mov bl, [eax]
	;sub ebx, '0'
	;push ebx
        
        mov ebx,3
	; verify if task no is in range
	cmp ebx, 1
	jb exit_bad_arg
	cmp ebx, 6
	ja exit_bad_arg

	; create the filename
	lea ecx, [filename + 7]
	add bl, '0'
	mov byte [ecx], bl

	; fd = open("./input{i}.dat", O_RDONLY):
	mov eax, 5
	mov ebx, filename
	xor ecx, ecx
	xor edx, edx
	int 0x80
	cmp eax, 0
	jl exit_no_input

	; read(fd, ebp - 2300, inputlen):
	mov ebx, eax
	mov eax, 3
	lea ecx, [ebp-2300]
	mov edx, [inputlen]
	int 0x80
	cmp eax, 0
	jl exit_cannot_read

	; close(fd):
	mov eax, 6
	int 0x80

	; all input{i}.dat contents are now in ecx (address on stack)
	pop eax
	cmp eax, 1
	je task1
	cmp eax, 2
	je task2
	cmp eax, 3
	je task3
	cmp eax, 4
	je task4
	cmp eax, 5
	je task5
	cmp eax, 6
	je task6
	jmp task_done

task1:
	; TASK 1: Simple XOR between two byte streams

	; TODO TASK 1: find the address for the string and the key
    	mov ebx, ecx
        
find_key1:
        inc ebx
        cmp byte[ebx], 0
        je done1
        jmp find_key1
done1:
        inc ebx
        ; TODO TASK 1: call the xor_strings function
        push ebx
        push ecx
        call xor_strings
        add esp, 8
        
        push eax
        call puts                   ;print resulting string
        add esp, 4

        jmp task_done

task2:
	; TASK 2: Rolling XOR
        push ecx
        call rolling_xor
        add esp, 4
        
	push eax
	call puts
	add esp, 4

	jmp task_done

task3:
	; TASK 3: XORing strings represented as hex strings

	; TODO TASK 1: find the addresses of both strings
	; TODO TASK 1: call the xor_hex_strings function

        mov ebx, ecx
find_key3:
        inc ebx
        cmp byte[ebx], 0
        je done3
        jmp find_key3
done3:
        inc ebx
        ; TODO TASK 1: call the xor_strings function
        push ebx
        push ecx
        call xor_hex_strings
        add esp, 8

	push ecx                     ;print resulting string
	call puts
	add esp, 4

	jmp task_done

task4:
	; TASK 4: decoding a base32-encoded string

	; TODO TASK 4: call the base32decode function
	
	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function

	push ecx                    ;print resulting string
	call puts
	pop ecx

	push eax                    ;eax = key value
	push fmtstr
	call printf                 ;print key value
	add esp, 8

	jmp task_done

task6:
	; TASK 6: decode Vignere cipher

	; TODO TASK 6: find the addresses for the input string and key
	; TODO TASK 6: call the decode_vigenere function

	push ecx
	call strlen
	pop ecx

	add eax, ecx
	inc eax

	push eax
	push ecx                   ;ecx = address of input string 
	call decode_vigenere
	pop ecx
	add esp, 4

	push ecx
	call puts
	add esp, 4

task_done:
	xor eax, eax
	jmp exit

exit_bad_arg:
	mov ebx, [ebp + 12]
	mov ecx , [ebx]
	push ecx
	push usage
	call printf
	add esp, 8
	jmp exit

exit_no_input:
	push filename
	push error_no_file
	call printf
	add esp, 8
	jmp exit

exit_cannot_read:
	push filename
	push error_cannot_read
	call printf
	add esp, 8
	jmp exit

exit:
	mov esp, ebp
	pop ebp
	ret
