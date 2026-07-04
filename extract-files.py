#!/usr/bin/env -S PYTHONPATH=../../../tools/extract-utils python3
#
# SPDX-FileCopyrightText: The LineageOS Project
# SPDX-License-Identifier: Apache-2.0
#

from extract_utils.file import File
from extract_utils.fixups_blob import (
    BlobFixupCtx,
    blob_fixup,
    blob_fixups_user_type,
)
from extract_utils.fixups_lib import (
    lib_fixup_remove,
    lib_fixups,
    lib_fixups_user_type,
)
from extract_utils.main import (
    ExtractUtils,
    ExtractUtilsModule,
)
from extract_utils.tools import (
    llvm_objdump_path,
)
from extract_utils.utils import (
    run_cmd,
)

namespace_imports = [
    'device/samsung/a05m',
    'hardware/mediatek',
    'hardware/mediatek/libaedv',
    'hardware/mediatek/libmtkperf_client',
    'hardware/samsung',
]

def lib_fixup_vendor_suffix(lib: str, partition: str, *args, **kwargs):
    return f'{lib}_{partition}' if partition == 'vendor' else None


lib_fixups: lib_fixups_user_type = {
    **lib_fixups,
    'libuuid': lib_fixup_vendor_suffix,
    'libuuid.dylib': lib_fixup_vendor_suffix,
}


def blob_fixup_return_1(
    ctx: BlobFixupCtx,
    file: File,
    file_path: str,
    symbol: str,
    *args,
    **kwargs,
):
    for line in run_cmd(
        [
            llvm_objdump_path,
            '--dynamic-syms',
            file_path,
        ]
    ).splitlines():
        if line.endswith(f' {symbol}'):
            offset, _ = line.split(maxsplit=1)

            with open(file_path, 'rb+') as f:
                f.seek(int(offset, 16))
                f.write(b'\x01\x00\xa0\xe3')  # mov r0, #1
                f.write(b'\x1e\xff\x2f\xe1')  # bx lr

            break


