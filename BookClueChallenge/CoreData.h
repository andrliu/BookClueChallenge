//
//  CoreData.h
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "Friend.h"
#import "Book.h"
#import "Comment.h" 

@interface CoreData : NSObject

@property NSManagedObjectContext *moc;

- (instancetype)initWithMOC:(NSManagedObjectContext*)moc;

- (NSMutableArray *)retrieveFriendsList;

- (NSMutableArray *)filterReadersList;

- (NSMutableArray *)filterReadersListByName:(NSString *)readerName;

- (NSMutableArray *)filterReadersListByRecommendedBooks;

- (void)removeBooksInCoreDataWithArray:(NSMutableArray *)arrayOfBooksList forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)removeCommentsInCoreDataWithArray:(NSMutableArray *)arrayOfCommentsList forRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)storeFriendsListByArray:(NSMutableArray *)arrayOfFriendsList;

- (void)updateReadersListByArray:(NSMutableArray *)arrayOfReadersList atIndexPath:(NSIndexPath *)indexPath;

- (void)storeBooksByTitleString:(NSString *)titleString byAuthorString:(NSString *)authorString wtihReader:(Friend *)reader;

- (void)storeCommentsByTextString:(NSString *)textString wtihBook:(Book *)book;

@end
