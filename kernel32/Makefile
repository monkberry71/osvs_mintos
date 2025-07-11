all: placeholderOS.bin

placeholderOS.bin: placeholderOS.asm
	nasm -o $@ $<

clean:
	rm -f placeholderOS.bin