//
//  UIButton+ExtendedMethods.h
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//
//

#import <UIKit/UIKit.h>
@interface UIButton (ExtendedMethods)

- (void) setAttributedTitleForAllStates:(NSAttributedString *)title;

- (void) setTitleForAllStates:(NSString*)title;

- (void) setTitleColorForAllStates:(UIColor*)color;

- (void) setImageForAllStates:(UIImage*)image;

@end
