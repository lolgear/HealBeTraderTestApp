//
//  UITableViewCell+ExtendedMethods.h
//  Airkey
//
//  Created by Lobanov Dmitry on 31.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (ExtendedMethods)

/**
 *  Returns the `UINib` object initialized for the cell.
 *
 *  @return The initialized `UINib` object or `nil` if there were errors during
 *  initialization or the nib file could not be located.
 */
+ (UINib *)nib;

+ (NSString *)defaultNibName;

/**
 *  Returns the default string used to identify a reusable cell.
 *
 *  @return The string used to identify a reusable cell.
 */
+ (NSString *)cellReuseIdentifier;



@end
