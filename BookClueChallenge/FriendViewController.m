
//
//  FriendViewController.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#define kJsonAPI @"http://s3.amazonaws.com/mobile-makers-assets/app/public/ckeditor_assets/attachments/18/friends.json"

#import "FriendViewController.h"
#import "AppDelegate.h"
#import "Friend.h"
#import "CoreData.h"

@interface FriendViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *friendTableView;
@property (nonatomic, strong) NSMutableArray *arrayOfFriendsList;
@property NSManagedObjectContext *moc;

@end

@implementation FriendViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;

    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    self.arrayOfFriendsList = [coreDataManager retrieveFriendsList];

    if (self.arrayOfFriendsList.count == 0)
    {   
        [Friend retrieveFriendsListFromJsonAPI:kJsonAPI withCompletion:^(NSMutableArray *arrayOfFriendsList, NSError *connectionError) {
            if (!connectionError)
            {
                self.arrayOfFriendsList = arrayOfFriendsList;
                [coreDataManager storeFriendsListByArray:self.arrayOfFriendsList];
                self.arrayOfFriendsList = [coreDataManager retrieveFriendsList];
                [self.friendTableView reloadData];
            }
            else
            {
                [self Error:connectionError];
            }
        }];
    }

    [self.friendTableView reloadData];
}


- (void)Error:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK"
                                                     style:UIAlertActionStyleDefault
                                                   handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    [coreDataManager updateReadersListByArray:self.arrayOfFriendsList atIndexPath:indexPath];

    [self.friendTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfFriendsList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Friend *friend = self.arrayOfFriendsList[indexPath.row];
    cell.textLabel.text = friend.name;
    if ([friend.isReader boolValue])
    {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}




@end
