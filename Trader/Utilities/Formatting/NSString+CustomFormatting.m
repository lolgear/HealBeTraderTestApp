//
//  NSString+CustomFormatting.m
//  Trader
//
//  Created by Lobanov Dmitry on 09.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "NSString+CustomFormatting.h"

@implementation NSString (CustomFormatting)

+ (instancetype) labelTextWithTrend:(NSString *)trend andQuote:(NSString *)quote {
    
    NSString *wearingParenthesis = [NSString stringWithFormat:@"(%@)",trend];
    NSString *string =
    [[quote stringByAppendingString:@" "] stringByAppendingString:wearingParenthesis];
    return string;
}

@end
