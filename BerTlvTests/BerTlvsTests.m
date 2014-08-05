//
//  BerTlvTests.m
//  BerTlvTests
//
//  Created by Evgeniy Sinev on 04/08/14.
//  Copyright (c) 2014 Evgeniy Sinev. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "BerTlv.h"
#import "BerTlvParser.h"
#import "HexUtil.h"
#import "BerTag.h"
#import "BerTlvs.h"

@interface BerTlvsTests : XCTestCase

@end


@implementation BerTlvsTests {

    BerTlvs *tlvs;
    NSString *hex;

    BerTag *TAG_DF7F;
    BerTag *TAG_E1;
    BerTag *TAG_EF;
    BerTag *TAG_E2;
    BerTag *TAG_DF0D;
}

- (void)setUp {
    [super setUp];

    hex =
        /*            0  1  2  3   4  5  6  7     8  9  a  b   c  d  e  f      0123 4567  89ab  cdef */
        /*    0 */ @"e1 35 9f 1e  08 31 36 30    32 31 34 33  37 ef 12 df" // .5.. .160  2143  7...
        /*   10 */ @"0d 08 4d 30  30 30 2d 4d    50 49 df 7f  04 31 2d 32" // ..M0 00-M  PI..  .1-2
        /*   20 */ @"32 ef 14 df  0d 0b 4d 30    30 30 2d 54  45 53 54 4f" // 2... ..M0  00-T  ESTO
        /*   30 */ @"53 df 7f 03  36 2d 35                               " // S... 6-5
    ;

    NSData *data = [HexUtil parse:hex];
    BerTlvParser *parser = [[BerTlvParser alloc] init];
    BerTlv *tlv = [parser parseConstructed:data];

    TAG_DF7F   = [BerTag parse:@"DF 7F"];
    TAG_E1     = [BerTag parse:@"E1"];
    TAG_E2     = [BerTag parse:@"E2"];
    TAG_EF     = [BerTag parse:@"EF"];
    TAG_DF0D   = [BerTag parse:@"DF0D"];

    NSArray *list = [tlv findAll:TAG_EF];
    tlvs = [[BerTlvs alloc] init:list];
}

- (void)testFind {
    XCTAssertNotNil([tlvs find:TAG_EF]);
    XCTAssertNotNil([tlvs find:TAG_DF0D]);
    XCTAssertNotNil([tlvs find:TAG_DF7F]);
    XCTAssertNil   ([tlvs find:TAG_E2]  );
}

- (void)testFindAll {
    XCTAssertEqual(0, [tlvs findAll:TAG_E1].count);
    XCTAssertEqual(0, [tlvs findAll:TAG_E2].count);

    XCTAssertEqual(2, [tlvs findAll:TAG_EF].count);
    XCTAssertEqual(2, [tlvs findAll:TAG_DF0D].count);
    XCTAssertEqual(2, [tlvs findAll:TAG_DF7F].count);
}

@end