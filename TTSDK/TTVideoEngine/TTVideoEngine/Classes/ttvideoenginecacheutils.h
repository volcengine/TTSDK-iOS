//
//  av_cache_utils.hpp
//  TTAVPlayer
//
//  Created by 黄清 on 2018/12/5.
//

#pragma once
#include <stdio.h>

/// Check the integrity of the cache file.
/// result > 0, it is true.
int check_cache_file_integrity(const char* file, int64_t fileSize, const char* md5);

