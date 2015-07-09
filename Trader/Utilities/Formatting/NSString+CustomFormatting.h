//
//  NSString+CustomFormatting.h
//  Trader
//
//  Created by Lobanov Dmitry on 09.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (CustomFormatting)

+ (instancetype) labelTextWithTrend:(NSString *)trend andQuote:(NSString *)quote;

@end
