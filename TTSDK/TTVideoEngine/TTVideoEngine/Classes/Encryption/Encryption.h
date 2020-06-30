//
//  Encryption.h
//  TTVideoEngine
//
//  Created by wyf on 2018/8/5.
//
#import <Foundation/Foundation.h>

@interface Encryption : NSObject
+ (void) encryptInfo:(id  _Nullable)jsonObject completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;
+ (void) decryptInfo:(id  _Nullable)jsonObject completion:(void (^)(id _Nullable jsonObject, NSError * _Nullable error))completionHandler;
+ (NSData *)RSAencryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef;
+ (NSData *)RSAdecryptData:(NSData *)data withKeyRef:(SecKeyRef) keyRef;
+ (NSData *)AES256ParmEncryptWithKey:(NSString *)key Encrypttext:(NSData *)text;
+ (NSData *)AES256ParmDecryptWithKey:(NSString *)key Decrypttext:(NSData *)text;
+ (NSData *) RSAEncryption:(NSData *)keyInByte cipertext:(NSData *)ciphertext mode:(NSInteger)mode;
+ (NSData *) AESEncryption:(NSData *)keyInByte cipertext:(NSData *)ciphertext mode:(NSInteger)mode;
@end

