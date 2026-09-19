/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <sys/sysinfo.h>
#include <libinit_utils.h>

#include <libinit_mem_profile.h>

#define HEAPSTARTSIZE_PROP "dalvik.vm.heapstartsize"
#define HEAPGROWTHLIMIT_PROP "dalvik.vm.heapgrowthlimit"
#define HEAPSIZE_PROP "dalvik.vm.heapsize"
#define HEAPMINFREE_PROP "dalvik.vm.heapminfree"
#define HEAPMAXFREE_PROP "dalvik.vm.heapmaxfree"
#define HEAPTARGETUTILIZATION_PROP "dalvik.vm.heaptargetutilization"

#define PARTIALSTALL_PROP "ro.lmk.psi_partial_stall_ms"
#define COMPLETESTALL_PROP "ro.lmk.psi_complete_stall_ms"
#define THRASHLIM_PROP "ro.lmk.thrashing_limit"
#define THRASHLIMDEC_PROP "ro.lmk.thrashing_limit_decay"
#define SWAPFREELOW_PROP "ro.lmk.swap_free_low_percentage"
#define UPRESSURE_PROP "ro.lmk.upgrade_pressure"

#define ART_LOWMEM_PROP "ro.config.art_lowmem"

#define GB(b) (b * 1024ull * 1024 * 1024)

static const memory_profile_t memory_6144 = {
    // from - phone-xhdpi-6144-dalvik-heap.mk
    .heapstartsize = "16m",
    .heapgrowthlimit = "256m",
    .heapsize = "512m",
    .heapminfree = "8m",
    .heapmaxfree = "32m",
    .heaptargetutilization = "0.5",

    // lmkd profile    
    .partialstall = "70",
    .completestall = "140",
    .thrashlim = "100",
    .thrashlimdec = "10",
    .swapfreelow = "20",
    .upressure = "50",

    // let ART know are we on low memory?
    .art_lowmem = "false",
};

static const memory_profile_t memory_4096 = {
    // from - phone-xhdpi-4096-dalvik-heap.mk
    .heapstartsize = "8m",
    .heapgrowthlimit = "256m",
    .heapsize = "512m",
    .heapminfree = "8m",
    .heapmaxfree = "16m",
    .heaptargetutilization = "0.6",

    // lmkd profile    
    .partialstall = "80",
    .completestall = "240",
    .thrashlim = "70",
    .thrashlimdec = "20",
    .swapfreelow = "18",
    .upressure = "60",

    // let ART know are we on low memory?
    .art_lowmem = "true",
};

static const memory_profile_t memory_2048 = {
    // from - phone-xhdpi-2048-dalvik-heap.mk
    .heapstartsize = "8m",
    .heapgrowthlimit = "192m",
    .heapsize = "512m",
    .heapminfree = "512k",
    .heapmaxfree = "8m",
    .heaptargetutilization = "0.75",

    // lmkd profile    
    .partialstall = "135",
    .completestall = "540",
    .thrashlim = "50",
    .thrashlimdec = "40",
    .swapfreelow = "15",
    .upressure = "70",

    // let ART know are we on low memory?
    .art_lowmem = "true",
};

void set_memory_profile() {
    struct sysinfo sys;
    const memory_profile_t *mp;
    sysinfo(&sys);

    if (sys.totalram > GB(5))
        mp = &memory_6144;
    else if (sys.totalram > GB(3))
        mp = &memory_4096;
    else
        mp = &memory_2048;

    property_override(HEAPSTARTSIZE_PROP, mp->heapstartsize);
    property_override(HEAPGROWTHLIMIT_PROP, mp->heapgrowthlimit);
    property_override(HEAPSIZE_PROP, mp->heapsize);
    property_override(HEAPTARGETUTILIZATION_PROP, mp->heaptargetutilization);
    property_override(HEAPMINFREE_PROP, mp->heapminfree);
    property_override(HEAPMAXFREE_PROP, mp->heapmaxfree);

    property_override(PARTIALSTALL_PROP, mp->partialstall);
    property_override(COMPLETESTALL_PROP, mp->completestall);
    property_override(THRASHLIM_PROP, mp->thrashlim);
    property_override(THRASHLIMDEC_PROP, mp->thrashlimdec);
    property_override(SWAPFREELOW_PROP, mp->swapfreelow);
    property_override(UPRESSURE_PROP, mp->upressure);
    
    property_override(ART_LOWMEM_PROP, mp->art_lowmem);
}
