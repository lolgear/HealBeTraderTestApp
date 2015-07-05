//
//  UIButton+ExtendedMethods.h
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//
//

#import "UIButton+ExtendedMethods.h"

@implementation UIButton (ExtendedMethods)

- (void) setAttributedTitleForAllStates:(NSAttributedString *)title {
    [self setAttributedTitle:title forState:UIControlStateNormal];
    [self setAttributedTitle:title forState:UIControlStateSelected];
    [self setAttributedTitle:title forState:UIControlStateHighlighted];

}

- (void) setTitleForAllStates:(NSString*)title {
    [self setTitle:title forState:UIControlStateNormal];
    [self setTitle:title forState:UIControlStateSelected];
    [self setTitle:title forState:UIControlStateHighlighted];
}

- (void) setTitleColorForAllStates:(UIColor*)color {
    [self setTitleColor:color forState:UIControlStateNormal];
    [self setTitleColor:color forState:UIControlStateSelected];
    [self setTitleColor:color forState:UIControlStateHighlighted];
}

- (void) setImageForAllStates:(UIImage*)image {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:image forState:UIControlStateSelected];
    [self setImage:image forState:UIControlStateHighlighted];
}

@end

