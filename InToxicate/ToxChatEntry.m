//
//  ToxChatEntry.m
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxChatEntry.h"

@implementation ToxChatEntry

- (id)initWithSource:(ToxFriend *)source Message:(NSString *)message
{
    self = [super init];
    if (self) {
        _source = source;
        _message = message;
    }
    return self;
}

@synthesize source = _source;
@synthesize message = _message;

@end
