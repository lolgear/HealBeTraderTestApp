//
//  UIColor+Resources.h
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Resources)

+(UIColor *)getViewBackgroundColor;

+(UIColor *)getBlackNormalColor;
+(UIColor *)getBlackPressedColor;

+(UIColor *)getButtonGrayNormalColor;
+(UIColor *)getButtonGrayPressedColor;
+(UIColor *)getButtonGrayTextColor;

+(UIColor *)getGrayDisabledColor;

+(UIColor *)getBlueNormalColor;
+(UIColor *)getBluePressedColor;

+(UIColor *)getButtonTextColor;

// keys cells
+(UIColor *)getKeysCellOrangeColor;
+(UIColor *)getKeysCellBlueColor;
+(UIColor *)getKeysCellRedColor;
+(UIColor *)getKeysCellGrayColor;
+(UIColor *)getKeysExpirationViewBackgroundColor;

@end
