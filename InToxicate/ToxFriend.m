//
//  ToxFriend.m
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxFriend.h"

@implementation ToxFriend

@synthesize clientId = _clientId;
@synthesize number = _number;

- (id)initWithClientID:(uint8_t *) clientId FriendNumber:(int) number
{
    self = [super init];
    if (self) {
        _clientId = clientId;
        _number = number;
    }
    
    return self;
}

@end
