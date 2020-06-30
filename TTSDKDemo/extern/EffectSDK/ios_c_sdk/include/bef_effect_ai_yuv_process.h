//// Copyright (C) 2019 Beijing Bytedance Network Technology Co., Ltd.

#ifndef BEF_EFFECT_YUV_PROCESS_H
#define BEF_EFFECT_YUV_PROCESS_H

#include "bef_effect_ai_public_define.h"
/**
 * @param image yuv数据源      data with format yuv
 * @param dst 结果输出地址      output data with format rgba
 * @param pixel_format yuv数据格式      data type of yuv
 * 目前支持BEF_AI_PIX_FMT_YUV420P BEF_AI_PIX_FMT_NV12 和BEF_AI_PIX_FMT_NV21      only support BEF_AI_PIX_FMT_YUV420P, BEF_AI_PIX_FMT_NV12 and BEF_AI_PIX_FMT_NV21
 * @param image_width输入图像宽度     width of image
 * @param image_height 输入图像高度   height of image
 * @param dst_width 输出图像宽度      width of out image
 * @param dst_height 输出图像高度     width of out image
 * @param orientation 输入图像的旋转角度     orientation of input image
 * @param is_front 是否需要左右翻转         whether needed flip left and right
 */
BEF_SDK_API void cvt_yuv2rgba(
        const unsigned char* image,
        unsigned char* dst,
        bef_ai_pixel_format pixel_format,
        int image_width,
        int image_height,
        int dst_width,
        int dst_height,
        bef_ai_rotate_type orientation,
        bool is_front);

/**
 * @param image rgba数据源     data with format rgba
 * @param dst 结果输出地址      data with format yuv
 * @param pixel_format 输出yuv数据的格式 format of yuv
 * 目前支持BEF_AI_PIX_FMT_YUV420P BEF_AI_PIX_FMT_NV12 和BEF_AI_PIX_FMT_NV21 only support BEF_AI_PIX_FMT_YUV420P BEF_AI_PIX_FMT_NV12 and BEF_AI_PIX_FMT_NV21
 * @param image_width输入图像宽度 width of image
 * @param image_height 输入图像高度 height of image
 */
BEF_SDK_API void cvt_rgba2yuv(
        const unsigned char *image,
        unsigned char *dst,
        bef_ai_pixel_format dst_pixel_format,
        int image_width,
        int image_height);

#endif //BEF_EFFECT_YUV_PROCESS_H
