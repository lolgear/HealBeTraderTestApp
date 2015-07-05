//
//  AIKCustomStoryboardAccessor.h
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AIKCustomStoryboardAccessor : NSObject

+ (UIViewController *)controllerWithStoryboardId:(NSString *)storyboardId;

@end
