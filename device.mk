#
# Copyright (C) 2025 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#
DEVICE_PATH := device/samsung/a05m

# Inherit non_ab product
$(call inherit-product, $(SRC_TARGET_DIR)/product/non_ab_device.mk)
# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)
# Enforce generic ramdisk allow list
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_ramdisk.mk)
# Project ID Quota
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)
# Build with GMS
BUILD_WITH_GAPPS ?= false

# Audio
TARGET_EXCLUDES_AUDIOFX := true

PRODUCT_PACKAGES += \
    audio.primary.default \
    audio.bluetooth.default \
    audio_policy.stub \
    audio.r_submix.default \
    audio.usb.default \
    libaudioutils_shim

PRODUCT_PACKAGES += \
    libaecsw \
    libagc1sw \
    libagc2sw \
    libbassboostsw \
    libbundleaidl \
    libdownmixaidl \
    libdynamicsprocessingaidl \
    libequalizersw \
    libhapticgeneratoraidl \
    libloudnessenhanceraidl \
    libnssw \
    libpreprocessingaidl \
    libpresetreverbsw \
    libreverbaidl \
    libspatializersw \
    libvirtualizersw \
    libvisualizeraidl \
    libvolumesw \
    libextensioneffect

PRODUCT_PACKAGES += \
    MtkInCallService

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/audio/,$(TARGET_COPY_OUT_VENDOR)/etc) \
    frameworks/av/services/audiopolicy/config/a2dp_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/a2dp_in_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_in_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml \
    frameworks/av/services/audiopolicy/config/bluetooth_audio_policy_configuration_7_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/bluetooth_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml

$(call soong_config_set_bool,android_hardware_audio,skip_speaker_layout_channel_mask_field,true)

# Bluetooth
PRODUCT_PACKAGES += \
    android.hardware.bluetooth-service.mediatek

# Cgroup
PRODUCT_COPY_FILES += \
    system/core/libprocessgroup/profiles/cgroups.json:$(TARGET_COPY_OUT_VENDOR)/etc/cgroups.json \
    system/core/libprocessgroup/profiles/task_profiles.json:$(TARGET_COPY_OUT_VENDOR)/etc/task_profiles.json

# Dalvik - phone-xhdpi-6144-dalvik-heap.mk
PRODUCT_VENDOR_PROPERTIES += \
    dalvik.vm.heapstartsize?=16m \
    dalvik.vm.heapgrowthlimit?=256m \
    dalvik.vm.heapsize?=512m \
    dalvik.vm.heaptargetutilization?=0.5 \
    dalvik.vm.heapminfree?=8m \
    dalvik.vm.heapmaxfree?=32m

# DRM (Clearkey)
PRODUCT_PACKAGES += \
    android.hardware.drm-service.clearkey

# DTB
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/prebuilts/dtb.img:$(TARGET_OUT)/dtb.img

# Fastbootd
PRODUCT_PACKAGES += \
    android.hardware.fastboot@1.1-impl-mock

# Gatekeeper
PRODUCT_PACKAGES += \
    android.hardware.security.keymint-V3-ndk.vendor \
    android.hardware.gatekeeper-V1-ndk.vendor \
    libgatekeeper.vendor

# GNSS
PRODUCT_PACKAGES += \
    android.hardware.gnss@1.1.vendor \
    android.hardware.gnss@2.1.vendor \
    android.hardware.gnss.visibility_control@1.0 \
    android.hardware.gnss.measurement_corrections@1.1

# Graphics
PRODUCT_PACKAGES += \
    android.hardware.memtrack-service.mediatek

# Health
PRODUCT_PACKAGES += \
    android.hardware.health-service.samsung \
    android.hardware.health-service.samsung-recovery

# Keymint
PRODUCT_PACKAGES += \
    android.hardware.keymaster@4.1.vendor \
    android.hardware.security.rkp-V1-ndk \
    libkeymaster4_1support.vendor

# Kernel
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false

# Light
PRODUCT_PACKAGES += \
    android.hardware.light-service.lineage

# Linker config
PRODUCT_VENDOR_LINKER_CONFIG_FRAGMENTS += \
    $(DEVICE_PATH)/configs/linker.config.json

# Media
PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/seccomp,$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy) \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/media,$(TARGET_COPY_OUT_VENDOR)/etc)

# OpenCL
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt   

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlay
PRODUCT_PACKAGES += \
    FrameworksResOverlay \
    LineagePlatfromOverlay \
    SystemUIResOverlay \
    TetheringOverlay \
    WifiOverlay

# Partitions
PRODUCT_USE_DYNAMIC_PARTITIONS := true

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.audio.low_latency.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.audio.low_latency.xml \
    frameworks/native/data/etc/android.software.midi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.midi.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.camera.flash-autofocus.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.flash-autofocus.xml \
    frameworks/native/data/etc/android.hardware.camera.front.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.front.xml \
    frameworks/native/data/etc/android.hardware.camera.full.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.full.xml \
    frameworks/native/data/etc/android.hardware.camera.raw.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.camera.raw.xml \
    frameworks/native/data/etc/android.hardware.opengles.aep.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.opengles.aep.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.touchscreen.multitouch.xml \
    frameworks/native/data/etc/android.hardware.vulkan.compute-0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.compute.xml \
    frameworks/native/data/etc/android.hardware.vulkan.level-1.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.level.xml \
    frameworks/native/data/etc/android.hardware.vulkan.version-1_3.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.vulkan.version.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.software.vulkan.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.vulkan.deqp.level.xml \
    frameworks/native/data/etc/android.software.opengles.deqp.level-2023-03-01.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.opengles.deqp.level.xml \
    frameworks/native/data/etc/android.hardware.keystore.app_attest_key.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.keystore.app_attest_key.xml \
    frameworks/native/data/etc/android.software.device_id_attestation.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.device_id_attestation.xml \
    frameworks/native/data/etc/android.software.verified_boot.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.verified_boot.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnels.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnels.xml \
    frameworks/native/data/etc/android.software.ipsec_tunnel_migration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.ipsec_tunnel_migration.xml \
    frameworks/native/data/etc/android.hardware.sensor.accelerometer.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.accelerometer.xml \
    frameworks/native/data/etc/android.hardware.sensor.dynamic.head_tracker.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.dynamic.head_tracker.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.sensor.proximity.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.proximity.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepcounter.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepcounter.xml \
    frameworks/native/data/etc/android.hardware.sensor.stepdetector.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.sensor.stepdetector.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.wifi.aware.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.aware.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.wifi.passpoint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.passpoint.xml \
    frameworks/native/data/etc/android.hardware.wifi.rtt.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.rtt.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml  

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

