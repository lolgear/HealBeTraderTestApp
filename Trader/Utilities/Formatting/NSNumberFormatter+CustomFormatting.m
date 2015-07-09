//
//  NSNumberFormatter+CustomFormatting.m
//  Trader
//
//  Created by Lobanov Dmitry on 09.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "NSNumberFormatter+CustomFormatting.h"

@implementation NSNumberFormatter (CustomFormatting)

+ (instancetype)quoteAndTrendFormatter {
    NSNumberFormatter *formatter = nil;
    
    formatter = [[NSNumberFormatter alloc] init];
    formatter.zeroSymbol = @"0";
    formatter.decimalSeparator = @".";
    formatter.minimumIntegerDigits = 1;
    formatter.minimumFractionDigits = 2;
    formatter.positivePrefix = @"+";
    formatter.negativePrefix = @"-";
    
    return formatter;
}

+ (instancetype)quoteFormatter {
    NSNumberFormatter *formatter = [self quoteAndTrendFormatter];
    formatter.positivePrefix = @"";
    formatter.negativePrefix = @"";
    formatter.maximumFractionDigits = 2;
    return formatter;
}

+ (instancetype)trendFormatter {
    NSNumberFormatter *formatter = [self quoteAndTrendFormatter];
    formatter.maximumFractionDigits = 10;
    return formatter;
}

@end
