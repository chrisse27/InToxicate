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

FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendRequestNotification;
FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendMessageNotification;
FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendReadReceiptNotification;
FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendNameChangeNotification;
FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendStatusChangeNotification;
FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendStatusMessageNotification;
FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendConnectionStatusMessageNotification;
FOUNDATION_EXPORT NSString * const ToxHasReceivedFriendActionNotification;

FOUNDATION_EXPORT NSString * const ToxMessengerNotificationsFriendKey;
FOUNDATION_EXPORT NSString * const ToxMessengerNotificationsFriendRequestKey;
FOUNDATION_EXPORT NSString * const ToxMessengerNotificationsFriendReadReceiptKey;
FOUNDATION_EXPORT NSString * const ToxMessengerNotificationsFriendConnectionStatusKey;
FOUNDATION_EXPORT NSString * const ToxMessengerNotificationsFriendUserStatusKey;
FOUNDATION_EXPORT NSString * const ToxMessengerNotificationsFriendMessageKey;
FOUNDATION_EXPORT NSString * const ToxMessengerNotificationsFriendActionKey;

@interface ToxMessenger : NSObject
@property (nonatomic,readonly) NSString *personalId;
@property (nonatomic, strong) NSString *name;
@property (nonatomic,readonly) NSString *dataPath;
@property (nonatomic,readonly) NSArray *friends;
@property (nonatomic,readonly) NSArray *friendRequests;

- (void)start;
- (void)save;
- (void)shutdown;

- (ToxFriend *)addFriendWithUserId:(uint8_t *)userId;
- (void)acceptFriendRequest:(ToxFriendRequest *)toxFriendRequest;
- (void)sendMessage:(NSString *) message ToFriend:(ToxFriend *)toxFriend;
@end
