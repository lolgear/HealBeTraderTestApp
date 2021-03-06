//
//  NSDate+ExtendedMethods.h
//  Airkey
//
//  Created by Lobanov Dmitry on 22.06.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (ExtendedMethods)

+ (NSUInteger)units:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSUInteger)units:(NSCalendarUnit)unit toDate:(NSDate *)toDate;
- (NSUInteger)units:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate;

@end
