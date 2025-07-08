.PHONY: clean
all : boot_loader disk.img

boot_loader:
	echo "==== Building $@ ===="
	make -C ./boot_loader
	echo "==== $@ Complete ===="

disk.img: boot_loader/boot_loader.bin
	echo "==== Building disk.img ===="
	cp boot_loader/boot_loader.bin disk.img
	echo "==== Complete ===="

clean:
	make -C boot_loader clean
	rm -f disk.img
