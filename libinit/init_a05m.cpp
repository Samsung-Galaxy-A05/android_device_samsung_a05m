/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <libinit_mem_profile.h>
#include <libinit_variant.h>

#include "vendor_init.h"

void vendor_process_bootenv() {
    set_memory_profile();
    load_model_variants();
}

void vendor_load_properties() {
#if __ANDROID_API__ < 36
    vendor_process_bootenv();
#endif
}
