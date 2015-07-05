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

@end
