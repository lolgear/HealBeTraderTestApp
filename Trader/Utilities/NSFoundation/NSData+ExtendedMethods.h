//
//  NSData+ExtendedMethods.h
//  Buro 247
//
//  Created by Dmitry Lobanov on 12.12.14.
//
//

#import <Foundation/Foundation.h>
#import "NSObject+ExtendedMethods.h"

@interface NSData (ExtendedMethods)
#pragma mark - JSON Serialization
- (NSObject *)jsonObject;
+ (NSObject *)jsonObjectFromData:(NSData *)data;

#pragma mark - Class Jumping
// thanks for answer: http://stackoverflow.com/questions/1305225/best-way-to-serialize-a-nsdata-into-an-hexadeximal-string
+ (NSString *)hexadecimalStringFromData:(NSData *)data;
- (NSString *)hexadecimalString;

@end
