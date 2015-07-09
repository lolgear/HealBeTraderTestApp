//
//  DatabaseValidation.m
//  Trader
//
//  Created by Lobanov Dmitry on 09.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "DatabaseValidation.h"

static NSString * staticFirstTimeLoadedString = @"firstTimeLoadedString";

@implementation DatabaseValidation

+ (instancetype)sharedStorage {
    static id sharedStorage = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStorage = [self new];
    });
    
    return sharedStorage;
}

- (NSUserDefaults *)defaults {
    return [NSUserDefaults standardUserDefaults];
}

- (BOOL)firstTimeLoaded {
    return [[self defaults] boolForKey:staticFirstTimeLoadedString];
}

- (void)setFirstTimeLoaded:(BOOL)firstTimeLoaded {
    [[self defaults] setBool:firstTimeLoaded forKey:staticFirstTimeLoadedString];
    [[self defaults] synchronize];
}

@end
