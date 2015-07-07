//
//  AppDelegate.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "AppDelegate.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MagicalRecord/MagicalRecord.h>
#import "HBTDatabaseManager.h"

static DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void) setupLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void) setupBackgroundFetch {
    [[UIApplication sharedApplication]
     setMinimumBackgroundFetchInterval:
     // put any time interval, heh
     UIApplicationBackgroundFetchIntervalMinimum];
}

- (void) setupDatabase {
    [MagicalRecord setupAutoMigratingCoreDataStack];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupLoggers];
    [self setupDatabase];
    [self setupBackgroundFetch];
    // Override point for customization after application launch.
    [HBTDatabaseManager loadCurrencies:^(BOOL contextDidSave, NSError *error) {
        if (error) {
            // do something
            DDLogDebug(@"error: %@", error);
        }
        else {
//            [HBTDatabaseManager loadFirstTimeConversionsWithProgressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
//                DDLogDebug(@"%@ load %@ / %@", self, @(numberOfFinishedOperations), @(totalNumberOfOperations));
//            } withCompletion:^(BOOL contextDidSave, NSError *error) {
//                if (!error) {
//                    // ok
//                    DDLogDebug(@"save first time conversions well: %@", self);
//                }
//                else {
//                    DDLogDebug(@"%@ has error: %@", self, error);
//                }
//            }];
        }
    }];
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {
    
//    [HBTDatabaseManager loadConversions:^(BOOL contextDidSave, NSError *error) {
//        
//        UIBackgroundFetchResult fetchResult = error == nil ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultFailed;
//        DDLogDebug(@"fetchedResult: %@", @(fetchResult) );
//        completionHandler(fetchResult);
//    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}


@end
