//
//  ToxChatEntry.m
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxChatEntry.h"

@implementation ToxChatEntry

@synthesize source = _source;
@synthesize message = _message;

- (id)initWithSource:(id<ToxPerson>)source Message:(NSString *)message
{
    self = [super init];
    if (self) {
        _source = source;
        _message = message;
    }
    return self;
}

@end
