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
@dynamic quote;
@dynamic timestamp;
@dynamic source;
@dynamic target;

- (void) fetchedAt:(NSInteger)timestamp {
    self.timestamp = @(timestamp);
}

- (NSString *)label {
    return [self.source.code stringByAppendingString:self.target.code];
}

+ (NSArray *)distinctSources {
    NSSet * set = [[[self MR_findAll] valueForKeyPath:@"source.code"] valueForKeyPath:@"@distinctUnionOfObjects.self"];
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

#pragma mark - Helpers
#pragma mark - Helpers / Find
+ (instancetype)findBySource:(NSString *)source andTarget:(NSString *)target {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@" source.code  = %@ AND target.code = %@ ", source, target];
    return [self MR_findFirstWithPredicate:predicate];
}

#pragma mark - Helpers / Create
+ (void) createWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *source = dictionary[@"source"];
    NSString *target = dictionary[@"target"];
    NSNumber *timestamp = dictionary[@"timestamp"];
    NSNumber *quote = dictionary[@"quote"];
    NSNumber *added_at = nil;
    
    Currency *sourceCurrency = [Currency MR_findFirstByAttribute:@"code" withValue:source inContext:context];
    Currency *targetCurrency = [Currency MR_findFirstByAttribute:@"code" withValue:target inContext:context];
    
    if (!added_at) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"source.code = %@ AND target.code = %@", source, target];
        Conversion *conversion = [self MR_findFirstWithPredicate:predicate inContext:context];
        if (conversion) {
            added_at = conversion.added_at;
        }
    }
    
    if (!added_at) {
        added_at = dictionary[@"added_at"];
    }
    
    if (sourceCurrency && targetCurrency && added_at) {
        
        Conversion *conversion = [self MR_createEntityInContext:context];
        conversion.source = sourceCurrency;
        conversion.target = targetCurrency;
        conversion.quote = quote;
        conversion.added_at = added_at;
        [conversion fetchedAt:timestamp.integerValue];
    }
}

#pragma mark - Helpers / Save
+ (void) saveWithDictionary:(NSDictionary *)dictionary completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self createWithDictionary:dictionary inContext:localContext];
    } completion:completion];
}

+ (void) saveAllFromDictionaries:(NSArray *)dictionaries completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *conversion in dictionaries) {
            [self createWithDictionary:conversion inContext:localContext];
        }
    } completion:completion];
}


#pragma mark - Helpers / Delete
+ (void) remove:(Conversion *)conversion completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [conversion MR_deleteEntityInContext:localContext];
    } completion:completion];
}

+ (void) removeAllOld:(NSInteger)timestamp completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"timestamp < %@", @(timestamp)];
        [Conversion MR_deleteAllMatchingPredicate:predicate inContext:localContext];
    } completion:completion];
}


@end
