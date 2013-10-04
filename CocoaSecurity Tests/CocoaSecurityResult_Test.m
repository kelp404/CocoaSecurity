//
//  CocoaSecurityResult_Test.m
//  CocoaSecurity
//
//  Created by Kelp on 2013/10/04.
//
//

#import <XCTest/XCTest.h>
# import "CocoaSecurity.h"


@interface CocoaSecurityResult_Test : XCTestCase {
    unsigned char *_data;
    CocoaSecurityResult *_result;
}

@end

@implementation CocoaSecurityResult_Test

- (void)setUp
{
    [super setUp];
    
    unsigned char data[] =
    {
        0xcd, 0x3d, 0x4f, 0x4b, 0xae, 0x0c, 0x9d, 0x72,
        0x14, 0x0c, 0x25, 0x22, 0xcb, 0x5d, 0xd1, 0x46
    };
    _data = malloc(16);
    memcpy(_data, data, 16);
    _result = [[CocoaSecurityResult alloc] initWithBytes:_data length:16];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testBase64
{
    NSString *expected = @"zT1PS64MnXIUDCUiy13RRg==";
    NSString *actual = _result.base64;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testHex
{
    NSString *expected = @"CD3D4F4BAE0C9D72140C2522CB5DD146";
    NSString *actual = _result.hex;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testHexLower
{
    NSString *expected = @"cd3d4f4bae0c9d72140c2522cb5dd146";
    NSString *actual = _result.hexLower;
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testData
{
    NSData *expected = [NSData dataWithBytes:_data length:16];
    NSData *actual = _result.data;
    XCTAssertEqualObjects(expected, actual, @"");
}


@end
