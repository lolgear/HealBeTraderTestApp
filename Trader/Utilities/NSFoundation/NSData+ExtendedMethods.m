//
//  NSData+ExtendedMethods.m
//  Buro 247
//
//  Created by Dmitry Lobanov on 12.12.14.
//
//

#import <Foundation/Foundation.h>

@implementation NSData (ExtendedMethods)

- (NSObject *)jsonObject{
    return [self.class jsonObjectFromData:self];
}

+ (NSObject *)jsonObjectFromData:(NSData *)data{
    
    NSObject *jsonObject = nil;
    NSError *error = nil;
    
    if (data) {
        jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                 options:NSJSONReadingAllowFragments
                                                   error:&error];
    }
    
    return error ? nil : jsonObject;
}

+ (NSString *)hexadecimalStringFromData:(NSData *)data{
    /* Returns hexadecimal string of NSData. Empty string if data is empty.   */
    
    const unsigned char *dataBuffer = (const unsigned char *)[data bytes];
    
    if (!dataBuffer)
        return [NSString string];
    
    NSUInteger          dataLength  = [data length];
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    
    for (int i = 0; i < dataLength; ++i)
        [hexString appendString:[NSString stringWithFormat:@"%02lx", (unsigned long)dataBuffer[i]]];
    
    return [NSString stringWithString:hexString];
}

- (NSString *)hexadecimalString{
    return [self.class hexadecimalStringFromData:self];
}

@end