blob_fixups: blob_fixups_user_type = {

    'vendor/lib64/libsec-ril.so': blob_fixup()
	.sig_replace('80 0E 40 F9 E1 03 16 AA 82 0C 80 52 E3 03 15 AA',
            '80 0E 40 F9 E1 03 16 AA 82 0C 80 52 08 00 80 D2'),

    (
        'vendor/bin/hw/android.hardware.audio.service-aidl.mediatek',
        'vendor/lib64/hw/android.hardware.soundtrigger3-impl.so',
    ): blob_fixup()
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),
    
        'vendor/lib64/android.hardware.audio.core-impl-mediatek.so': blob_fixup()
        .add_needed('libaudioutils_shim.so')
        .replace_needed('libaudio_aidl_conversion_common_ndk.so', 'libaudio_aidl_conversion_common_ndk_prebuilt.so'),

    (
        'vendor/lib64/vendor.mediatek.hardware.bluetooth.audio-V1-ndk.so',
    ): blob_fixup()
        .replace_needed('android.hardware.audio.common-V3-ndk.so', 'android.hardware.audio.common-V4-ndk.so'),

    (
        'vendor/lib64/hw/audio.primary.mt6768.so',
    ): blob_fixup()
        .replace_needed('android.hardware.audio.effect-V2-ndk.so', 'android.hardware.audio.effect-V3-ndk.so')
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),

    (
        'vendor/lib64/libcamera2ndk_vendor.so',
    ): blob_fixup()
        .replace_needed('android.frameworks.cameraservice.service-V2-ndk.so', 'android.frameworks.cameraservice.service-V3-ndk.so')
        .replace_needed('android.frameworks.cameraservice.device-V2-ndk.so', 'android.frameworks.cameraservice.device-V3-ndk.so'),

    (
        'vendor/bin/mnld',
        'vendor/lib64/libaalservice.so',
        'vendor/lib64/libcam.utils.sensorprovider.so',
    ): blob_fixup()
        .replace_needed('android.hardware.sensors-V2-ndk.so', 'android.hardware.sensors-V3-ndk.so'),
    (
        'vendor/bin/mnld'
    ): blob_fixup()
        .replace_needed('libmnl.so', 'libmnl_mtk.so'),
    (
        'vendor/lib64/libmnl_mtk.so',
    ): blob_fixup()
        .fix_soname(),
    (
        'vendor/lib64/libmtkcam_hal_aidl2legacy_common.so',
        'vendor/lib64/libmtkcam_hal_aidl_common.so',
    ): blob_fixup()
        .replace_needed('android.hardware.camera.common-V2-ndk.so', 'android.hardware.camera.common-V1-ndk.so'),

    (
        'vendor/lib64/libbluetooth_audio_session_aidl_mtk.so',
    ): blob_fixup()
        .replace_needed('android.hardware.bluetooth.audio-V4-ndk.so', 'android.hardware.bluetooth.audio-V5-ndk.so'),
    (
        'vendor/lib64/libcodec2_mtk_venc.so',
        'vendor/lib64/libcodec2_mtk_vdec.so',
    ): blob_fixup()
        .replace_needed('libformatter.so', 'libformatter_mtk.so'),
    (
        'vendor/lib64/libformatter_mtk.so',
    ): blob_fixup()
        .fix_soname(),
    (
        'vendor/bin/hw/android.hardware.graphics.allocator-V2-service-mediatek',
        'vendor/lib64/egl/libGLES_mali.so',
        'vendor/lib64/hw/android.hardware.graphics.allocator-V2-mediatek.so',
        'vendor/lib64/hw/mapper.mediatek.so',
        'vendor/lib64/libcodec2_fsr.so',
        'vendor/lib64/libgpud.so',
        'vendor/lib64/libgui_vendor.so',
        'vendor/lib64/libmtkcam_grallocutils.so',
        'vendor/lib64/vendor.mediatek.hardware.camera.isphal-V1-ndk.so',
        'vendor/lib64/vendor.mediatek.hardware.pq_aidl-V2-ndk.so',
    ): blob_fixup()
        .replace_needed('android.hardware.graphics.common-V5-ndk.so', 'android.hardware.graphics.common-V7-ndk.so')
        .replace_needed('android.hardware.graphics.common-V6-ndk.so', 'android.hardware.graphics.common-V7-ndk.so'),

    (
        'vendor/lib64/hw/hwcomposer.mt6768.so',
        'vendor/lib64/hw/android.hardware.audio.effect.aidl-impl-mediatek.so',
        'vendor/lib64/libpqxmlparser.so',
        'vendor/lib64/libsilkybrightnesscore.so',
        'vendor/lib64/librt_extamp_intf.so',
    ): blob_fixup()
        .replace_needed('libtinyxml2.so', 'libtinyxml2-v34.so'),

    (
        'vendor/lib64/hw/android.hardware.audio.effect.aidl-impl-mediatek.so',
        'vendor/bin/hw/android.hardware.audio.service-aidl.mediatek',
        'vendor/lib64/android.hardware.audio.core-impl-mediatek.so',
    ): blob_fixup()
        .replace_needed('android.media.audio.common.types-V3-ndk.so', 'android.media.audio.common.types-V4-ndk.so'),
		
    (
        'vendor/lib64/android.hardware.audio.core-impl-mediatek.so',
        'vendor/lib64/android.hardware.bluetooth.audio-impl-mediatek.so',
        'vendor/lib64/hw/vendor.mediatek.hardware.bluetooth.audio@2.1-impl.so',
        'vendor/bin/hw/android.hardware.audio.service-aidl.mediatek',
    ): blob_fixup()
        .replace_needed('android.hardware.bluetooth.audio-V4-ndk.so', 'android.hardware.bluetooth.audio-V5-ndk.so'),

    (
        'vendor/bin/hw/android.hardware.audio.service-aidl.mediatek',
        'vendor/lib64/android.hardware.audio.core-impl-mediatek.so',
    ): blob_fixup()
        .replace_needed('android.media.audio.common.types-V3-ndk.so', 'android.media.audio.common.types-V4-ndk.so'),   	

     'vendor/etc/init/android.hardware.security.skeymint-service.rc': blob_fixup()
        .regex_replace('android.hardware.security.keymint-service', 'android.hardware.security.skeymint-service'),   

     'vendor/etc/init/android.hardware.media.c2-mediatek-64b.rc': blob_fixup()
        .regex_replace('android.hardware.media.c2-mediatek-64b', 'android.hardware.media.c2@1.2-mediatek-64b'),   
 
     'vendor/etc/init/android.hardware.wifi-service-lazy-mediatek.rc': blob_fixup()
        .regex_replace('android.hardware.wifi-service-lazy', 'android.hardware.wifi-service-lazy-mediatek'), 
        
}  # fmt: skip

module = ExtractUtilsModule(
    'a05m',
    'samsung',
    blob_fixups=blob_fixups,
    lib_fixups=lib_fixups,
    namespace_imports=namespace_imports,
)


if __name__ == '__main__':
    utils = ExtractUtils.device(module)
    utils.run()