# Radio
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/sehradiomanager.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sehradiomanager.conf

PRODUCT_PACKAGES += \
    android.hardware.radio@1.2.vendor:64 \
    android.hardware.radio.config-V1-ndk.vendor:64 \
    android.hardware.radio.data-V1-ndk.vendor:64 \
    android.hardware.radio.messaging-V1-ndk.vendor:64 \
    android.hardware.radio.modem-V1-ndk.vendor:64 \
    android.hardware.radio.network-V1-ndk.vendor:64 \
    android.hardware.radio.sim-V1-ndk.vendor:64 \
    android.hardware.radio.voice-V1-ndk.vendor:64 \
    sehradiomanager \
    android.hardware.radio.config@1.2 \
    android.hardware.radio@1.5 \
    vendor.samsung.hardware.radio@2.0 \
    vendor.samsung.hardware.radio@2.1 \
    vendor.samsung.hardware.radio@2.2 \
    android.hardware.radio.deprecated@1.0

# Rootdir
PRODUCT_PACKAGES += \
    init.insmod.sh 

PRODUCT_PACKAGES += \
    fstab.mt6768 \
    fstab.mt6768.vendor_ramdisk \
    init.power.rc \
    init.connectivity.common.rc \
    init.connectivity.rc \
    init.modem.rc \
    init.mt6768.rc \
    init.samsung.usb.rc \
    init.mtkgki.rc \
    init.project.rc \
    init.sec.rc \
    init.sensor_1_0.rc \
    init_connectivity.rc \
    init.recovery.mt6768.rc \
    zram.fstab \
    init.recovery.samsung.rc 

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/rootdir/etc/ueventd.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    $(LOCAL_PATH)/rootdir/etc/init.insmod.mt6768.cfg:$(TARGET_COPY_OUT_VENDOR)/etc/init.insmod.mt6768.cfg

# Sensors
PRODUCT_PACKAGES += \
    android.hardware.sensors-service.samsung-multihal

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/sensors/hals.conf:$(TARGET_COPY_OUT_VENDOR)/etc/sensors/hals.conf   

# Shipping API level
PRODUCT_SHIPPING_API_LEVEL := 34

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(LOCAL_PATH) \
    hardware/google/pixel/pixelstats \
    hardware/google/pixel/power-libperfmgr \
    hardware/google/interfaces \
    hardware/lineage/interfaces/power-libperfmgr \
    hardware/mediatek/libmtkperf_client \
    hardware/mediatek/libaedv \
    hardware/mediatek \
    hardware/samsung 

# Thermal
PRODUCT_PACKAGES += \
    android.hardware.thermal-service.pixel \
    thermal_symlinks

PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/configs/thermal_info_config.json:$(TARGET_COPY_OUT_VENDOR)/etc/thermal_info_config.json

# USB
PRODUCT_PACKAGES += \
    android.hardware.usb-V1-ndk.vendor 

# Vibrator
$(call soong_config_set, vibrator, vibratortargets, vibratoraidlV2target)

PRODUCT_PACKAGES += \
    vendor.qti.hardware.vibrator.service

PRODUCT_COPY_FILES += \
    vendor/qcom/opensource/vibrator/excluded-input-devices.xml:$(TARGET_COPY_OUT_VENDOR)/etc/excluded-input-devices.xml

# Vndservice manager
PRODUCT_PACKAGES += \
   vndservicemanager \
   vndservice

# WiFi
PRODUCT_CFI_INCLUDE_PATHS += hardware/mediatek/wlan/wpa_supplicant_8_lib

PRODUCT_PACKAGES += \
    android.hardware.wifi-service \
    hostapd \
    wpa_supplicant

PRODUCT_COPY_FILES += \
    $(call find-copy-subdir-files,*,$(DEVICE_PATH)/configs/wifi/,$(TARGET_COPY_OUT_VENDOR)/etc/wifi) 

# Inherit the proprietary files
$(call inherit-product, vendor/samsung/a05m/a05m-vendor.mk)
$(call inherit-product, vendor/samsung/kpoc_charger/kpoc_charger.mk)
# Inherit TEE drivers
$(call inherit-product, vendor/samsung/a05m-tee/tee.mk)
# Inherit the sign keys
$(call inherit-product, vendor/lineage-priv/keys/keys.mk)
# WingCam-N28
$(call inherit-product, vendor/samsung/wing-camera/wingcamera-samsung.mk)
# SamsungParts
$(call inherit-product, packages/apps/SamsungParts/samsungparts.mk)

ifeq ($(BUILD_WITH_GAPPS),true)
WITH_GMS := true
TARGET_USES_MINI_GAPPS := true
endif
