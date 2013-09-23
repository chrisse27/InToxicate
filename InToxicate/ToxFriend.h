//
//  ToxFriend.h
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Messenger.h"
#import "ToxChat.h"

@class ToxChat;

@interface ToxFriend : NSObject
@property (nonatomic, readonly) Friend *cFriend;
@property (nonatomic, readonly) int number;
@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *status;

@property (nonatomic, readonly) ToxChat *chat;

- (id)initWithFriend:(Friend *) cFriend Number:(int) number;
@end
