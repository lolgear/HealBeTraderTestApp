//
//  Currency.m
//  
//
//  Created by Lobanov Dmitry on 05.07.15.
//
//

#import "Currency.h"
#import "Conversion.h"
#import "NSFoundationExtendedMethods.h"

@implementation Currency

@dynamic code;
@dynamic name;
@dynamic currencies;

- (NSString *)label {
    return self.code;
}


#pragma mark - Helpers
#pragma mark - Helpers / Create
+ (void)findOrCreateWithDictionary:(NSDictionary *)dictionary inContext:(NSManagedObjectContext *)context {
    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *code = dictionary[@"code"];
    NSString *name = dictionary[@"name"];
    Currency *currency = [self MR_findFirstByAttribute:@"code" withValue:code inContext:context];
    
    if (currency) {
        return;
    }
    
    currency = [self MR_createEntityInContext:context];
    currency.code = code;
    
    if ([name isNotNull]) {
        currency.name = name;
    }
}

#pragma mark - Helpers / Save
+ (void)saveWithDictionary:(NSDictionary *)dictionary completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        [self findOrCreateWithDictionary:dictionary inContext:localContext];
    } completion:completion];
}

+ (void)saveAllFromDictionaries:(NSArray *)dictionaries completion:(MRSaveCompletionHandler)completion {
    [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
        for (NSDictionary *currency in dictionaries) {
            [self findOrCreateWithDictionary:currency inContext:localContext];
        }
    } completion:completion];
}



@end
