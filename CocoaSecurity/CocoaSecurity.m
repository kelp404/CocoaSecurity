//
//  CocoaSecurity.m
//
//  Created by Kelp on 12/5/12.
//  Copyright (c) 2012 Kelp http://kelp.phate.org/
//  MIT License
//

#import "CocoaSecurity.h"
#import <CommonCrypto/CommonHMAC.h>
#import <CommonCrypto/CommonCryptor.h>

#pragma mark - CocoaSecurity
@implementation CocoaSecurity


#pragma mark - AES Encrypt
// default AES Encrypt, key -> SHA384(key).sub(0, 32), iv -> SHA384(key).sub(32, 16)
+ (CocoaSecurityResult *)aesEncrypt:(NSString *)data key:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesEncrypt:data key:key];
}
- (CocoaSecurityResult *)aesEncrypt:(NSString *)data key:(NSString *)key
{
    CocoaSecurityResult * sha = [self sha384:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 32)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(32, 16)];
    
    return [self aesEncrypt:data key:aesKey iv:aesIv];
}
#pragma mark AES Encrypt 128, 192, 256
+ (CocoaSecurityResult *)aesEncrypt:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesEncrypt:data hexKey:key hexIv:iv];
}
+ (CocoaSecurityResult *)aesEncrypt:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesEncrypt:data key:key iv:iv];
}
+ (CocoaSecurityResult *)aesEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesEncryptWithData:data key:key iv:iv];
}
- (CocoaSecurityResult *)aesEncrypt:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
    NSData *aesKey = [decoder hex:key];
    NSData *aesIv = [decoder hex:iv];
    
    return [self aesEncrypt:data key:aesKey iv:aesIv];
}
- (CocoaSecurityResult *)aesEncrypt:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    return [self aesEncryptWithData:[data dataUsingEncoding:NSUTF8StringEncoding] key:key iv:iv];
}
- (CocoaSecurityResult *)aesEncryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    // check length of key and iv
    if ([iv length] != 16) {
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Length of iv is wrong. Length of iv should be 16(128bits)"
                                     userInfo:nil];
    }
    if ([key length] != 16 && [key length] != 24 && [key length] != 32 ) {
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Length of key is wrong. Length of iv should be 16, 24 or 32(128, 192 or 256bits)"
                                     userInfo:nil];
    }
    
    // setup output buffer
	size_t bufferSize = [data length] + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    
    // do encrypt
	size_t encryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
	if (cryptStatus == kCCSuccess) {
        CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        
        return result;
    }
    else {
        free(buffer);
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Encrypt Error!"
                                     userInfo:nil];
        return nil;
    }
}
#pragma mark - AES Decrypt
// default AES Decrypt, key -> SHA384(key).sub(0, 32), iv -> SHA384(key).sub(32, 16)
+ (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesDecryptWithBase64:data key:key];
}
- (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data key:(NSString *)key
{
    CocoaSecurityResult * sha = [self sha384:key];
    NSData *aesKey = [sha.data subdataWithRange:NSMakeRange(0, 32)];
    NSData *aesIv = [sha.data subdataWithRange:NSMakeRange(32, 16)];
    
    return [self aesDecryptWithBase64:data key:aesKey iv:aesIv];
}
#pragma mark AES Decrypt 128, 192, 256
+ (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesDecryptWithBase64:data hexKey:key hexIv:iv];
}
+ (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesDecryptWithBase64:data key:key iv:iv];
}
+ (CocoaSecurityResult *)aesDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs aesDecryptWithData:data key:key iv:iv];
}
- (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data hexKey:(NSString *)key hexIv:(NSString *)iv
{
    CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
    NSData *aesKey = [decoder hex:key];
    NSData *aesIv = [decoder hex:iv];
    
    return [self aesDecryptWithBase64:data key:aesKey iv:aesIv];
}
- (CocoaSecurityResult *)aesDecryptWithBase64:(NSString *)data key:(NSData *)key iv:(NSData *)iv
{
    CocoaSecurityDecoder *decoder = [CocoaSecurityDecoder new];
    return [self aesDecryptWithData:[decoder base64:data] key:key iv:iv];
}
- (CocoaSecurityResult *)aesDecryptWithData:(NSData *)data key:(NSData *)key iv:(NSData *)iv
{
    // check length of key and iv
    if ([iv length] != 16) {
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Length of iv is wrong. Length of iv should be 16(128bits)"
                                     userInfo:nil];
    }
    if ([key length] != 16 && [key length] != 24 && [key length] != 32 ) {
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Length of key is wrong. Length of iv should be 16, 24 or 32(128, 192 or 256bits)"
                                     userInfo:nil];
    }
    
    // setup output buffer
	size_t bufferSize = [data length] + kCCBlockSizeAES128;
	void *buffer = malloc(bufferSize);
    
    // do encrypt
	size_t encryptedSize = 0;
	CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          [key bytes],     // Key
                                          [key length],    // kCCKeySizeAES
                                          [iv bytes],       // IV
                                          [data bytes],
                                          [data length],
                                          buffer,
                                          bufferSize,
                                          &encryptedSize);
	if (cryptStatus == kCCSuccess) {
        CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:buffer length:encryptedSize];
        free(buffer);
        
        return result;
    }
    else {
        free(buffer);
        @throw [NSException exceptionWithName:@"Cocoa Security"
                                       reason:@"Decrypt Error!"
                                     userInfo:nil];
        return nil;
    }
}


