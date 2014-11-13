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
    NSSortDescriptor *sortByActorName = [[NSSortDescriptor alloc]initWithKey:@"name" ascending:YES];
    request.sortDescriptors = @[sortByActorName];
    
    request.predicate = [NSPredicate predicateWithFormat:@"isReader == %@", [NSNumber numberWithBool:YES]];
    NSMutableArray *arrayOfReadersList = [@[] mutableCopy];
    arrayOfReadersList = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    return arrayOfReadersList;
}

- (void)storeFriendsListByArray:(NSMutableArray *)arrayOfFriendsList
{
    for (NSDictionary *dictionaryOfFriend in arrayOfFriendsList)
    {
        NSManagedObject *friend = [NSEntityDescription insertNewObjectForEntityForName:@"Friend" inManagedObjectContext:self.moc];
        [friend setValue:dictionaryOfFriend[@"isReader"] forKey:@"isReader"];
        [friend setValue:dictionaryOfFriend[@"name"] forKey:@"name"];
    }
    [self.moc save:nil];
}

- (void)updateReadersListByArray:(NSMutableArray *)arrayOfReadersList atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *friend = arrayOfReadersList[indexPath.row];
    if ([[friend valueForKey:@"isReader"] isEqual: [NSNumber numberWithBool:NO]])
    {
        [friend setValue:[NSNumber numberWithBool:YES] forKey:@"isReader"];
    }
    else
    {
        [friend setValue:[NSNumber numberWithBool:NO] forKey:@"isReader"];
    }
    [self.moc save:nil];
}

@end
