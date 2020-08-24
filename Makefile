PWD             := $(shell pwd)
MX_VER_TXT      := $(PWD)/version.txt
MX_VER_MK       := $(PWD)/driver/ver.mk
MX_VER_H        := $(PWD)/driver/mx_ver.h
MX_BUILD_VER    := $(shell awk '{if($$1=="Version" && $$2=="Number:"){print $$3}}' $(MX_VER_TXT))
MX_BUILD_DATE   := $(shell awk '{if($$1=="Date:"){print $$2}}' $(MX_VER_TXT))
MX_CURR_DATE    := $(shell date +%g%m%d%H)

all: driver_make

driver_make:
	@cd driver;\
	make -s

install:
	@cd driver;\
	make install -s

clean:
	@rm -rf build.log
	@cd driver;\
	make clean -s

remove:
	@cd driver;\
	make remove -s
disk:
	@sudo $(MAKE) remove
	@sudo $(MAKE) clean
	@rm -f $(MX_VER_MK)
	@echo -n "DRV_VER=" > $(MX_VER_MK)
	@echo "$(MX_BUILD_VER)" >> $(MX_VER_MK)
	@echo -n "REL_DATE=" >> $(MX_VER_MK)
	@echo "$(MX_BUILD_DATE)" >> $(MX_VER_MK)
	@echo "New $(MX_VER_MK) is created."
	@rm -f $(MX_VER_H)
	@echo "#ifndef _MX_VER_H_" >> $(MX_VER_H)
	@echo "#define _MX_VER_H_" >> $(MX_VER_H)
	@echo -n "#define DRIVER_VERSION \"" >> $(MX_VER_H)
	@echo -n "$(MX_BUILD_VER)" >> $(MX_VER_H)
	@echo "\"" >> $(MX_VER_H)
	@echo "#endif" >> $(MX_VER_H)
	@echo "New $(MX_VER_H) is created."
	rm -rf ../disk/mxu11x0
	rm -rfi ../disk/*
	mkdir ../disk/mxu11x0
	cp -R * ../disk/mxu11x0
	cp -f version.txt ../disk
	cp -f readme.txt ../disk
	tar -C ../disk -cvzf ../disk/driv_linux_uport1p_v$(MX_BUILD_VER)_build_$(MX_CURR_DATE).tgz mxu11x0
	rm -rf ../disk/mxu11x0
	@echo "Done"

