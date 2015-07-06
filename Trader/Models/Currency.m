//
//  Currency.m
//  
//
//  Created by Lobanov Dmitry on 05.07.15.
//
//

#import "Currency.h"
#import "Conversion.h"


@implementation Currency

@dynamic code;
@dynamic name;
@dynamic currencies;

- (NSString *)label {
    return
    [[self.code stringByAppendingString:@" - "] stringByAppendingString:self.name];
}

@end
