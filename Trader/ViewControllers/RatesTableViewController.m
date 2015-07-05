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


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
