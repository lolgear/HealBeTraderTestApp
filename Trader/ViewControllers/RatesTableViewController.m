//
//  RatesTableViewController.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "RatesTableViewController.h"
#import <MagicalRecord/MagicalRecord.h>
#import "HBTDatabaseManager.h"
#import "Conversion.h"
#import "HBTAPIClient.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

static DDLogLevel ddLogLevel = DDLogLevelDebug;

@interface RatesTableViewController ()<NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) NSFetchedResultsController * fetchedResultsController;
@end

@implementation RatesTableViewController

#pragma mark - Fetched Results Controller

- (NSPredicate *)predicateForFetchedResultsController {
    return nil;
}

- (NSFetchedResultsController *)createFetchedResultsController {
    return [Conversion MR_fetchAllGroupedBy:nil withPredicate:nil sortedBy:@"added_at" ascending:YES];
}

#pragma mark - Refresh
- (void)refresh:(id)sender {
    // update data here
    DDLogDebug(@"%@",[Conversion sourcesAndTargets]);
    [HBTDatabaseManager loadConversions:^(BOOL contextDidSave, NSError *error) {
        if (!error) {
        }
        else {
            [self showNotificationError:error.localizedDescription];
        }
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
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    // Configure the cell...
    Conversion * conversion =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = conversion.label;
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
        [HBTDatabaseManager deleteConversion:conversion completion:^(BOOL contextDidSave, NSError *error) {
            if (!error) {
            }
            else {
                [self showNotificationError:error.localizedDescription];
            }
        }];
    }
}

#pragma mark - Fetched Results Controller
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
