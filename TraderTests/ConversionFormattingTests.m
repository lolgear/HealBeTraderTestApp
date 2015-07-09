//
//  CurrencyFormatting.m
//  Trader
//
//  Created by Lobanov Dmitry on 09.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "NSNumberFormatter+CustomFormatting.h"
#import "NSString+CustomFormatting.h"

@interface ConversionFormattingTests : XCTestCase

@end

@implementation ConversionFormattingTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testShouldFormatQuoteAndTrendWell {
    // This is an example of a functional test case.
    NSNumber * quote = @(10.0);
    NSNumber * trend = @(0.003);
    
    NSString * expectedQuote = @"10.00";
    NSString * expectedTrend = @"+0.003";
    NSString * expectedResult = [[[expectedQuote stringByAppendingString:@" ("] stringByAppendingString:expectedTrend] stringByAppendingString:@")"]; // 10.00 (+0.003)
    
    NSString * quoteString = [[NSNumberFormatter quoteFormatter] stringFromNumber:quote];
    XCTAssert([expectedQuote isEqualToString:quoteString], @"quote OK!");
    
    NSString * trendString = [[NSNumberFormatter trendFormatter] stringFromNumber:trend];
    
    XCTAssert([expectedTrend isEqualToString:trendString], @"trend OK!");
    
    NSString * result = [NSString labelTextWithTrend:trendString andQuote:quoteString];
    
    XCTAssert([result isEqualToString:expectedResult], @"OK!");
    
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
