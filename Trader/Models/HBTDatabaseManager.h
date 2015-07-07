//
//  HBTDatabaseManager.h
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MagicalRecord/MagicalRecord.h>
#import "Conversion.h"
#import "HBTAPIClient.h"

@interface HBTDatabaseManager : NSObject

#pragma mark - Currency
+ (void)loadCurrencies:(MRSaveCompletionHandler)completion;

#pragma mark - Conversion
+ (void)loadConversionsWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock withCompletion:(MRSaveCompletionHandler)completion;

+ (void)loadFirstTimeConversionsWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock withCompletion:(MRSaveCompletionHandler)completion;

@end
