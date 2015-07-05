//
//  AIKCustomStoryboardAccessor.m
//  Airkey
//
//  Created by Lobanov Dmitry on 26.05.15.
//  Copyright (c) 2015 AirkeyTeam. All rights reserved.
//

#import "AIKCustomStoryboardAccessor.h"

static UIStoryboard *staticMainStoryboard = nil;

@implementation AIKCustomStoryboardAccessor

+ (UIStoryboard *)mainStoryboard {

    if (!staticMainStoryboard){
        staticMainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    }

    return staticMainStoryboard;
}

+ (UIViewController *)controllerWithStoryboardId:(NSString *)storyboardId {
    UIViewController *controller = [[self mainStoryboard] instantiateViewControllerWithIdentifier:storyboardId];
    return controller;
}


@end
