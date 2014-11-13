//
//  ViewController.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "ReaderViewController.h"
#import "AppDelegate.h"
#import "CoreData.h"

@interface ReaderViewController () <UITableViewDataSource, UITableViewDelegate>
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfReadersList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *reader = self.arrayOfReadersList[indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [reader valueForKey:@"name"];
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

@end
