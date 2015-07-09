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
#import <AFNetworking/AFURLConnectionOperation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static DDLogLevel ddLogLevel = DDLogLevelDebug;

static NSOperationQueue *queue = nil;

@implementation HBTDatabaseManager

+ (NSOperationQueue *)operationQueue {
    if (!queue) {
        queue = [[NSOperationQueue alloc] init];
        queue.maxConcurrentOperationCount = 10;
    }
    return queue;
}

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
            NSArray *currencies =
            [[(NSDictionary *)responseDictionary[@"quotes"] allKeys] compactObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
                NSString *result =
                [self targetFromConversion:obj withSource:source];
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
}


#pragma mark - Helpers / Conversion
+ (NSString*) targetFromConversion:(NSString *)conversion withSource:(NSString *)source {
    NSString *pattern = [@"^" stringByAppendingString:source];
    return [conversion stringByReplacingOccurrencesOfStringPattern:pattern withString:@""];
}

+ (NSArray *) conversionsFromDictionary:(NSDictionary *)dictionary {
    NSDictionary * quotes = dictionary[@"quotes"];
    return
    [[quotes allKeys] mapObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
        return @{
                 @"source" : dictionary[@"source"],
                 @"target" : [self targetFromConversion:obj withSource:dictionary[@"source"]],
                 @"quote" : quotes[obj],
                 @"timestamp" : dictionary[@"timestamp"]
                 };
    }];
}

#pragma mark - Conversion
+ (NSArray *)downloadsForConversions:(NSArray *)conversions withProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock withCompletion:(MRSaveCompletionHandler)completion {
    NSArray *operations = conversions;
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
                        [Conversion updateOrCreateWithDictionary:conversion inContext:localContext];
                    }
                }
            }
        } completion:completion];
    }];

    return requestOperations;
}

+ (void)loadConversionsOperations:(NSArray *)conversions withProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock withCompletion:(MRSaveCompletionHandler)completion {
    NSArray *requestOperations = [self downloadsForConversions:conversions withProgressBlock:progressBlock withCompletion:completion];
    
    [[self operationQueue] addOperations:requestOperations waitUntilFinished:NO];
}

+ (void)loadFavoritedConversionsWithProgressBlock:(void (^)(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations))progressBlock withCompletion:(MRSaveCompletionHandler)completion {
    NSArray *operations =
    [[Conversion sourcesAndTargets] compactObjectsUsingBlock:^AFURLConnectionOperation *(NSDictionary *obj, NSUInteger idx) {
        return [[HBTAPIClient sharedAPIClient] liveOperationForSource:obj[@"source"] withCurrencies:obj[@"currencies"]];
    }];
    
    NSArray *requestOperations = [self downloadsForConversions:operations withProgressBlock:progressBlock withCompletion:completion];

    DDLogDebug(@"requests: %@",requestOperations);
    [[self operationQueue] addOperations:requestOperations waitUntilFinished:NO];
}

+ (void)loadAllConversionsWithProgressBlock:(void (^)(NSUInteger, NSUInteger))progressBlock withCompletion:(MRSaveCompletionHandler)completion {
    NSArray *allCurrenciesCodes = [[Currency MR_findAll] valueForKey:@"code"];
    NSArray *operations =
    [allCurrenciesCodes compactObjectsUsingBlock:^AFURLConnectionOperation *(NSString *obj, NSUInteger idx) {
        return [[HBTAPIClient sharedAPIClient] liveOperationForSource:obj withCurrencies:nil];
    }];

    NSArray * requestOperations = [self downloadsForConversions:operations withProgressBlock:progressBlock withCompletion:completion];
    
    [[self operationQueue] addOperations:requestOperations waitUntilFinished:NO];
}

@end
