//
//  NSDate+ExtendedMethods.m
//  Airkey
//
//  Created by Lobanov Dmitry on 22.06.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import "NSDate+ExtendedMethods.h"

@implementation NSDate (ExtendedMethods)

+ (NSUInteger)units:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:unit
                                                        fromDate:fromDate
                                                          toDate:toDate
                                                         options:NSCalendarWrapComponents];
    return [components valueForComponent:unit];
}

- (NSUInteger)units:(NSCalendarUnit)unit toDate:(NSDate *)toDate {
    return [self.class units:unit fromDate:self toDate:toDate];
}

- (NSUInteger)units:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate {
    return [self.class units:unit fromDate:fromDate toDate:self];
}


@end
