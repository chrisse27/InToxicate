//
//  ToxFriend.h
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToxFriend : NSObject
@property (nonatomic, readonly) uint8_t *clientId;
@property (nonatomic, readonly) int number;

- (id)initWithClientID:(uint8_t *) clientId FriendNumber:(int) number;
@end
