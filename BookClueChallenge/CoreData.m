//
//  CoreData.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "CoreData.h"

@implementation CoreData

- (instancetype)initWithMOC:(NSManagedObjectContext*)moc
{
    self = [super init];
    self.moc = moc;
    return self;
}

- (NSMutableArray *)retrieveFriendsList
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Friend"];
    NSSortDescriptor *sortByActorName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByActorName];
    NSMutableArray *arrayOfFriendsList = [@[] mutableCopy];
    arrayOfFriendsList = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

    return arrayOfFriendsList;
}

- (NSMutableArray *)filterReadersList
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Friend"];
    NSSortDescriptor *sortByReaderName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByReaderName];
    request.predicate = [NSPredicate predicateWithFormat:@"isReader == YES"];
    NSMutableArray *arrayOfReadersList = [@[] mutableCopy];
    arrayOfReadersList = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

    return arrayOfReadersList;
}

- (NSMutableArray *)filterReadersListByName:(NSString *)readerName
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Friend"];
    NSSortDescriptor *sortByReaderName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByReaderName];
    request.predicate = [NSPredicate predicateWithFormat:@"(isReader == YES) AND (name CONTAINS[cd] %@)", readerName];
    NSMutableArray *arrayOfReadersList = [@[] mutableCopy];
    arrayOfReadersList = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

    return arrayOfReadersList;
}

- (NSMutableArray *)filterReadersListByRecommendedBooks
{
    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:@"Friend"];
    request.predicate = [NSPredicate predicateWithFormat:@"isReader == YES"];
    NSMutableArray *arrayOfReadersList = [@[] mutableCopy];
    arrayOfReadersList = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

    NSSortDescriptor *sortByBooksCount = [[NSSortDescriptor alloc]initWithKey:@"books.@count" ascending:NO];
    NSArray *arrayOfBooksCount = [[NSArray alloc]initWithObjects:sortByBooksCount, nil];
    [arrayOfReadersList sortUsingDescriptors:arrayOfBooksCount];

    return arrayOfReadersList;
}

- (void)removeBooksInCoreDataWithArray:(NSMutableArray *)arrayOfBooksList forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Book *book = [arrayOfBooksList objectAtIndex:indexPath.row];
    [self.moc deleteObject:book];
    [arrayOfBooksList removeObjectAtIndex:indexPath.row];
    [self.moc save:nil];
}

- (void)removeCommentsInCoreDataWithArray:(NSMutableArray *)arrayOfCommentsList forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [arrayOfCommentsList objectAtIndex:indexPath.row];
    [self.moc deleteObject:comment];
    [arrayOfCommentsList removeObjectAtIndex:indexPath.row];
    [self.moc save:nil];
}

- (void)storeFriendsListByArray:(NSMutableArray *)arrayOfFriendsList
{
    for (NSDictionary *dictionaryOfFriend in arrayOfFriendsList)
    {
        Friend *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:self.moc];
        friend.isReader = dictionaryOfFriend[@"isReader"];
        friend.name = dictionaryOfFriend[@"name"];
    }
    [self.moc save:nil];
}

- (void)updateReadersListByArray:(NSMutableArray *)arrayOfReadersList atIndexPath:(NSIndexPath *)indexPath
{
    Friend *friend = arrayOfReadersList[indexPath.row];
    if ([friend.isReader boolValue])
    {
        friend.isReader = [NSNumber numberWithBool:NO];
    }
    else
    {
        friend.isReader = [NSNumber numberWithBool:YES];
    }
    [self.moc save:nil];
}

- (void)storeBooksByTitleString:(NSString *)titleString byAuthorString:(NSString *)authorString wtihReader:(Friend *)reader
{
    Book *book = [NSEntityDescription insertNewObjectForEntityForName:@"Book" inManagedObjectContext:self.moc];
    book.title = titleString;
    book.author = authorString;
    [reader addBooksObject:book];
    [self.moc save:nil];
}

- (void)storeCommentsByTextString:(NSString *)textString wtihBook:(Book *)book
{

    Comment *comment = [NSEntityDescription insertNewObjectForEntityForName:@"Comment" inManagedObjectContext:self.moc];
    comment.text = textString;
    [book addCommentsObject:comment];
    [self.moc save:nil];
}




@end
