//
//  CocoaSecurityDecoder_Tests.m
//  CocoaSecurity
//
//  Created by Kelp on 2013/10/04.
//
//

#import <XCTest/XCTest.h>
#import "CocoaSecurity.h"


@interface CocoaSecurityDecoder_Tests : XCTestCase {
    CocoaSecurityDecoder *_decoder;
}

@end



@implementation CocoaSecurityDecoder_Tests

- (void)setUp
{
    [super setUp];
    
    _decoder = [CocoaSecurityDecoder new];
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

- (void)testDecodeHex
{
    NSData *expected = [@"AO" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *actual = [_decoder hex:@"414F"];
    XCTAssertEqualObjects(expected, actual, @"");
    
    actual = [_decoder hex:@"414f"];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testDecodeHexNil
{
    NSData *actual = [_decoder hex:@""];
    XCTAssertNil(actual, @"");
}

- (void)testDecodeBase64
{
    NSData *expected = [@"source" dataUsingEncoding:NSUTF8StringEncoding];
    NSData *actual = [_decoder base64:@"c291cmNl"];
    XCTAssertEqualObjects(expected, actual, @"");
}
- (void)testDecodeBase64Nil
{
    NSData *actual = [_decoder base64:@""];
    XCTAssertNil(actual, @"");
}


@end
