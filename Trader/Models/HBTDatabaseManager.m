//
//  HBTDatabaseManager.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "HBTDatabaseManager.h"
#import "JSONFileReader.h"
#import "Currency.h"
#import "Conversion.h"
#import "NSFoundationExtendedMethods.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
static DDLogLevel ddLogLevel = DDLogLevelDebug;

@implementation HBTDatabaseManager

#pragma mark - Currency
+ (void)findOrCreateCurrency:(NSDictionary *)currencyDictionary inContext:(NSManagedObjectContext *)context {
    if (![currencyDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *code = currencyDictionary[@"code"];
    NSString *name = currencyDictionary[@"name"];
    Currency *currency = [Currency MR_findFirstByAttribute:@"code" withValue:code inContext:context];
    
    if (currency) {
        return;
    }
    
    currency = [Currency MR_createEntityInContext:context];
    currency.code = code;
    currency.name = name;
}

+ (void)loadCurrencies:(MRSaveCompletionHandler)completion {
    // load currencies from file and put them into db.
    // I want like this, ok :3
    NSDictionary *currenciesDictionary = [JSONFileReader currenciesDictionary];
    NSArray *currencies =
    [[currenciesDictionary allKeys] mapObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
        return @{@"code" : obj, @"name" : currenciesDictionary[obj]};
    }];
    [self saveCurrencies:currencies completion:completion];
}

+ (void)saveCurrency:(NSDictionary *)currencyDictionary completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self findOrCreateCurrency:currencyDictionary inContext:localContext];
    } completion:completion];
}

+ (void)saveCurrencies:(NSArray *)currencies completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *currency in currencies) {
            [self findOrCreateCurrency:currency inContext:localContext];
        }
    } completion:completion];
}

#pragma mark - Conversions
+ (NSArray *)conversionsFromDictionary:(NSDictionary *)dictionary {
    return
    [[dictionary[@"quotes"] allKeys] mapObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
        return @{
                 @"source" : dictionary[@"source"],
                 @"target" : obj,
                 @"quote" : dictionary[obj],
                 @"timestamp" : dictionary[@"timestamp"]
                 };
    }];
}

+ (void)createConversion:(NSDictionary *)conversionDictionary inContext:(NSManagedObjectContext *)context {
    if (![conversionDictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *source = conversionDictionary[@"source"];
    NSString *target = conversionDictionary[@"target"];
    NSNumber *timestamp = conversionDictionary[@"timestamp"];
    NSNumber *quote = conversionDictionary[@"quote"];
    NSNumber *added_at = nil;
    
    Currency *sourceCurrency = [Currency MR_findFirstOrCreateByAttribute:@"code" withValue:source inContext:context];
    Currency *targetCurrency = [Currency MR_findFirstOrCreateByAttribute:@"code" withValue:target inContext:context];
    
    if (!added_at) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source.code = %@ AND target.code = %@", source, target];
        Conversion *conversion = [Conversion MR_findFirstWithPredicate:predicate inContext:context];
        if (conversion) {
            added_at = conversion.added_at;
        }
    }
    
    if (!added_at) {
        added_at = conversionDictionary[@"added_at"];
    }
    
    if (sourceCurrency && targetCurrency && added_at) {
        
        Conversion * conversion = [Conversion MR_createEntityInContext:context];
        conversion.source = sourceCurrency;
        conversion.target = targetCurrency;
        conversion.quote = quote;
        conversion.added_at = added_at;
        [conversion fetchedAt:timestamp.integerValue];
    }
}

+ (void)loadConversions:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary * sourceDictionary in [Conversion sourcesAndTargets]){
            NSString *source = sourceDictionary[@"source"];
            NSArray *currencies = sourceDictionary[@"currencies"];
            
            [[HBTAPIClient sharedAPIClient] liveRatesForSource:source withCurrencies:currencies successBlock:^(id responseObject) {
                // should save currencies
                if (responseObject[@"error"]) {
                    // do something :/
                    DDLogDebug(@"error %@", responseObject[@"error"]);
                }
                else {
                    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                    NSArray *conversions =
                    [self conversionsFromDictionary:responseDictionary];
                    for (NSDictionary * conversion in conversions) {
                        [self createConversion:conversion inContext:localContext];
                    }
                }
            } errorBlock:^(NSError *error, NSString *errorDescription) {
            }];
        }
    } completion:completion];
}

+ (void)saveConversion:(NSDictionary *)conversionDictionary completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self createConversion:conversionDictionary inContext:localContext];
    } completion:completion];
}

+ (void)saveConversions:(NSArray *)conversions completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *conversion in conversions) {
            [self createConversion:conversion inContext:localContext];
        }
    } completion:completion];
}

+ (void)deleteConversion:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [conversion MR_deleteEntityInContext:localContext];
    } completion:completion];
}

+ (void)deleteOldConversionsWithLowerBorder:(NSInteger)timestamp completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp < %@", @(timestamp)];
        [Conversion MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:completion];
}

+ (Conversion *)conversionBySource:(NSString *)source andTarget:(NSString *)target {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" source.code  = %@ AND target.code = %@ ", source, target];
    return [Conversion MR_findFirstWithPredicate:predicate];
}

@end
