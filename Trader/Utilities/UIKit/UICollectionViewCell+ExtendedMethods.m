//
//  UICollectionViewCell+ExtendedMethods.m
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import "UICollectionViewCell+ExtendedMethods.h"

@implementation UICollectionViewCell (ExtendedMethods)
+ (UINib *)nib {
    return [UINib nibWithNibName:[self defaultNibName] bundle:nil];
}

+ (NSString *)defaultNibName {
    return NSStringFromClass([self class]);
}

+ (NSString *)cellReuseIdentifier {
    return NSStringFromClass([self class]);
}
@end
