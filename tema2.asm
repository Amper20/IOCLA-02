extern puts
extern printf
extern strlen
extern strstr

%include "io.inc"
%define BAD_ARG_EXIT_CODE -1

section .data
filename: db "./input0.dat", 0
;filename: db "/home/master/Desktop/iocla-tema2-resurse/IOCLA-02/input6.dat", 0
force:    db "force",0
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
        mov eax, ecx
        
loop_hex:
        cmp byte[ecx], 97
        jge chr
        jmp num
chr:
        sub byte[ecx], 97
        add byte[ecx], 10
        jmp don
num:
        sub byte[ecx], 48
don:
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
        jmp don1
num1:
        sub byte[ecx], 48
don1:
        add dl, byte[ecx]
        
        inc ecx
        
        ;key
        push eax
        cmp byte[ebx], 97
        jge chr2
        jmp num2
chr2:
        sub byte[ebx], 97
        add byte[ebx], 10
        jmp don2
num2:
        sub byte[ebx], 48        
don2:
        xor eax, eax
        add al, byte[ebx]
        shl eax,4
       
        inc ebx
        cmp byte[ebx], 97
        jge chr3
        jmp num3
chr3:
        sub byte[ebx], 97
        add byte[ebx], 10
        jmp don3
num3:
        sub byte[ebx], 48
don3:
        add al, byte[ebx]

        
        inc ebx
        xor edx, eax
        pop eax
        mov [eax], dl
        inc eax
        cmp byte[ecx],0
        je loop_hex_done
        jmp loop_hex
loop_hex_done:
        mov byte[eax],0
        mov ecx, [ebp + 8] 
        leave
	ret
base32decode:
	; TODO TASK 4
        push ebp
        mov ebp, esp
        lea ebx, [ebp-4000]
        mov ecx, [esp + 8]
        mov edi,0
loop_str:
        push ecx
        xor edx,edx
        mov dl, byte[ecx]
        cmp dl, 61
        je skip_eq
        cmp dl, 57
        jle numar
        sub dl, 41
numar:
        sub dl,24
        mov eax, 5
        shl dl,2
divide:
        push eax
        shl dl,1
        js add_one
        jmp add_zero
add_one:
        mov byte[ebx], 49
        jmp skip_zero
add_zero:
        mov byte[ebx], 48
skip_zero:
        xor eax,eax
        mov al, byte[ebx]
        inc ebx
        pop eax
        sub eax,1
        cmp eax, 0
        jg divide
        
        pop ecx
        jmp to_ecx
skip_eq:
        inc edi
to_ecx:
        inc ecx
        cmp byte[ecx],0
        je done_base
        jmp loop_str
done_base:
dec_ebx:
        dec edi
        dec ebx
        cmp edi,0
        jg dec_ebx
        
        mov byte[ebx],0
        lea ebx, [ebp-4000]
        
        mov ecx, [esp + 8]
        lea ebx, [ebp-4000]
generate_chr:
        mov edi,8
        mov edx,0
add_ch:
        sub byte[ebx],48
        shl dl,1
        add dl, byte[ebx]
        dec edi 
        inc ebx
        cmp edi,0
        jg add_ch 
        mov byte[ecx], dl
        inc ecx
        cmp byte[ebx],0
        je done_decoding
        jmp generate_chr        
done_decoding:
        mov byte[ecx],0
        mov ecx, [esp + 8]
        leave 
	ret

bruteforce_singlebyte_xor:
	; TODO TASK 5
        push ebp
        mov ebp, esp
        
        mov ecx,[esp + 8]
        
        mov ebx, 0
        
try_key:
        ;xor ecx
        mov ecx,[esp + 8]
xor_ecx:
        xor byte[ecx], bl
        inc ecx
        cmp byte[ecx],0
        je done_ecx
        jmp xor_ecx
done_ecx:        
        ;check
        mov ecx, [esp + 8]
        push force
        push ecx
        call strstr
        add esp,8
        cmp eax,0
        jl done_brute
        mov ecx, [esp + 8]
        ;xor ecx
        mov ecx,[esp + 8]
xor_ecx1:
        xor byte[ecx], bl
        inc ecx
        cmp byte[ecx],0
        je done_ecx1
        jmp xor_ecx1
done_ecx1:        
        inc ebx
        jmp try_key
        
done_brute:
        mov eax,ebx 
        leave
        ret

decode_vigenere:
	; TODO TASK 6
        push ebp
        mov ebp,esp
        
        mov ecx, [esp+8]
        mov eax, [esp+12]
        
iterate_encoded:
        cmp byte[ecx],97
        jl skip_chr
        jmp skip_skip
skip_chr:
        inc ecx
        jmp iterate_encoded
skip_skip:
        
        sub byte[eax],97
        xor edx,edx
        mov dl,byte[eax]
        sub byte[ecx], dl
        add byte[eax],97
        cmp byte[ecx],97
        jge skip
        add byte[ecx],26        
skip:
        mov dl,byte[ecx]        
        inc eax
        cmp byte[eax],0
        je rst_eax
        jmp continue
rst_eax:
        mov eax, [esp+12]
continue:        
        inc ecx
        cmp byte[ecx],0
        je done_vig
        jmp iterate_encoded
done_vig:
        
        leave
	ret

main:
    mov ebp, esp; for correct debugging
	push ebp
	mov ebp, esp
	sub esp, 2300

	; test argc
	mov eax, [ebp + 8]
	cmp eax, 2
	jne exit_bad_arg

	; get task no
        mov ebx, [ebp + 12]
        mov eax, [ebx + 4]
	xor ebx, ebx
	mov bl, [eax]
	sub ebx, '0'
	push ebx

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
        call base32decode
        add esp, 4

	push ecx
	call puts                    ;print resulting string
	pop ecx
	
	jmp task_done

task5:
	; TASK 5: Find the single-byte key used in a XOR encoding

	; TODO TASK 5: call the bruteforce_singlebyte_xor function
        
        push ecx
        call bruteforce_singlebyte_xor
        pop ecx
        push eax
        push ecx
	call puts                    ;print resulting string
	pop ecx
        pop eax
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
