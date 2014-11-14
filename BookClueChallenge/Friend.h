//
//  Friend.h
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface Friend : NSManagedObject

typedef void(^friendBlock)(NSMutableArray *arrayOfFriendsList, NSError *connectionError);

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSData * photo;
@property (nonatomic, retain) NSNumber * isReader;
@property (nonatomic, retain) NSSet *books;

@end

@interface Friend (CoreDataGeneratedAccessors)

- (void)addBooksObject:(NSManagedObject *)value;
- (void)removeBooksObject:(NSManagedObject *)value;
- (void)addBooks:(NSSet *)values;
- (void)removeBooks:(NSSet *)values;

+ (void)retrieveFriendsListFromJsonAPI:(NSString *)jsonAPI withCompletion:(friendBlock)complete;

@end
