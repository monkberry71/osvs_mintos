all: kernel32.bin

kernel32.bin: entry_point.s
	nasm -o $@ $<

clean:
	rm -f kernel32.bin