//
//  CommentViewController.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/14/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "CommentViewController.h"
#import "AppDelegate.h"
#import "Comment.h"
#import "CoreData.h"

@interface CommentViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (nonatomic, strong) NSMutableArray *arrayOfCommentsList;
@property NSManagedObjectContext *moc;

@end

@implementation CommentViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.arrayOfCommentsList = [[self.book.comments allObjects] mutableCopy];

    [self.commentTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfCommentsList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Comment *comment = self.arrayOfCommentsList[indexPath.row];
    cell.textLabel.text = comment.text;
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    [coreDataManager removeCommentsInCoreDataWithArray:self.arrayOfCommentsList forRowAtIndexPath:indexPath];

    [self.commentTableView reloadData];
}

- (IBAction)AddCommentOnButtonPressed:(UIBarButtonItem *)sender
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Add a comment"
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];

    [alert addTextFieldWithConfigurationHandler:^(UITextField *textField)
    {
        textField.placeholder = @"Text";
    }];

    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                           style:UIAlertActionStyleCancel
                                                         handler:nil];
    [alert addAction:cancelAction];

    UIAlertAction *addAction = [UIAlertAction actionWithTitle:@"Add"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action)
                                {
                                    UITextField *textFieldForText = alert.textFields.firstObject;

                                    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
                                    [coreDataManager storeCommentsByTextString:textFieldForText.text
                                                                      wtihBook:self.book];
                                    
                                    [self.commentTableView reloadData];
                                }];
    [alert addAction:addAction];

    [self presentViewController:alert animated:YES completion:nil];
}

@end
