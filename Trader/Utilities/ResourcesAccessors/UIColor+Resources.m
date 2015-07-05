//
//  UIColor+Resources.m
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import "UIColor+Resources.h"

@implementation UIColor (Resources)

+(UIColor *)colorAs8BitsWithRed:(CGFloat)r greed:(CGFloat)g blue:(CGFloat)b{
    return [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1];
}

+(UIColor *)getViewBackgroundColor {
    return [self colorAs8BitsWithRed:238 greed:238 blue:238];
}

+(UIColor *)getButtonTextColor {
    return [UIColor whiteColor];
}

// #373737 = 3 * 16 + 7 = 48 + 7 = 55
+(UIColor *)getBlackNormalColor {
    return [self colorAs8BitsWithRed:55 greed:55 blue:55];
}

// #595959 = 5 * 16 + 9 = 89
+(UIColor *)getBlackPressedColor {
    return [self colorAs8BitsWithRed:89 greed:89 blue:89];
}

// #dbdbdb = d * 16 + b = 13 * 16 + 11 = 219
+(UIColor *)getButtonGrayNormalColor {
    return [self colorAs8BitsWithRed:219 greed:219 blue:219];
}

// #eeeeee = e * 16 + e = 14 * 16 + 14 = 238
+(UIColor *)getButtonGrayPressedColor {
    return [self colorAs8BitsWithRed:238 greed:238 blue:238];
}

+(UIColor *)getButtonGrayTextColor {
    return [UIColor blackColor];
}

// b4b4b4 = b * 16 + 4 = 11 * 16 + 4 = 180
+(UIColor *)getGrayDisabledColor {
    return [self colorAs8BitsWithRed:180 greed:180 blue:180];
}

// 00aeef = (0, a * 16 + e, e * 16 + f) = (0, 160 + 14, 14 * 16 + 15)
+(UIColor *)getBlueNormalColor {
    return [self colorAs8BitsWithRed:5 greed:175 blue:233];
}

// 45ccff = (4 * 16 + 5, c * 16 + c, ff) = (69, 12 * 17, 255)
+(UIColor *)getBluePressedColor {
    return [self colorAs8BitsWithRed:69 greed:194 blue:255];
}

// keys cells
+(UIColor *)getKeysCellOrangeColor {
    return [self colorAs8BitsWithRed:235 greed:156 blue:54];
}

+(UIColor *)getKeysCellBlueColor {
    return [self colorAs8BitsWithRed:15 greed:166 blue:233];
}

+(UIColor *)getKeysCellRedColor {
    return [self colorAs8BitsWithRed:184 greed:0 blue:15];
}

+(UIColor *)getKeysCellGrayColor {
    return [self colorAs8BitsWithRed:182 greed:182 blue:182];
}

+(UIColor *)getKeysExpirationViewBackgroundColor {
    return [self colorAs8BitsWithRed:232 greed:232 blue:232];
}


@end
