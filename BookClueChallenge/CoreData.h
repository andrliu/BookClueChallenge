//
//  CoreData.h
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

@interface CoreData : NSObject
@property NSManagedObjectContext *moc;

- (instancetype)initWithMOC:(NSManagedObjectContext*)moc;

- (NSMutableArray *)retrieveFriendsList;

- (NSMutableArray *)filterReadersList;

- (void)storeFriendsListByArray:(NSMutableArray *)arrayOfFriendsList;

- (void)updateReadersListByArray:(NSMutableArray *)arrayOfReadersList atIndexPath:(NSIndexPath *)indexPath;

@end
