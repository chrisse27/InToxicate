//
//  ToxFriend.m
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxFriend.h"

@implementation ToxFriend

@synthesize cFriend = _cFriend;
@synthesize number = _number;

- (NSString *) name
{
    NSString *result = [NSString stringWithUTF8String:(const char *)self.cFriend->name];
    return result.length == 0 ? @"Unknown" : result;
}

- (NSString *) status
{
    switch (self.cFriend->status)
    {
        case NOFRIEND:
            return @"No Friend";
        case FRIEND_ADDED:
            return @"Added";
        case FRIEND_REQUESTED:
            return @"Requested";
        case FRIEND_CONFIRMED:
            return @"Confirmed";
        case FRIEND_ONLINE:
            return @"Online";
        default:
            return @"Unknown";
    }
}

- (id)initWithFriend:(Friend *) cFriend
{
    self = [super init];
    if (self) {
        _cFriend = cFriend;
    }
    
    return self;
}

@end
