#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Inherit non_ab product
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)
# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock \
    fastbootd

# Health
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-impl.recovery \
    android.hardware.health@2.1-service

# Media
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/media,$(TARGET_COPY_OUT_VENDOR)/etc)

# Overlays
PRODUCT_ENFORCE_RRO_TARGETS := *

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Product characteristics
PRODUCT_CHARACTERISTICS := phone

# Power
PRODUCT_PACKAGES += \
    android.hardware.power-service.lineage-libperfmgr

PRODUCT_PACKAGES += \
    libmtkperf_client_vendor \
    libperfctl_vendor \
    libpowerhalwrap_vendor

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/powerhint.json:$(TARGET_COPY_OUT_VENDOR)/etc/powerhint.json

# Rootdir
PRODUCT_PACKAGES += \
    init.insmod.sh 

PRODUCT_PACKAGES += \
    fstab.mt6768 \
    fstab.mt6899.vendor_ramdisk \
    init.cgroup.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init.modem.rc \
    init.mt6768.rc \
    init.mt6768.usb.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.sec.rc \
    init.sensor_1_0.rc \
    init_connectivity.rc \
    init.recovery.mt6768.rc \
    init.recovery.samsung.rc 

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 34

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/pixel \
    hardware/google/interfaces \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/mediatek/libmtkperf_client \
    hardware/mediatek 

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb@1.3.vendor 

# Inherit the proprietary files
$(call inherit-product, vendor/samsung/a05m/a05m-vendor.mk)
