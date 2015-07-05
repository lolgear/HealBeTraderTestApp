//
//  CurrenciesTableViewController.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "CurrenciesTableViewController.h"
#import "HBTAPIClient.h"
#import "HBTDatabaseManager.h"
#import "NSFoundationExtendedMethods.h"
#import "Currency.h"
#import "AddConversionViewController.h"

@interface CurrenciesTableViewController () <UISearchBarDelegate>
@property (strong, nonatomic) Currency *chosenCurrency;
@end

@implementation CurrenciesTableViewController

#pragma mark - Helpers 
- (NSPredicate *)searchPredicateWithPrefix:(NSString *)prefix {
    NSPredicate *predicate = nil;
    if ([prefix isVisible]) {
        predicate =
        [NSPredicate predicateWithFormat:@"code beginswith %@", prefix];
    }
    return predicate;
}

- (void)refresh:(id)sender {
    [sender endRefreshing];
//    [[HBTAPIClient sharedAPIClient] allCurrenciesWithSuccessBlock:^(id responseObject) {
//        // do something here
//        __block NSDictionary *responseDictionary = (NSDictionary *)responseObject;
//        NSArray *currencies =
//        [[responseDictionary allKeys] mapObjectsUsingBlock:^NSDictionary *(NSString *obj, NSUInteger idx) {
//            return @{@"code":obj, @"name":responseDictionary[obj]};
//        }];
//        [HBTDatabaseManager saveCurrencies:currencies completion:^(BOOL contextDidSave, NSError *error) {
//            if (!error) {
//                [self.tableView reloadData];
//            }
//            else {
//                [self showNotificationError:error.localizedDescription];
//            }
//            [sender endRefreshing];
//        }];
//    } errorBlock:^(NSError *error, NSString *errorDescription) {
//        [self showNotificationError:errorDescription];
//        [sender endRefreshing];
//    }];
}

- (NSFetchedResultsController *)createFetchedResultsController {
    return [Currency MR_fetchAllSortedBy:@"code" ascending:YES withPredicate:nil groupBy:nil delegate:self];
}

#pragma mark - Search Bar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    // we should change predicate for
    NSError *error;
    
    [[self.fetchedResultsController fetchRequest] setPredicate:[self searchPredicateWithPrefix:searchText]];
    [NSFetchedResultsController deleteCacheWithName:@"Root"];
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrenciesCell" forIndexPath:indexPath];
    Currency * currency =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = currency.code;
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Currency *chosenCurrency = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.backDelegate setCurrencyCode:chosenCurrency.code forDesination:self.currencyDestination];
    [self.navigationController popViewControllerAnimated:YES];
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


@end
