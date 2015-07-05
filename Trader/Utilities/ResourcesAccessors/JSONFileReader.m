//
//  JSONFileReader.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "JSONFileReader.h"
#import "NSFoundationExtendedMethods.h"

@implementation JSONFileReader

+ (NSDictionary *)currenciesDictionary {
    NSString *filePath =
    [[NSBundle mainBundle] pathForResource:@"currencies" ofType:@"json"];
    
    NSData *content = [[NSData alloc] initWithContentsOfFile:filePath];
    
    return (NSDictionary *)[content jsonObject];
}

@end
