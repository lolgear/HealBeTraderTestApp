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
#import "DatabaseValidation.h"

static DDLogLevel ddLogLevel = DDLogLevelDebug;
static NSTimeInterval timerRepeatInterval = 20;
@interface AppDelegate ()
@property (strong, nonatomic) NSTimer *timer;
@end

@implementation AppDelegate

#pragma mark - Setup
- (void) setupLoggers {
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
}

- (void) setupDatabase {
    [MagicalRecord setupAutoMigratingCoreDataStack];
}

- (void) setupBackgroundFetch {
    [[UIApplication sharedApplication]
     setMinimumBackgroundFetchInterval:
     // put any time interval, heh
     UIApplicationBackgroundFetchIntervalMinimum];
}

#pragma mark - Data Refresh
- (void)tearDownTimer {
    DDLogDebug(@"I tear down timer: %@", self.timer);
    [self.timer invalidate];
    self.timer = nil;
}
- (void)setupTimer {
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timerRepeatInterval target:self selector:@selector(refreshData) userInfo:nil repeats:YES];
    DDLogDebug(@"I setup timer: %@", self.timer);
}

- (void)refreshData {
    if (![[DatabaseValidation sharedStorage] firstTimeLoaded]) {
        return;
    }
    
    [HBTDatabaseManager loadFavoritedConversionsWithProgressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
    } withCompletion:^(BOOL contextDidSave, NSError *error) {
        if (!error) {
        }
        else {
            DDLogDebug(@"error is %@", error);
        }
    }];
}

#pragma mark - Delegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self setupLoggers];
    [self setupDatabase];
    [self setupBackgroundFetch];
    // Override point for customization after application launch.
    return YES;
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler {

    [HBTDatabaseManager loadFavoritedConversionsWithProgressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        
    } withCompletion:^(BOOL contextDidSave, NSError *error) {
        UIBackgroundFetchResult fetchResult = error == nil ? UIBackgroundFetchResultNewData : UIBackgroundFetchResultFailed;
        DDLogDebug(@"fetchedResult: %@", @(fetchResult) );
        completionHandler(fetchResult);
    }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [self tearDownTimer];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [self tearDownTimer];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [self setupTimer];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self setupTimer];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [self tearDownTimer];
    [MagicalRecord cleanUp];
}


@end
