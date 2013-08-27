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
    return [NSString stringWithUTF8String:(const char *)self.cFriend->name];
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
