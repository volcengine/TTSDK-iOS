//
//  TTVideoPreloader.h
//  Pods
//
//  Created by 钟少奋 on 2017/4/11.
//
//

#pragma once
typedef struct {
    char *vid;
    char *url;
    int resolution;
    int preloadSize;
    int32_t supportedResolution;
}AVVideoInfo;

#ifdef __cplusplus
#include <iostream>

void *TTPreloaderGetVideoUrl(const char *metaUrl, int resolution, void *user);
bool TTPreloaderGetFetchVideoUrlLoadingStatus(void *ctx);
AVVideoInfo *TTPreloaderGetVideoUrlInfo(void *ctx);
void TTPreloaderCancleFetchVideoUrl(void *ctx);
void TTPreloaderReleaseVideoUrlCtx(void *ctx);

#endif

