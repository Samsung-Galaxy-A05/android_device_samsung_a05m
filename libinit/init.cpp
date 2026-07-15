/*
 * Copyright (C) 2021 crDroid Android Project
 * Copyright (C) 2020 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <cstdlib>
#include <fstream>
#include <string>
#include <unistd.h>
#include <sys/sysinfo.h>

#include <android-base/logging.h>
#include <android-base/properties.h>

#define _REALLY_INCLUDE_SYS__SYSTEM_PROPERTIES_H_
#include <sys/_system_properties.h>

#include "property_service.h"
#include "vendor_init.h"

using android::base::GetProperty;

static void property_override(const char* prop, const char* value, bool add = true)
{
    prop_info* pi = (prop_info*)__system_property_find(prop);
    if (pi) {
        __system_property_update(pi, value, strlen(value));
    } else if (add) {
        __system_property_add(prop, strlen(prop), value, strlen(value));
    }
}

void load_mem_properties()
{
    char const *partialstall;
    char const *completestall;
    char const *thrashlim;
    char const *thrashlimdec;
    char const *swapfreelow;
    char const *upressure;

    struct sysinfo sys;

    sysinfo(&sys);

    if (sys.totalram >= 5ull * 1024 * 1024 * 1024) {
        // from lmkd defaults for high perf devices
        // except completestall, default 700
        partialstall = "70";
        completestall = "140";
        thrashlim = "100";
        thrashlimdec = "10";
        swapfreelow = "20";
        upressure = "50";
    } else if (sys.totalram >= 3ull * 1024 * 1024 * 1024) {
        // from - phone-xhdpi-4096-dalvik-heap.mk
        property_override("dalvik.vm.heapstartsize", "8m");
        property_override("dalvik.vm.heapgrowthlimit", "192m");
        property_override("dalvik.vm.heapsize", "512m");
        property_override("dalvik.vm.heaptargetutilization", "0.6");
        property_override("dalvik.vm.heapminfree", "8m");
        property_override("dalvik.vm.heapmaxfree", "16m");

        // from lmkd defaults for high perf devices
        // tuned lower, clamped stall
        partialstall = "80";
        completestall = "240";
        thrashlim = "70";
        thrashlimdec = "20";
        swapfreelow = "18";
        upressure = "60";
        property_override("ro.config.art_lowmem", "true");
    }

    property_override("ro.lmk.psi_partial_stall_ms", partialstall);
    property_override("ro.lmk.psi_complete_stall_ms", completestall);
    property_override("ro.lmk.thrashing_limit", thrashlim);
    property_override("ro.lmk.thrashing_limit_decay", thrashlimdec);
    property_override("ro.lmk.swap_free_low_percentage", swapfreelow);
    property_override("ro.lmk.upgrade_pressure", upressure);
}

void vendor_load_properties() {
    load_mem_properties();
}
