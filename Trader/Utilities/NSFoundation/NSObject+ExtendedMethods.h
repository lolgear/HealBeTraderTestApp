//
//  NSObject+NSObject_ExtendedMethods.h
//  Buro 247
//
//  Created by Lobanov Dmitry on 09.07.14.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (ExtendedMethods)

- (NSString *)jsonValue;

+ (NSString *)jsonValueFromObject:(NSObject *)object;


- (instancetype)weakSelf;

- (BOOL)isNotNull;

+ (BOOL)isObjectNotNull:(NSObject*)object;
+ (BOOL)isObjectNull:(NSObject*)object;

@end
