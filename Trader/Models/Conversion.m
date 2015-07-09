//
//  Conversion.m
//  
//
//  Created by Lobanov Dmitry on 05.07.15.
//
//

#import "Conversion.h"
#import "Currency.h"
#import "NSFoundationExtendedMethods.h"

@implementation Conversion

@dynamic added_at;
@dynamic favorited;
@dynamic first_time_quote;
@dynamic quote;
@dynamic timestamp;
@dynamic source;
@dynamic target;

- (void) setTimestampByValue:(NSNumber *)timestamp {
    self.timestamp = timestamp;
}

- (void) setQuoteByValue:(NSNumber *)value {
    if (![self.first_time_quote integerValue]) {
        self.first_time_quote = value;
    }
    else {
        self.quote = value;
    }
}

- (NSNumber *)trend {
    return @(self.quote ? self.quote.floatValue - self.first_time_quote.floatValue : self.first_time_quote.floatValue);
}

- (NSString *)label {
    return [self.source.code stringByAppendingString:self.target.code];
}

+ (NSArray *)distinctSources {
    NSSet * set = [[[self findAllFavorited] valueForKeyPath:@"source.code"] valueForKeyPath:@"@distinctUnionOfObjects.self"];
    return [set allObjects];
}

+ (NSArray *)sourcesAndTargets {
    return
    [[self distinctSources] compactObjectsUsingBlock:^NSDictionary * (NSString *obj, NSUInteger idx) {
        Currency *currency = [Currency MR_findFirstByAttribute:@"code" withValue:obj];
        return
        @{@"source" : obj, @"currencies" : [[currency.currencies valueForKeyPath:@"target.code"] allObjects]};
    }];
}

+ (NSArray *)findAllFavorited {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"favorited == YES"];
    return [self MR_findAllSortedBy:@"added_at" ascending:YES withPredicate:predicate];
}

+ (NSFetchedResultsController *)fetchAllFavorited {
    NSPredicate * predicate = [NSPredicate predicateWithFormat:@"favorited == YES"];
    return [self MR_fetchAllSortedBy:@"added_at" ascending:YES withPredicate:predicate groupBy:nil delegate:nil];
    
}


#pragma mark - Helpers
#pragma mark - Helpers / Fill
- (void)fillWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
//    NSString *source = dictionary[@"source"];
//    NSString *target = dictionary[@"target"];
    NSNumber *timestamp = dictionary[@"timestamp"];
    NSNumber *quote = dictionary[@"quote"];
//    Currency *sourceCurrency = [Currency MR_findFirstByAttribute:@"code" withValue:source inContext:context];
//    Currency *targetCurrency = [Currency MR_findFirstByAttribute:@"code" withValue:target inContext:context];
    Conversion *conversion = self;
    [conversion setQuoteByValue:quote];
    [conversion setTimestampByValue:timestamp];
}

#pragma mark - Helpers / Find
+ (instancetype) findBySource:(NSString *)source andTarget:(NSString *)target {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" source.code  = %@ AND target.code = %@ ", source, target];
    return [self MR_findFirstWithPredicate:predicate];
}

#pragma mark - Helpers / Create
+ (instancetype) updateOrCreateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    NSString *source = dictionary[@"source"];
    NSString *target = dictionary[@"target"];
    
    Conversion *conversion = [self findBySource:source andTarget:target];
    
    if (conversion) {
        [conversion fillWithDictionary:dictionary inContext:context];
    }
    else {
        conversion = [self createWithDictionary:dictionary inContext:context];
    }
    return conversion;
}
+ (instancetype) createWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString *source = dictionary[@"source"];
    NSString *target = dictionary[@"target"];
    
    Currency *sourceCurrency = [Currency MR_findFirstByAttribute:@"code" withValue:source inContext:context];
    Currency *targetCurrency = [Currency MR_findFirstByAttribute:@"code" withValue:target inContext:context];
    Conversion *conversion = nil;
    if (sourceCurrency && targetCurrency) {
        conversion = [self MR_createEntityInContext:context];
        conversion.source = sourceCurrency;
        conversion.target = targetCurrency;
        [conversion fillWithDictionary:dictionary inContext:context];
    }
    return conversion;
}

#pragma mark - Helpers / Save
+ (void) saveWithDictionary:(NSDictionary *)dictionary completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self updateOrCreateWithDictionary:dictionary inContext:localContext];
    } completion:completion];
}

+ (void) saveAllFromDictionaries:(NSArray *)dictionaries completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *conversion in dictionaries) {
            [self updateOrCreateWithDictionary:conversion inContext:localContext];
        }
    } completion:completion];
}

+ (void) remove:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [conversion MR_deleteEntityInContext:localContext];
    } completion:completion];
}

+ (void) remove:(Conversion *)conversion inContext:(NSManagedObjectContext *)context {
    [conversion MR_deleteEntityInContext:context];
}


+ (void) removeAllOld:(NSInteger)timestamp completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp < %@", @(timestamp)];
        [Conversion MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:completion];
}

@end

@implementation Conversion (UserInteraction)

- (void) setFavoritedByValue:(NSNumber *)favorited {
    self.added_at = [favorited boolValue] ? @([[NSDate date] timeIntervalSince1970]) : nil;
    self.favorited = favorited;
}

#pragma mark - Helpers / Delete
+ (void) like:(Conversion *)conversion withValue:(BOOL)favorited completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [conversion setFavoritedByValue:@(favorited)];
    } completion:completion];
}

+ (void) unlike:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion {
    [self like:conversion withValue:NO completion:completion];
}

@end
