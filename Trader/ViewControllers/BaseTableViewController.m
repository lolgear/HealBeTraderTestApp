//
//  BaseTableViewController.m
//  Trader
//
//  Created by Lobanov Dmitry on 04.07.15.
//  Copyright (c) 2015 HealBeTeam. All rights reserved.
//

#import "BaseTableViewController.h"

@interface BaseTableViewController ()
@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@end

@implementation BaseTableViewController

#pragma mark - View Lifecycle
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupUIElements];
}

#pragma mark - Setup
- (void)setupUIElements {
    if (!self.refreshControl) {
        UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:refreshControl];
        self.refreshControl = refreshControl;
    }
}

#pragma mark - Refresh
- (void)refresh:(id)sender {
    // update data here
}

#pragma mark - Fetched Results Controller
- (NSFetchedResultsController *)createFetchedResultsController {
    return nil;
}

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        _fetchedResultsController = [self createFetchedResultsController];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

#pragma mark - Delegates
#pragma mark - Delegates / NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

#pragma mark - Delegates / UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return self.fetchedResultsController.fetchedObjects.count;
}

@end
