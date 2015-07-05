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

+ (void)saveCurrency:(NSDictionary *)currencyDictionary completion:(MRSaveCompletionHandler)completion;

+ (void)saveCurrencies:(NSArray *)currencies completion:(MRSaveCompletionHandler)completion;

#pragma mark - Conversion
+ (void)loadConversions:(MRSaveCompletionHandler)completion;

+ (void)saveConversion:(NSDictionary *)conversionDictionary completion:(MRSaveCompletionHandler)completion;

+ (void)saveConversions:(NSArray *)conversions completion:(MRSaveCompletionHandler)completion;

+ (void)deleteConversion:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion;

+ (void)deleteOldConversionsWithLowerBorder:(NSInteger)timestamp completion:(MRSaveCompletionHandler)completion;

+ (Conversion *)conversionBySource:(NSString *)source andTarget:(NSString *)target;
@end
