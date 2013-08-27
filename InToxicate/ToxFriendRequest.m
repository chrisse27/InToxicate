//
//  ToxFriendRequest.m
//  InToxicate
//
//  Created by Christoph Krautz on 23.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxFriendRequest.h"

@implementation ToxFriendRequest

@synthesize clientId = _clientId;
@synthesize message = _message;

- (id)initWithClientId: (uint8_t *)clientId Message: (NSString *)message
{
    self = [super init];
    
    if (self) {
        _clientId = clientId;
        _message = message;
    }
    
    return self;
}

@end
