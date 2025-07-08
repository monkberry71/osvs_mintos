.PHONY: clean test
all : boot_loader disk.img

boot_loader:
	@echo "==== Building $@ ===="
	make -C ./boot
	@echo "==== $@ Complete ===="

disk.img: boot/boot_loader.bin
	@echo "==== Building disk.img ===="
	cp boot/boot_loader.bin disk.img
	@echo "==== Complete ===="

test: all
	qemu-system-x86_64 -m 64 -fda disk.img -boot a -M pc

clean:
	make -C boot clean
	rm -f disk.img
