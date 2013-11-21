//
//  CocoaSecurity_Tests.m
//  CocoaSecurity Tests
//
//  Created by Kelp on 2013/10/04.
//
//

#import <XCTest/XCTest.h>
#import "CocoaSecurity.h"


@interface CocoaSecurity_Tests : XCTestCase

@end



@implementation CocoaSecurity_Tests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEncryptAES128
{
    NSString *expected = @"zT1PS64MnXIUDCUiy13RRg==";
    CocoaSecurityResult *actual = [CocoaSecurity aesEncrypt:@"kelp"
                                                     hexKey:@"C40C69779E15780ADAE46C45EB451E23"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    XCTAssertEqualObjects(expected, actual.base64, @"");
}

- (void)testEncryptAES192
{
    NSString *expected = @"zSpp/l/B/Gp+j0vByqcTVg==";
    CocoaSecurityResult *actual = [CocoaSecurity aesEncrypt:@"kelp"
                                                     hexKey:@"C40C69779E15780ADAE46C45EB451E230000000000000000"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    XCTAssertEqualObjects(expected, actual.base64, @"");
}

- (void)testEncryptAES256
{
    NSString *expected = @"WQYg5qvcGyCBY3IF0hPsoQ==";
    CocoaSecurityResult *actual = [CocoaSecurity aesEncrypt:@"kelp"
                                                     hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    XCTAssertEqualObjects(expected, actual.base64, @"");
}

- (void)testEncryptAESDefault
{
    NSString *expected = @"ez9uubPneV1d2+rpjnabJw==";
    CocoaSecurityResult *actual = [CocoaSecurity aesEncrypt:@"kelp" key:@"key"];
    XCTAssertEqualObjects(expected, actual.base64, @"");
}

- (void)testDecryptAES128
{
    NSString *expected = @"kelp";
    CocoaSecurityResult *actual = [CocoaSecurity aesDecryptWithBase64:@"zT1PS64MnXIUDCUiy13RRg=="
                                                     hexKey:@"C40C69779E15780ADAE46C45EB451E23"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    XCTAssertEqualObjects(expected, actual.utf8String, @"");
}

- (void)testDecryptAES192
{
    NSString *expected = @"kelp";
    CocoaSecurityResult *actual = [CocoaSecurity aesDecryptWithBase64:@"zSpp/l/B/Gp+j0vByqcTVg=="
                                                     hexKey:@"C40C69779E15780ADAE46C45EB451E230000000000000000"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    XCTAssertEqualObjects(expected, actual.utf8String, @"");
}

- (void)testDecryptAES256
{
    NSString *expected = @"kelp";
    CocoaSecurityResult *actual = [CocoaSecurity aesDecryptWithBase64:@"WQYg5qvcGyCBY3IF0hPsoQ=="
                                                     hexKey:@"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9"
                                                      hexIv:@"CC0A69779E15780ADAE46C45EB451A23"];
    XCTAssertEqualObjects(expected, actual.utf8String, @"");
}

- (void)testDecryptAESDefault
{
    NSString *expected = @"kelp";
    CocoaSecurityResult *actual = [CocoaSecurity aesDecryptWithBase64:@"ez9uubPneV1d2+rpjnabJw==" key:@"key"];
    XCTAssertEqualObjects(expected, actual.utf8String, @"");
}

- (void)testMD5
{
    NSString *expected = @"C40C69779E15780ADAE46C45EB451E23";
    CocoaSecurityResult *md5 = [CocoaSecurity md5:@"kelp"];
    NSString *actual = md5.hex;
    XCTAssertEqualObjects(expected, actual , @"");
}

- (void)testHmacMD5
{
    NSString *expected = @"2DFF352719234D5D6A9839FD8F43C8D2";
    CocoaSecurityResult *hmacMd5 = [CocoaSecurity hmacMd5:@"kelp" hmacKey:@"key"];
    NSString *actual = hmacMd5.hex;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testSHA1
{
    NSString *expected = @"70b6a0495fb444a63297c83de187b1730a18e85a";
    CocoaSecurityResult *sha1 = [CocoaSecurity sha1:@"kelp"];
    NSString *actual = sha1.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testSHA224
{
    NSString *expected = @"1e124576cebf14ecdac30b8ca05ff94deb343f54ebb0eab21559dcf1";
    CocoaSecurityResult *sha224 = [CocoaSecurity sha224:@"kelp"];
    NSString *actual = sha224.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testSHA256
{
    NSString *expected = @"280f8bb8c43d532f389ef0e2a5321220b0782b065205dcdfcb8d8f02ed5115b9";
    CocoaSecurityResult *sha256 = [CocoaSecurity sha256:@"kelp"];
    NSString *actual = sha256.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");	
}

- (void)testSHA384
{
    NSString *expected = @"e0801e06e6eea6257018bc0f2aaf1f7ec23385ce2ac9865fe209322262f323e80c81f65e711e30d162af5638ef8b4334";
    CocoaSecurityResult *sha384 = [CocoaSecurity sha384:@"kelp"];
    NSString *actual = sha384.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testSHA512
{
    NSString *expected = @"af8489a9fb6dcb8973515cdda3366c939ebcc8ac8fb0a7c322f1333babe03655222930ad48b4924f1a1f13c23856bc3c2e1b93cb10c74e72362e5457756517ff";
    CocoaSecurityResult *sha512 = [CocoaSecurity sha512:@"kelp"];
    NSString *actual = sha512.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testHmacSHA1
{
    NSString *expected = @"fae888da051e44eb0c57f43935ad82cdbedf482f";
    CocoaSecurityResult *sha1 = [CocoaSecurity hmacSha1:@"kelp" hmacKey:@"key"];
    NSString *actual = sha1.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testHmacSHA224
{
    NSString *expected = @"4777556ee573705fcf6194de22947e09562653a84684c4b015a91e0c";
    CocoaSecurityResult *sha224 = [CocoaSecurity hmacSha224:@"kelp" hmacKey:@"key"];
    NSString *actual = sha224.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testHmacSHA256
{
    NSString *expected = @"09e6c01ee44e4fc87871d3d8eb5265b67a941e9bf68d1b33851aeeed0114cd33";
    CocoaSecurityResult *sha256 = [CocoaSecurity hmacSha256:@"kelp" hmacKey:@"key"];
    NSString *actual = sha256.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testHmacSHA384
{
    NSString *expected = @"99f2a12918f5e0c7e21ef4759ecb8dd882c95af32a204ac83928aa413e1d8e9ed312c29c41e2f3c00a78d448df11d15e";
    CocoaSecurityResult *sha384 = [CocoaSecurity hmacSha384:@"kelp" hmacKey:@"key"];
    NSString *actual = sha384.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testHmacSHA512
{
    NSString *expected = @"3807619fdaa2dd77e3dd554a627284406000a5c924db72202af0e6b1832789a94bacc710dc2b7da61fbfd6e1065dfe39085a872538f5b19fde112092c90d893a";
    CocoaSecurityResult *sha512 = [CocoaSecurity hmacSha512:@"kelp" hmacKey:@"key"];
    NSString *actual = sha512.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}


@end
