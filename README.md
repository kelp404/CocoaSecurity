##CocoaSecurity 1.0

Kelp http://kelp.phate.org/ <br/>
MIT License <br/>
Apache Licence 2.0: GTMBase64 by Google Inc.


CocoaSecurity include 4 classes, **CocoaSecurity**, **CocoaSecurityResult**, **CocoaSecurityEncoder** and **CocoaSecurityDecoder**.

###CocoaSecurity
CocoaSecurity is core. It provides AES encrypt, AES decrypt, Hash(MD5, HmacMD5, SHA1~SHA512, HmacSHA1~HmacSHA512) messages.
<br/><br/>
**MD5:**
```objective-c
CocoaSecurity *cs = [[[CocoaSecurity alloc] init] autorelease];
CocoaSecurityResult *md5Result = [cs md5:@"kelp"];

// md5Result.hex = 'C40C69779E15780ADAE46C45EB451E23'
// md5Result.hexLower = 'c40c69779e15780adae46c45eb451e23'
// md5Result.base64 = 'xAxpd54VeAra5GxF60UeIw=='
```
**SHA256:**
```objective-c
CocoaSecurity *cs = [[[CocoaSecurity alloc] init] autorelease];
CocoaSecurityResult *sha256Result = [cs sha256:@"kelp"];

// sha256Result.hexLower = '280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9'
// sha256Result.base64 = 'KA+LuMQ9Uy84nvDipTISILB4KwZSBdzfy42PAu1RFbk='
```
**default AES Encrypt:**<br/>
key -> SHA384(key).sub(0, 32)<br/>
iv -> SHA384(key).sub(32, 16)
```objective-c
CocoaSecurity *cs = [[[CocoaSecurity alloc] init] autorelease];
CocoaSecurityResult *aesDefault = [cs aesEncrypt:@"kelp" key:@"key"];

// aesDefault.base64 = 'ez9uubPneV1d2+rpjnabJw=='
```
**AES256 Encrypt & Decrypt:**
```objective-c
CocoaSecurity *cs = [[[CocoaSecurity alloc] init] autorelease];

CocoaSecurityResult *aes256 = [cs aesEncrypt:@"kelp"
                                      hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
// aes256.base64 = 'WQYg5qvcGyCBY3IF0hPsoQ=='

CocoaSecurityResult *aes256Decrypt = [cs aesDecryptWithBase64:@"WQYg5qvcGyCBY3IF0hPsoQ==" 
                                      hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                       hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
// aes256Decrypt.utf8String = 'kelp'
```


###CocoaSecurityResult
CocoaSecurityResult is the result class of CocoaSecurity. It provides convert result data to NSData, NSString, HEX string, Base64 string.

```objective-c
@property (retain) NSData *data;
@property (retain, readonly) NSString *utf8String;
@property (retain, readonly) NSString *hex;
@property (retain, readonly) NSString *hexLower;
@property (retain, readonly) NSString *base64;
```


###CocoaSecurityEncoder
CocoaSecurityEncoder provides convert NSData to HEX string, Base64 string.

```objective-c
- (NSString *)base64: (NSData *)data;
- (NSString *)hex: (NSData *)data useLower: (bool)isOutputLower;
```
**example:**
```objective-c
CocoaSecurityEncoder *encoder = [[[CocoaSecurityEncoder alloc] init] autorelease];
NSString *str1 = [encoder hex:[@"kelp" dataUsingEncoding:NSUTF8StringEncoding] useLower:false];
// str1 = '6B656C70'
NSString *str2 = [encoder base64:[@"kelp" dataUsingEncoding:NSUTF8StringEncoding]];
// str2 = 'a2VscA=='
```

###CocoaSecurityDecoder
CocoaSecurityEncoder provides convert HEX string or Base64 string to NSData.

```objective-c
- (NSData *)base64: (NSString *)data;
- (NSData *)hex: (NSString *)data;
```
**example:**
```objective-c
CocoaSecurityDecoder *decoder = [[[CocoaSecurityDecoder alloc] init] autorelease];
NSData *data1 = [decoder hex:@"CC0A69779E15780ADAE46C45EB451A23"];
// data1 = <cc0a6977 9e15780a dae46c45 eb451a23>
NSData *data2 = [decoder base64:@"zT1PS64MnXIUDCUiy13RRg=="];
// data2 = <cd3d4f4b ae0c9d72 140c2522 cb5dd146>
```

