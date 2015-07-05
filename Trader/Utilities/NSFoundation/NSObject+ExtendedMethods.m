//
//  NSObject+NSObject_ExtendedMethods.m
//  Buro 247
//
//  Created by Lobanov Dmitry on 09.07.14.
//
//

#import "NSObject+ExtendedMethods.h"

@implementation NSObject (ExtendedMethods)


- (NSString*)jsonValue{
    return [self.class jsonValueFromObject:self];
}

+ (NSString *)jsonValueFromObject:(NSObject *)object{
    
    NSError* error = [[NSError alloc] init];
    NSData *jsonData = nil;
    
    if (object) {
        jsonData = [NSJSONSerialization dataWithJSONObject:object options:NSJSONWritingPrettyPrinted error:&error];
    }
    
    NSString *jsonString = nil;
    
    if (error.code == 0) {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }

    return jsonString;
}


- (instancetype)weakSelf{
    __weak typeof(self) item = self;
    return item;
}

- (BOOL)isNotNull{
    return [self.class isObjectNotNull:self];
}

+ (BOOL)isObjectNotNull:(NSObject*)object{
    return ![self isObjectNull:object];
}

+ (BOOL)isObjectNull:(NSObject*)object
{
    return (!object) || ([[NSNull null] isEqual:object]);
}

@end
