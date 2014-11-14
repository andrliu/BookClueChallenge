//
//  Friend.m
//  BookClueChallenge
//
//  Created by Andrew Liu on 11/12/14.
//  Copyright (c) 2014 Andrew Liu. All rights reserved.
//

#import "Friend.h"

@implementation Friend

@dynamic name;
@dynamic photo;
@dynamic isReader;
@dynamic books;

+ (void)retrieveFriendsListFromJsonAPI:(NSString *)jsonAPI withCompletion:(friendBlock)complete;
{
    NSURL *url = [NSURL URLWithString:jsonAPI];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if(!connectionError && data)
                               {
                                   NSError *JSONError;
                                   NSMutableArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingAllowFragments
                                                                                          error:&JSONError];
                                   if(!JSONError && data)
                                   {
                                       NSMutableArray *arrayOfFriendsList = [@[]mutableCopy];
                                       for (NSString *stringOfFriendName in jsonArray)
                                       {
                                           NSMutableDictionary *dictionaryOfFriend = [@{}mutableCopy];
                                           [dictionaryOfFriend setObject:stringOfFriendName
                                                                  forKey:@"name"];
                                           [dictionaryOfFriend setObject:[NSNumber numberWithBool:NO]
                                                                  forKey:@"isReader"];
                                           [arrayOfFriendsList addObject:dictionaryOfFriend];
                                       }
                                       complete(arrayOfFriendsList, nil);
                                   }
                                   else
                                   {
                                       complete(nil, JSONError);
                                   }
                               }
                               else
                               {
                                   complete(nil, connectionError);
                               }
                           }];
}

@end
