tema2: tema2.asm
	nasm -f elf32 -o tema2.o $<
	gcc -m32 -o $@ tema2.o
	./tema2 1 

clean:
	rm -f tema2 tema2.o
