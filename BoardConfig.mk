DEVICE_PATH := device/samsung/starlte

# Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_SMP := true
TARGET_CPU_VARIANT := cortex-a53
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv8-a
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := cortex-a53

# Board
BOARD_VENDOR := samsung
TARGET_BOARD_PLATFORM := exynos5
TARGET_SOC := exynos9810
TARGET_BOOTLOADER_BOARD_NAME := universal9810
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# Kernel (prebuilt DS-ACK, permissive)
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/Image
BOARD_KERNEL_IMAGE_NAME := Image
TARGET_KERNEL_ARCH := arm64
BOARD_KERNEL_BASE := 0x10000000
BOARD_KERNEL_PAGESIZE := 2048

# File systems
BOARD_HAS_LARGE_FILESYSTEM := true
RECOVERY_SDCARD_ON_DATA := true
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery/root/system/etc/recovery.fstab

# Graphical
TARGET_RECOVERY_PIXEL_FORMAT := "ABGR_8888"
TW_BRIGHTNESS_PATH := "/sys/class/backlight/panel/brightness"
TW_MAX_BRIGHTNESS := 44800
TW_DEFAULT_BRIGHTNESS := 17900
TW_THEME := portrait_hdpi

# TWRP
TW_EXCLUDE_SUPERSU := true
TW_HAS_DOWNLOAD_MODE := true
TW_NO_REBOOT_BOOTLOADER := true
TW_USE_BUSYBOX := true
TW_EXCLUDE_TWRPAPP := true
TW_DEVICE_VERSION := r5

ALLOW_MISSING_DEPENDENCIES := true

# Partitions (needed for the recoveryimage target)
BOARD_BOOTIMAGE_PARTITION_SIZE := 46137344
BOARD_FLASH_BLOCK_SIZE := 131072

# Separate vendor partition (avoids root/vendor symlink clashing with recovery/root/vendor)
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_VENDOR := vendor

# ---------------------------------------------------------------------------
# OrangeFox (fox_12.1)
# The standard AOSP mkbootimg builds a plain header v0 image; the workflow then
# repacks it into the Samsung 9810 format (DTBH in the dt slot) with ofox_repack.py.
BOARD_KERNEL_CMDLINE := androidboot.hardware=samsungexynos9810
BOARD_MKBOOTIMG_ARGS := --kernel_offset 0x00008000 --ramdisk_offset 0x01000000 --second_offset 0x00f00000 --tags_offset 0x00000100 --header_version 0
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 67108864

# own USB init (MTP over FunctionFS) is in recovery/root/init.recovery.usb.rc
TW_EXCLUDE_DEFAULT_USB_INIT := true

# OrangeFox UPX-packs ramdisk executables; keep init unpacked (as the 9820 OrangeFox trees do)
BOARD_RECOVERY_IMAGE_PREPARE += \
    for f in init keystore2; do \
        vendor/recovery/tools/upx -q -d $(TARGET_RECOVERY_ROOT_OUT)/system/bin/$$f >/dev/null 2>&1 || true; \
    done;

# NOTE: the DS-ACK kernel only unpacks gzip ramdisks -> never enable
# OF_USE_LZMA_COMPRESSION / LZMA_RAMDISK_TARGETS here.
OF_MAINTAINER := pitelasss
OF_SCREEN_H := 2960
OF_STATUS_INDENT_LEFT := 48
OF_STATUS_INDENT_RIGHT := 48
OF_ALLOW_DISABLE_NAVBAR := 0
OF_NO_TREBLE_COMPATIBILITY_CHECK := 1
OF_QUICK_BACKUP_LIST := /boot;/data;

# Samsung 9810: the torch is not a /sys/class/leds device -> hide the flashlight button
OF_FLASHLIGHT_ENABLE := 0

# Battery % in the status bar: read /sys/class/power_supply/battery directly
# (the health HAL path shows an empty/"!" battery on Exynos 9810)
TW_USE_LEGACY_BATTERY_SERVICES := true
TW_CUSTOM_BATTERY_PATH := "/sys/class/power_supply/battery"
