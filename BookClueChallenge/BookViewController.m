//
//  BookViewController.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/14/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "BookViewController.h"
#import "AppDelegate.h"
#import "CoreData.h"

@interface BookViewController ()

@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *authorTextField;
@property NSManagedObjectContext *moc;

@end

@implementation BookViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    AppDelegate *delegate = [[UIApplication sharedApplication]delegate];
    self.moc = delegate.managedObjectContext;
}

- (IBAction)dismissOnButtonPressed:(UIButton *)sender
{
    NSString *titleString = self.titleTextField.text;
    NSString *authorString = self.authorTextField.text;

    CoreData *coreDataManager = [[CoreData alloc]initWithMOC:self.moc];
    [coreDataManager storeBooksByTitleString:titleString
                             byAuthorString:authorString
                                 wtihReader:self.reader];

    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
