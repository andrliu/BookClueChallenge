//
//  DetailViewController.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/13/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "DetailViewController.h"
#import "BookViewController.h"
#import "CommentViewController.h"
#import "AppDelegate.h"
#import "CoreData.h"
#import "Book.h"

@interface DetailViewController () <UITableViewDataSource, UITableViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *detailTableView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (nonatomic, strong) NSMutableArray *arrayOfBooksList;
@property NSManagedObjectContext *moc;


@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    self.nameLabel.text = self.reader.name;

    UIImage *profilePhoto = [[UIImage alloc]initWithData:self.reader.photo];
    self.photoImageView.image = profilePhoto;

    self.arrayOfBooksList = [[self.reader.books allObjects] mutableCopy];

    [self.detailTableView reloadData];
}

- (IBAction)addPhotoOnButtonPressed:(UIButton *)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *pickerImage = info[UIImagePickerControllerEditedImage];
    NSData *profileImageData = UIImagePNGRepresentation(pickerImage);
    self.reader.photo = profileImageData;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayOfBooksList.count;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    [coreDataManager removeBooksInCoreDataWithArray:self.arrayOfBooksList forRowAtIndexPath:indexPath];

    [self.detailTableView reloadData];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Book *book = self.arrayOfBooksList[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Title: %@", book.title];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Author: %@", book.author];
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"segueFromBookToComment"])
    {
        CommentViewController *cvc = segue.destinationViewController;
        NSIndexPath *indexPath = [self.detailTableView indexPathForCell:sender];
        Book *book = self.arrayOfBooksList[indexPath.row];
        cvc.book = book;
    }
    else
    {
        BookViewController *bvc = segue.destinationViewController;
        bvc.reader = self.reader;
    }
}

@end
