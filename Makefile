.PHONY: clean test
all : boot_loader disk.img

boot_loader:
	@echo "==== Building $@ ===="
	make -C ./boot
	@echo "==== $@ Complete ===="

32kernel:
	@echo "==== Building the kernel ===="
	make -C ./kernel32
	@echo "==== $@ Complete ===="

disk.img: boot_loader 32kernel
	@echo "==== Building disk.img ===="
	cat boot/boot_loader.bin kernel32/kernel32.bin > disk.img
	@echo "==== Complete ===="

test: all
	qemu-system-x86_64 \
	-m 64 \
	-drive format=raw,file=disk.img,if=floppy \
	-boot a \
	-M pc \
	-gdb tcp::1234


gdb: all
	qemu-system-x86_64 -m 64 -fda disk.img -boot a -M pc -gdb tcp::1234 -S

clean:
	make -C boot clean
	make -C kernel32 clean
	rm -f disk.img
