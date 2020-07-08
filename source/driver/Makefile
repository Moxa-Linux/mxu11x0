#-------------------------------------------------------------------------------
#   Makefile for MOXA UPort series drvier
#-------------------------------------------------------------------------------
KVER	 := $(shell uname -r)
KDISVER  := $(shell uname -a)
KDIR	 := /lib/modules/$(KVER)/build
PWD	 := $(shell pwd)
TARGET	 := mxu11x0
TI_3410  := ti_usb_3410_5052
IS_CENTOS := $(shell find /etc -iname centos-release 2>/dev/null)
IS_REDHATOS := $(shell find /etc -iname redhat-release 2>/dev/null)

ifeq ($(KERNELRELEASE),)
	include $(PWD)/ver.mk
else
endif

export DRV_VER
export REL_DATE

ifeq "$(findstring centos, $(IS_CENTOS))" "centos"
KCFLAGS += -DIS_CENTOS
export KCFLAGS
endif

ifeq "$(findstring redhat, $(IS_REDHATOS))" "redhat"
KCFLAGS += -DIS_CENTOS
export KCFLAGS
endif

# Use blacklist for built-in tusb3410 module
BLACKLIST_STR := "tusb3410 is disabled by moxa"
BLACKLIST_FILE := /etc/modprobe.d/blacklist.conf
BLACKLIST_CNT := $(shell \
                    grep -s -c $(BLACKLIST_STR) $(BLACKLIST_FILE);\
                    if [ $$? -eq 2 ] ; then echo 0 ; fi \
                  )
BLACKLIST_LINE := $(shell grep -s -n -m1 $(BLACKLIST_STR) $(BLACKLIST_FILE) | cut -d: -f 1)

all:	module

install: module
	@if lsmod | grep -q $(TI_3410) ; then rmmod $(TI_3410) ; fi
	@mkdir -p /lib/modules/$(KVER)/kernel/drivers/usb/serial
	@cp -f ./$(TARGET).ko /lib/modules/$(KVER)/kernel/drivers/usb/serial
	@mkdir -p /lib/modules/$(KVER)/misc/
	@cp -f ./$(TARGET).ko /lib/modules/$(KVER)/misc/
	@depmod -a

ifeq "$(findstring fc6, $(KDISVER))" "fc6"
CFLAGS += -D__FC6__
endif

ifneq ($(KERNELRELEASE),)
obj-m := $(TARGET).o
else
module: envchk
	@echo "  *******************************************************************"
	@echo "    MOXA UPort 11x0 series USB to Serial Hub Driver v$(DRV_VER)      "
	@echo "                                                                     "
	@echo "                   release date : $(REL_DATE)                        "
	@echo "  *******************************************************************"	
	@$(MAKE) -s -C $(KDIR) M=$(PWD) modules 2>> build.log \
	&& cp -f ./build.log ../build.log \
	&& exit 0 \
	|| echo "Build unsuccessfully! Please check build.log for further information" \
	&& cp -f ./build.log ../build.log \
	&& exit 1
endif

envchk:
	@./mxconf || exit 1

remove: clean rm_blacklist
	@if lsmod | grep -q $(TARGET) ; then rmmod $(TARGET) ; fi
	@rm -f /lib/modules/$(KVER)/kernel/drivers/usb/serial/$(TARGET).ko
	@rm -f /lib/modules/$(KVER)/misc/$(TARGET).ko
	@depmod -a
	@echo ""
	@echo "**********************************************************************"
	@echo " MOXA UPort 11x0 series driver ver $(DRV_VER) removed successfully."
	@echo "**********************************************************************"

clean: clean_local
	@rm -f build.log

clean_local:
	@echo "Removing driver files..."
	@rm -f *.o
	@rm -f .*.o.cmd
	@rm -f *.symvers
	@rm -f *.order
	@rm -f *.markers
	@rm -rf ./.tmp_versions
	@rm -f $(TARGET).mod*
	@rm -f .$(TARGET)*
	@rm -f $(TARGET).ko
	@rm -f .cache.mk
	@rm -f *.o.ur-safe

rm_blacklist:
	@if [ "$(BLACKLIST_CNT)" -gt 0 ]; then sed -i '$(BLACKLIST_LINE),~2d' $(BLACKLIST_FILE); fi

