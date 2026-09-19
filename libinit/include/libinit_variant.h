/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef LIBINIT_VARIANT_H
#define LIBINIT_VARIANT_H

#include <string>

typedef struct variant_info {
    std::string hwc_value;
    std::string sku_value;

    std::string brand;
    std::string device;
    std::string name;
    std::string model;
    std::string build_fingerprint;

} variant_info_t;

void vendor_load_properties();

#endif // LIBINIT_VARIANT_H
