/*
 * Copyright (C) 2021 The LineageOS Project
 *
 * SPDX-License-Identifier: Apache-2.0
 */

#ifndef LIBINIT_MEMPROFILE_H
#define LIBINIT_MEMPROFILE_H

#include <string>

typedef struct memory_profile {
    /* dalvik heap profile */
    std::string heapstartsize;
    std::string heapgrowthlimit;
    std::string heapsize;
    std::string heapminfree;
    std::string heapmaxfree;
    std::string heaptargetutilization;
    
    /* lmkd profile */
    std::string partialstall;
    std::string completestall;
    std::string thrashlim;
    std::string thrashlimdec;
    std::string swapfreelow;
    std::string upressure;
    
    /* art profile */
    std::string art_lowmem;
} memory_profile_t;

void set_memory_profile(void);

#endif // LIBINIT_MEMPROFILE_H
