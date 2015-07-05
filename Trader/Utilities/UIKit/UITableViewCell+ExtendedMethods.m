//
//  UITableViewCell+ExtendedMethods.m
//  Airkey
//
//  Created by Lobanov Dmitry on 31.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import "UITableViewCell+ExtendedMethods.h"

@implementation UITableViewCell (ExtendedMethods)

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
