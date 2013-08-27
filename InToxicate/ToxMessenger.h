//
//  ToxMessenger.h
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToxFriend.h"
#import "ToxFriendRequest.h"

@interface ToxMessenger : NSObject
@property (nonatomic,readonly) NSString *personalId;
@property (nonatomic,readonly) NSString *dataPath;
@property (nonatomic,readonly) NSArray *friends;
@property (nonatomic,readonly) NSArray *friendRequests;

- (void)start;

- (void)acceptFriendRequest:(ToxFriendRequest *)toxFriendRequest;
- (void)sendMessage:(NSString *) message ToFriend:(ToxFriend *)toxFriend;
@end
