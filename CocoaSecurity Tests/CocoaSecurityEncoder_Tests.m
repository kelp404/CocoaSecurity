//
//  CocoaSecurity_Tests.m
//  CocoaSecurity Tests
//
//  Created by Kelp on 2013/10/04.
//
//

#import <XCTest/XCTest.h>
#import "CocoaSecurity.h"


@interface CocoaSecurityEncoder_Tests : XCTestCase {
    CocoaSecurityEncoder *_encoder;
}
@end



@implementation CocoaSecurityEncoder_Tests

- (void)setUp
{
    [super setUp];

    _encoder = [CocoaSecurityEncoder new];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testEncodeHex
{
    NSString *expected = @"414F";
    NSData *data = [@"AO" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *actual = [_encoder hex:data useLower:NO];
    XCTAssertEqualObjects(expected, actual, @"");
    
    expected = @"414f";
    actual = [_encoder hex:data useLower:YES];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testEncodeHexNil
{
    NSString *actual = [_encoder hex:[NSData new] useLower:YES];
    XCTAssertNil(actual, @"");
}

- (void)testEncodeBase64
{
    NSString *expected = @"c291cmNl";
    NSData *data = [@"source" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *actual = [_encoder base64:data];
    XCTAssertEqualObjects(expected, actual, @"");
}

- (void)testEncodeBase64Nil
{
    NSString *actual = [_encoder base64:[NSData new]];
    XCTAssertNil(actual, @"");
}


@end
