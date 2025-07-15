NASM32= nasm
GCC32 = gcc -c -m32 -ffreestanding
LD32 = ld -melf_i386 -T ../elf_i386.x -nostdlib -e main -Ttext 0x10200
OBJCOPY32 = objcopy -j .text -j .data -j .rodata -j .bss -S -O binary

OBJ_DIR = temp
SRC_DIR = src


all: prepare kernel32.bin

prepare:
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/entry_point.bin: $(SRC_DIR)/entry_point.s
	$(NASM32) -o $@ $<

dep:
	@echo "=== Making .dep file ==="
	make -C $(OBJ_DIR) -f ../Makefile internal_dep
	@echo "=== Done ==="

execute_internal_build: dep
	make -C $(OBJ_DIR) -f ../Makefile kernel32.elf

$(OBJ_DIR)/kernel32.elf.bin: execute_internal_build
	$(OBJCOPY32) $(OBJ_DIR)/kernel32.elf $@

kernel32.bin: $(OBJ_DIR)/entry_point.bin $(OBJ_DIR)/kernel32.elf.bin
	cat $^ > $@

clean:
	rm -f *.bin
	rm -f $(OBJ_DIR)/*.*

########################

c_entry_ojb = main.o
c_src = $(wildcard ../$(SRC_DIR)/*.c)
asm_src = $(wildcard ../$(SRC_DIR)*.asm)
c_obj = $(subst main.o, ,$(notdir $(patsubst %.c,%.o,$(c_src))))
asm_obj = $(notdir $(patsubst %.asm,%.o,$(asm_src)))

%.o: ../$(SRC_DIR)/%.c
	$(GCC32) -c $<

%.o: ../$(SRC_DIR)/%.asm
	$(NASM32) -f elf32 -o $@ $<

internal_dep:
	$(GCC32) -MM $(c_src) > dependency.dep

kernel32.elf: $(c_entry_ojb) $(c_obj) $(asm_obj)
	$(LD32) -o $@ $^

-include dependency