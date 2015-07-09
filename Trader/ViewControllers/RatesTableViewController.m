//
//  RatesTableViewController.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "RatesTableViewController.h"
#import "RatesTableViewCell.h"
#import "Conversion.h"
#import "HBTAPIClient.h"
#import "HBTDatabaseManager.h"
#import "DatabaseValidation.h"
#import <MagicalRecord/MagicalRecord.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

static DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface RatesTableViewController ()<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) MBProgressHUD *progressHud;
@property (strong, nonatomic) UIProgressView *progressView;
@property (nonatomic, readonly) BOOL actionsAvailable;
@end

@implementation RatesTableViewController

#pragma mark - Availability
- (void) updateActions {
    self.navigationItem.rightBarButtonItem.enabled = self.actionsAvailable;
}
- (BOOL) actionsAvailable {
    return [[DatabaseValidation sharedStorage] firstTimeLoaded];
}

#pragma mark - Progress View
- (UIProgressView *)progressView {
    if (!_progressView) {
        UIProgressView *progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        CGRect rect = progressView.frame;
        rect.size.width = self.view.frame.size.width;
        progressView.frame = rect;
        _progressView = progressView;
    }
    return _progressView;
}

- (void) showProgressView {
    [self.view addSubview:self.progressView];
}

- (void) updateProgress:(CGFloat)progress {
    self.progressView.progress = progress;
}

- (void) hideProgressView {
    self.progressView.progress = 0.0f;
    [self.progressView removeFromSuperview];
}

#pragma mark - Progress Hud

- (void) showProgressHudInCenter {
    [self showProgressHud];
    self.progressHud.yOffset = (-1) * (self.navigationController.navigationBar.frame.size.height + + 20);
}

- (void) updateHudProgress:(CGFloat)progress {
    self.progressHud.progress = progress;
}

- (MBProgressHUD *)progressHud {
    return [MBProgressHUD HUDForView:self.view];
}

#pragma mark - View Lifecycle
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self checkDatabaseConsistenty];
}

#pragma mark - Data Consistenty
- (void) checkDatabaseConsistenty {
    [self updateActions];
    if (![[DatabaseValidation sharedStorage] firstTimeLoaded]) {
        [self showProgressHudInCenter];
        [HBTDatabaseManager loadCurrencies:^(BOOL contextDidSave, NSError *error) {
            if (error) {
                [self showNotificationError:error.localizedDescription];
                [self hideProgressHud];
            }
            else {
                self.progressHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
                [HBTDatabaseManager loadAllConversionsWithProgressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
                    CGFloat progress = numberOfFinishedOperations * 1.0f / totalNumberOfOperations;
                    [self updateHudProgress:progress];
                    
                } withCompletion:^(BOOL contextDidSave, NSError *error) {
                    if (!error) {
                        [DatabaseValidation sharedStorage].firstTimeLoaded = YES;
                        [self updateActions];
                    }
                    else {
                        [self showNotificationError:error.localizedDescription];
                    }
                    
                    [self hideProgressHud];
                }];
            }
        }];
    }
}

#pragma mark - Fetched Results Controller

- (NSPredicate *)predicateForFetchedResultsController {
    return nil;
}

- (NSFetchedResultsController *)createFetchedResultsController {
    return [Conversion fetchAllFavorited];
}

#pragma mark - Refresh
- (void)refresh:(id)sender {
//    if (!self.actionsAvailable) {
//        [sender endRefreshing];
//        return;
//    }
    // update data here
    [self showProgressHudInCenter];
    self.progressHud.mode = MBProgressHUDModeDeterminateHorizontalBar;
    DDLogDebug(@"%@",[Conversion sourcesAndTargets]);
    [HBTDatabaseManager loadFavoritedConversionsWithProgressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        CGFloat progress = ((numberOfFinishedOperations) * 1.0f) / totalNumberOfOperations;
        [self updateHudProgress:progress];
    } withCompletion:^(BOOL contextDidSave, NSError *error) {
        if (!error) {
        }
        else {

            [self showNotificationError:error.localizedDescription];
        }
        
        [self hideProgressHud];
        [sender endRefreshing];
    }];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    // configure cell;
    Conversion * conversion = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = conversion.label;
}

#pragma mark - Table view data source

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RatesCell" forIndexPath:indexPath];
//    UITableViewCell *cell = [[UITableViewCell alloc] init];
    // Configure the cell...
    Conversion * conversion =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = conversion.label;
    [((RatesTableViewCell *)cell) setTrend:conversion.trend andQuote:conversion.quote];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        Conversion *conversion =
        [self.fetchedResultsController objectAtIndexPath:indexPath];
        [Conversion unlike:conversion completion:^(BOOL contextDidSave, NSError *error) {
            if (!error) {
            }
            else {
                [self showNotificationError:error.localizedDescription];
            }
        }];
    }
}

#pragma mark - Fetched Results Controller Delegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
