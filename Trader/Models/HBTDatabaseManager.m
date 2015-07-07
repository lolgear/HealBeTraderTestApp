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
#import "FirstTimeConversion.h"
#import "NSFoundationExtendedMethods.h"
#import <AFNetworking/AFURLConnectionOperation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static DDLogLevel ddLogLevel = DDLogLevelDebug;

@implementation HBTDatabaseManager

#pragma mark - Currency
+ (void)loadCurrencies:(MRSaveCompletionHandler)completion {
    // load currencies from file and put them into db.
    // I want like this, ok :3
    [[HBTAPIClient sharedAPIClient] liveRatesWithSuccessBlock:^(id responseObject) {
        if (responseObject[@"error"]) {
            if (completion) {
                NSError *error = [NSError errorWithDomain:@"com.trader.network" code:42 userInfo:nil];
                completion(NO, error);
            }
        }
        else {
            NSDictionary *responseDictionary = (NSDictionary *)responseObject;
            
            NSString *source = responseDictionary[@"source"];
            NSString *pattern = [@"^" stringByAppendingString:source];
            NSArray *currencies =
            [[(NSDictionary *)responseDictionary[@"quotes"] allKeys] compactObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
                NSString *result =
                [obj stringByReplacingOccurrencesOfStringPattern:pattern withString:@""];
                return @{@"code":result, @"name":result};
            }];
            [Currency saveAllFromDictionaries:currencies completion:completion];
        }
    } errorBlock:^(NSError *error, NSString *errorDescription) {
        DDLogError(@"error is %@", error);
        if (completion) {
            completion(NO, error);
        }
    }];
    //    NSDictionary *currenciesDictionary = [JSONFileReader currenciesDictionary];
    //    NSArray *currencies =
    //    [[currenciesDictionary allKeys] mapObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
    //        return @{@"code" : obj, @"name" : currenciesDictionary[obj]};
    //    }];
    //    [self saveCurrencies:currencies completion:completion];
}


#pragma mark - Helpers / Conversion
+ (NSArray *) conversionsFromDictionary:(NSDictionary *)dictionary {
    NSDictionary * quotes = dictionary[@"quotes"];
    return
    [[quotes allKeys] mapObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
        return @{
                 @"source" : dictionary[@"source"],
                 @"target" : obj,
                 @"quote" : quotes[obj],
                 @"timestamp" : dictionary[@"timestamp"]
                 };
    }];
}

#pragma mark - Conversion
+ (void)loadConversionsWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock withCompletion:(MRSaveCompletionHandler)completion {
    
    
    NSArray *operations =
    [[Conversion sourcesAndTargets] compactObjectsUsingBlock:^AFURLConnectionOperation *(NSDictionary *obj, NSUInteger idx) {
        return [[HBTAPIClient sharedAPIClient] liveOperationForSource:obj[@"source"] withCurrencies:obj[@"currencies"]];
    }];
    
    NSArray *requestOperations =
    [AFURLConnectionOperation batchOfRequestOperations:operations progressBlock:progressBlock completionBlock:^(NSArray *operations) {
        NSArray *responses =
        [operations compactObjectsUsingBlock:^NSDictionary *(AFURLConnectionOperation * obj, NSUInteger idx) {
            return ((NSDictionary *)[obj.responseData jsonObject]);
        }];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            for (NSDictionary *responseObject in responses) {
                if (responseObject[@"error"]) {
                    // do something :/
                    DDLogDebug(@"error %@", responseObject[@"error"]);
                }
                else {
                    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                    NSArray *conversions =
                    [self conversionsFromDictionary:responseDictionary];
                    for (NSDictionary * conversion in conversions) {
                        [Conversion createWithDictionary:conversion inContext:localContext];
                    }
                }
            }
        } completion:completion];
    }];
    
    DDLogDebug(@"current queue %@", requestOperations);
    
    [[NSOperationQueue mainQueue] addOperations:requestOperations waitUntilFinished:NO];
//    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
//        for (NSDictionary * sourceDictionary in [Conversion sourcesAndTargets]){
//            NSString *source = sourceDictionary[@"source"];
//            NSArray *currencies = sourceDictionary[@"currencies"];
//            
//            [[HBTAPIClient sharedAPIClient] liveRatesForSource:source withCurrencies:currencies successBlock:^(id responseObject) {
//                // should save currencies
//                if (responseObject[@"error"]) {
//                    // do something :/
//                    DDLogDebug(@"error %@", responseObject[@"error"]);
//                }
//                else {
//                    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
//                    NSArray *conversions =
//                    [self conversionsFromDictionary:responseDictionary];
//                    for (NSDictionary * conversion in conversions) {
//                        [Conversion createWithDictionary:conversion inContext:localContext];
//                    }
//                }
//            } errorBlock:^(NSError *error, NSString *errorDescription) {
//            }];
//        }
//    } completion:completion];
}

+ (void)loadFirstTimeConversionsWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock withCompletion:(MRSaveCompletionHandler)completion {

    NSArray *allCurrenciesCodes = [[Currency MR_findAll] valueForKey:@"code"];
    NSArray *operations =
    [allCurrenciesCodes compactObjectsUsingBlock:^AFURLConnectionOperation *(NSString *obj, NSUInteger idx) {
        return [[HBTAPIClient sharedAPIClient] liveOperationForSource:obj withCurrencies:nil];
    }];
    
    NSArray *requestOperations =
    [AFURLConnectionOperation batchOfRequestOperations:operations progressBlock:progressBlock completionBlock:^(NSArray *operations) {
        NSArray *responses =
        [operations compactObjectsUsingBlock:^NSDictionary *(AFURLConnectionOperation * obj, NSUInteger idx) {
            return ((NSDictionary *)[obj.responseData jsonObject]);
        }];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            for (NSDictionary *responseObject in responses) {
                if (responseObject[@"error"]) {
                    // do something :/
                    DDLogDebug(@"error %@", responseObject[@"error"]);
                }
                else {
                    NSDictionary *responseDictionary = (NSDictionary *)responseObject;
                    NSArray *conversions =
                    [self conversionsFromDictionary:responseDictionary];
                    for (NSDictionary * conversion in conversions) {
                        [FirstTimeConversion createWithDictionary:conversion inContext:localContext];
                    }
                }
            }
        } completion:completion];
    }];
    
    DDLogDebug(@"current queue %@", requestOperations);
    
    [[NSOperationQueue mainQueue] addOperations:requestOperations waitUntilFinished:NO];
}

@end