#pragma mark - MD5
+ (CocoaSecurityResult *)md5:(NSString *)hashString
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs md5:hashString];
}
+ (CocoaSecurityResult *)md5WithData:(NSData *)hashData
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs md5WithData:hashData];
}
- (CocoaSecurityResult *)md5:(NSString *)hashString
{
    return [self md5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (CocoaSecurityResult *)md5WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    
    CC_MD5([hashData bytes], (CC_LONG)[hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark - HMAC-MD5
+ (CocoaSecurityResult *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacMd5:hashString hmacKey:key];
}
+ (CocoaSecurityResult *)hmacMd5WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacMd5WithData:hashData hmacKey:key];
}
- (CocoaSecurityResult *)hmacMd5:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacMd5WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
- (CocoaSecurityResult *)hmacMd5WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_MD5_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}


#pragma mark - SHA1
+ (CocoaSecurityResult *)sha1:(NSString *)hashString
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha1:hashString];
}
+ (CocoaSecurityResult *)sha1WithData:(NSData *)hashData
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha1WithData:hashData];
}
- (CocoaSecurityResult *)sha1:(NSString *)hashString
{
    return [self sha1WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (CocoaSecurityResult *)sha1WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CC_SHA1([hashData bytes], (CC_LONG)[hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA224
+ (CocoaSecurityResult *)sha224:(NSString *)hashString
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha224:hashString];
}
+ (CocoaSecurityResult *)sha224WithData:(NSData *)hashData
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha224WithData:hashData];
}
- (CocoaSecurityResult *)sha224:(NSString *)hashString
{
    return [self sha224WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (CocoaSecurityResult *)sha224WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA224_DIGEST_LENGTH);
    
    CC_SHA224([hashData bytes], (CC_LONG)[hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA224_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA256
+ (CocoaSecurityResult *)sha256:(NSString *)hashString
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha256:hashString];
}
+ (CocoaSecurityResult *)sha256WithData:(NSData *)hashData
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha256WithData:hashData];
}
- (CocoaSecurityResult *)sha256:(NSString *)hashString
{
    return [self sha256WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (CocoaSecurityResult *)sha256WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    
    CC_SHA256([hashData bytes], (CC_LONG)[hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA384
+ (CocoaSecurityResult *)sha384:(NSString *)hashString
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha384:hashString];
}
+ (CocoaSecurityResult *)sha384WithData:(NSData *)hashData
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha384WithData:hashData];
}
- (CocoaSecurityResult *)sha384:(NSString *)hashString
{
    return [self sha384WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (CocoaSecurityResult *)sha384WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA384_DIGEST_LENGTH);
    
    CC_SHA384([hashData bytes], (CC_LONG)[hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA384_DIGEST_LENGTH];
    free(digest);
    
    return result;
}
#pragma mark SHA512
+ (CocoaSecurityResult *)sha512:(NSString *)hashString
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha512:hashString];
}
+ (CocoaSecurityResult *)sha512WithData:(NSData *)hashData
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs sha512WithData:hashData];
}
- (CocoaSecurityResult *)sha512:(NSString *)hashString
{
    return [self sha512WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding]];
}
- (CocoaSecurityResult *)sha512WithData:(NSData *)hashData
{
    unsigned char *digest;
    digest = malloc(CC_SHA512_DIGEST_LENGTH);
    
    CC_SHA512([hashData bytes], (CC_LONG)[hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    free(digest);
    
    return result;
}


#pragma mark - HMAC-SHA1
+ (CocoaSecurityResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha1:hashString hmacKey:key];
}
+ (CocoaSecurityResult *)hmacSha1WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha1WithData:hashData hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha1:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha1WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha1WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA1_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA224
+ (CocoaSecurityResult *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha224:hashString hmacKey:key];
}
+ (CocoaSecurityResult *)hmacSha224WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha224WithData:hashData hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha224:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha224WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha224WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA224_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA224, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA224_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA256
+ (CocoaSecurityResult *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha256:hashString hmacKey:key];
}
+ (CocoaSecurityResult *)hmacSha256WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha256WithData:hashData hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha256:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha256WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha256WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA256_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA384
+ (CocoaSecurityResult *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha384:hashString hmacKey:key];
}
+ (CocoaSecurityResult *)hmacSha384WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha384WithData:hashData hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha384:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha384WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha384WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA384_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA384, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA384_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}
#pragma mark HMAC-SHA512
+ (CocoaSecurityResult *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha512:hashString hmacKey:key];
}
+ (CocoaSecurityResult *)hmacSha512WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    CocoaSecurity *cs = [CocoaSecurity new];
    return [cs hmacSha512WithData:hashData hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha512:(NSString *)hashString hmacKey:(NSString *)key
{
    return [self hmacSha512WithData:[hashString dataUsingEncoding:NSUTF8StringEncoding] hmacKey:key];
}
- (CocoaSecurityResult *)hmacSha512WithData:(NSData *)hashData hmacKey:(NSString *)key
{
    unsigned char *digest;
    digest = malloc(CC_SHA512_DIGEST_LENGTH);
    const char *cKey = [key cStringUsingEncoding:NSUTF8StringEncoding];
    
    CCHmac(kCCHmacAlgSHA512, cKey, strlen(cKey), [hashData bytes], [hashData length], digest);
    CocoaSecurityResult *result = [[CocoaSecurityResult alloc] initWithBytes:digest length:CC_SHA512_DIGEST_LENGTH];
    free(digest);
    cKey = nil;
    
    return result;
}

@end



#pragma mark - CocoaSecurityResult
@implementation CocoaSecurityResult

@synthesize data = _data;

#pragma mark - Init
- (id)initWithBytes:(unsigned char[])initData length:(NSUInteger)length
{
    self = [super init];
    if (self) {
        _data = [NSData dataWithBytes:initData length:length];
    }
    return self;
}

#pragma mark UTF8 String
// convert CocoaSecurityResult to UTF8 string
- (NSString *)utf8String
{
    NSString *result = [[NSString alloc] initWithData:_data encoding:NSUTF8StringEncoding];
    return result;
}

#pragma mark HEX
// convert CocoaSecurityResult to HEX string
- (NSString *)hex
{
    CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
    return [encoder hex:_data useLower:false];
}
- (NSString *)hexLower
{
    CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
    return [encoder hex:_data useLower:true];
}

#pragma mark Base64
// convert CocoaSecurityResult to Base64 string
- (NSString *)base64
{
    CocoaSecurityEncoder *encoder = [CocoaSecurityEncoder new];
    return [encoder base64:_data];
}

@end


#pragma mark - CocoaSecurityEncoder
@implementation CocoaSecurityEncoder

// convert NSData to Base64
- (NSString *)base64:(NSData *)data
{
    static const char lookup[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    long long inputLength = [data length];
    const unsigned char *inputBytes = [data bytes];
    
    long long maxOutputLength = (inputLength / 3 + 1) * 4;
    unsigned char *outputBytes = (unsigned char *)malloc(maxOutputLength);
    
    long long index;
    long long outputLength = 0;
    for (index = 0; index < inputLength - 2; index += 3)
    {
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[index] & 0x03) << 4) | ((inputBytes[index + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[((inputBytes[index + 1] & 0x0F) << 2) | ((inputBytes[index + 2] & 0xC0) >> 6)];
        outputBytes[outputLength++] = lookup[inputBytes[index + 2] & 0x3F];
    }
    
    //handle left-over data
    if (index == inputLength - 2)
    {
        // = terminator
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[((inputBytes[index] & 0x03) << 4) | ((inputBytes[index + 1] & 0xF0) >> 4)];
        outputBytes[outputLength++] = lookup[(inputBytes[index + 1] & 0x0F) << 2];
        outputBytes[outputLength++] = '=';
    }
    else if (index == inputLength - 1)
    {
        // == terminator
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0xFC) >> 2];
        outputBytes[outputLength++] = lookup[(inputBytes[index] & 0x03) << 4];
        outputBytes[outputLength++] = '=';
        outputBytes[outputLength++] = '=';
    }
    
    NSString *result;
    if (outputLength >= 4)
    {
        //truncate data to match actual output length
        outputBytes = realloc(outputBytes, outputLength);
        result = [[NSString alloc] initWithBytes:outputBytes length:outputLength encoding:NSASCIIStringEncoding];
    }
    free(outputBytes);
    return result;
}

// convert NSData to hex string
- (NSString *)hex:(NSData *)data useLower:(BOOL)isOutputLower
{
    if (data.length == 0) { return nil; }
    
    static const char HexEncodeCharsLower[] = "0123456789abcdef";
    static const char HexEncodeChars[] = "0123456789ABCDEF";
    char *resultData;
    // malloc result data
    resultData = malloc([data length] * 2 +1);
    // convert imgData(NSData) to char[]
    unsigned char *sourceData = ((unsigned char *)[data bytes]);
    NSUInteger length = [data length];
    
    if (isOutputLower) {
        for (NSUInteger index = 0; index < length; index++) {
            // set result data
            resultData[index * 2] = HexEncodeCharsLower[(sourceData[index] >> 4)];
            resultData[index * 2 + 1] = HexEncodeCharsLower[(sourceData[index] % 0x10)];
        }
    }
    else {
        for (NSUInteger index = 0; index < length; index++) {
            // set result data
            resultData[index * 2] = HexEncodeChars[(sourceData[index] >> 4)];
            resultData[index * 2 + 1] = HexEncodeChars[(sourceData[index] % 0x10)];
        }
    }
    resultData[[data length] * 2] = 0;
    
    // convert result(char[]) to NSString
    NSString *result = [NSString stringWithCString:resultData encoding:NSASCIIStringEncoding];
    sourceData = nil;
    free(resultData);
    
    return result;
}

@end

#pragma mark - CocoaSecurityDecoder
@implementation CocoaSecurityDecoder
- (NSData *)base64:(NSString *)string
{
    static const char lookup[] =
    {
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99,
        99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 62, 99, 99, 99, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 99, 99, 99, 99, 99, 99,
        99,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 99, 99, 99, 99, 99,
        99, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 99, 99, 99, 99, 99
    };
    
    NSData *inputData = [string dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSUInteger inputLength = [inputData length];
    const unsigned char *inputBytes = [inputData bytes];
    
    NSMutableData *outputData = [NSMutableData dataWithLength:(inputLength / 4 + 1) * 3];
    unsigned char *outputBytes = (unsigned char *)[outputData mutableBytes];
    
    int accumulator = 0;
    long long outputLength = 0;
    unsigned char accumulated[] = {0, 0, 0, 0};
    for (NSUInteger index = 0; index < inputLength; index++)
    {
        unsigned char decoded = lookup[inputBytes[index] & 0x7F];
        if (decoded != 99)
        {
            accumulated[accumulator] = decoded;
            if (accumulator == 3)
            {
                outputBytes[outputLength++] = (accumulated[0] << 2) | (accumulated[1] >> 4);
                outputBytes[outputLength++] = (accumulated[1] << 4) | (accumulated[2] >> 2);
                outputBytes[outputLength++] = (accumulated[2] << 6) | accumulated[3];
            }
            accumulator = (accumulator + 1) % 4;
        }
    }
    
    //handle left-over data
    if (accumulator > 0) outputBytes[outputLength] = (accumulated[0] << 2) | (accumulated[1] >> 4);
    if (accumulator > 1) outputBytes[++outputLength] = (accumulated[1] << 4) | (accumulated[2] >> 2);
    if (accumulator > 2) outputLength++;
    
    //truncate data to match actual output length
    outputData.length = outputLength;
    return outputLength? outputData: nil;
}
- (NSData *)hex:(NSString *)data
{
    if (data.length == 0) { return nil; }
    
    static const unsigned char HexDecodeChars[] = 
    {
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 1, //49
        2, 3, 4, 5, 6, 7, 8, 9, 0, 0, //59
        0, 0, 0, 0, 0, 10, 11, 12, 13, 14,
        15, 0, 0, 0, 0, 0, 0, 0, 0, 0,  //79
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 10, 11, 12,   //99
        13, 14, 15
    };
    
    // convert data(NSString) to CString
    const char *source = [data cStringUsingEncoding:NSUTF8StringEncoding];
    // malloc buffer
    unsigned char *buffer;
    NSUInteger length = strlen(source) / 2;
    buffer = malloc(length);
    for (NSUInteger index = 0; index < length; index++) {
        buffer[index] = (HexDecodeChars[source[index * 2]] << 4) + (HexDecodeChars[source[index * 2 + 1]]);
    }
    // init result NSData
    NSData *result = [NSData dataWithBytes:buffer length:length];
    free(buffer);
    source = nil;
    
    return  result;
}

@end
