//
//  ToxMessengerNotifications.h
//  InToxicate
//
//  Created by Christoph Krautz on 27.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToxFriendRequest.h"

@class ToxMessenger;

@protocol ToxMessengerNotifications <NSObject>
@optional
- (void)messenger: (ToxMessenger *)messenger hasReceivedFriendRequest: (ToxFriendRequest *)friendRequest;
@end
