/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#include <string>
#include <vector>

#include <android-base/logging.h>
#include <android-base/properties.h>
#include <libinit_utils.h>

#include <libinit_variant.h>

using android::base::GetProperty;

#define DEFAULT_BOOTLOADER "A055FXXSBDYJ2"
#define BUILD_RELEASE "15"
#define BUILD_ID "AP3A.240905.015.A2"

static const variant_info_t a055f_info = {
    .hwc_value = "",
    .sku_value = "",

    .brand = "samsung",
    .device = "a05m",
    .name = "a05mxx",
    .model = "SM-A055F",
    .build_fingerprint = "",
};

static const variant_info_t a055m_info = {
    .hwc_value = "",
    .sku_value = "",

    .brand = "samsung",
    .device = "a05m",
    .name = "a05mub",
    .model = "SM-A055M",
    .build_fingerprint = "",
};

static const std::vector<std::string> property_partitions = {
    "",
    "odm.",
    "product.",
    "system.",
    "system_ext.",
    "vendor.",
};

void set_variant_props(const variant_info_t& info) {
    for (const auto& part : property_partitions) {
        if (!info.brand.empty())
            property_override("ro.product." + part + "brand", info.brand);

        if (!info.device.empty())
            property_override("ro.product." + part + "device", info.device);

        if (!info.model.empty())
            property_override("ro.product." + part + "model", info.model);

        if (!info.name.empty())
            property_override("ro.product." + part + "name", info.name);

        if (!info.build_fingerprint.empty()) {
            if (part.empty()) {
                property_override("ro.build.fingerprint", info.build_fingerprint);
            } else {
                property_override("ro." + part + "build.fingerprint", info.build_fingerprint);
            }
        }
    }
}

// Helper function to build a standard Android fingerprint
static std::string build_fingerprint(const std::string& brand, const std::string& name,
                                     const std::string& device, const std::string& release,
                                     const std::string& build_id, const std::string& incremental,
                                     const std::string& keys) {
    return brand + "/" + name + "/" + device + ":" + release + "/" + build_id + "/" +
           incremental + ":user/" + keys;
}

void load_model_variants(void) {
    std::string em_model = GetProperty("ro.boot.em.model", "");
    std::string bootloader = GetProperty("ro.boot.bootloader", "");

    bool is_a055m = (em_model == "SM-A055M") ||
                    (em_model.empty() && bootloader.rfind("A055M", 0) == 0);
    variant_info_t selected_info = is_a055m ? a055m_info : a055f_info;

    if (bootloader.empty())
        bootloader = GetProperty("ro.build.version.incremental", "");
    if (bootloader.empty())
        bootloader = DEFAULT_BOOTLOADER;

    selected_info.build_fingerprint = build_fingerprint(
        selected_info.brand,
        selected_info.name,
        selected_info.device,
        BUILD_RELEASE,
        BUILD_ID,
        bootloader,
        "release-keys"
    );

    set_variant_props(selected_info);

    std::string build_desc = selected_info.name + "-user " BUILD_RELEASE " " BUILD_ID " " +
                             bootloader + " release-keys";
    property_override("ro.build.description", build_desc);
}
