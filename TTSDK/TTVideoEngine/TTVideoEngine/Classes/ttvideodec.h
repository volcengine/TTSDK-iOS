//
//  ttvideodec.h
//  player_for_ios
//
//  Created by guikunzhi on 2018/3/12.
//

#ifndef ttvideodec_h
#define ttvideodec_h

#ifdef __cplusplus
extern "C" {
#endif
void decodeMethodAndKey(const char *encodedStr,int encodeLen,char **key,char **method);
#ifdef __cplusplus
}
#endif

#endif /* ttvideodec_h */
