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

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation CurrenciesTableViewController

#pragma mark - Helpers 
- (NSPredicate *)searchPredicateWithPrefix:(NSString *)prefix {
    NSPredicate *predicate = nil;
    if ([prefix isVisible]) {
        predicate =
        [NSPredicate predicateWithFormat:@"code beginswith[c] %@ OR name contains[c] %@", prefix, prefix];
    }
    return predicate;
}

#pragma mark - Setup
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.searchBar becomeFirstResponder];
}
#pragma mark - Refreshing
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
    [self.fetchedResultsController performFetch:&error];
    [self.tableView reloadData];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [self.tableView scrollsToTop];
}

#pragma mark - Table view data source


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CurrenciesCell" forIndexPath:indexPath];
    Currency * currency =
    [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = currency.label;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Currency *chosenCurrency = [self.fetchedResultsController objectAtIndexPath:indexPath];
    [self.backDelegate setCurrencyCode:chosenCurrency.code forDesination:self.currencyDestination];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Scroll view delegate
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.searchBar resignFirstResponder];
}

@end
