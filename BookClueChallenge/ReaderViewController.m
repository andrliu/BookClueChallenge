//
//  ViewController.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "ReaderViewController.h"
#import "DetailViewController.h"
#import "AppDelegate.h"
#import "CoreData.h"
#import "Friend.h"

@interface ReaderViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *readerTableView;
@property (nonatomic, strong) NSMutableArray *arrayOfReadersList;
@property NSManagedObjectContext *moc;

@end

@implementation ReaderViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self openingAlert];
    
    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    self.arrayOfReadersList = [coreDataManager filterReadersList];

    [self.readerTableView reloadData];
}

- (IBAction)sortOnButtonPressed:(UIBarButtonItem *)sender
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    self.arrayOfReadersList = [coreDataManager filterReadersListByRecommendedBooks];

    [self.readerTableView reloadData];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    if (searchText.length == 0)
    {
        self.arrayOfReadersList = [coreDataManager filterReadersList];
    }
    else
    {
        self.arrayOfReadersList = [coreDataManager filterReadersListByName:searchText];
    }

    [self.readerTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfReadersList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Friend *reader = self.arrayOfReadersList[indexPath.row];
    cell.textLabel.text = reader.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Books count: %ld", reader.books.count];
    return cell;
}

- (void)openingAlert
{
    UIAlertController *openingAlert = [UIAlertController alertControllerWithTitle:@"First Rule"
                                                                             message:@"You do not talk about book club"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *agreeAction = [UIAlertAction actionWithTitle:@"Agree"
                                                          style:UIAlertActionStyleCancel
                                                        handler:nil];
    [openingAlert addAction:agreeAction];
    [self presentViewController:openingAlert animated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueFromReaderToDetail"])
    {
        DetailViewController *dvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.readerTableView indexPathForCell:sender];
        Friend *reader = self.arrayOfReadersList[indexPath.row];
        dvc.reader = reader;
    }
}

@end
