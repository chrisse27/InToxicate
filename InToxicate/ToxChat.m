//
//  ToxChat.m
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxChat.h"

@implementation ToxChat
{
    NSMutableArray *_entries;
}

@synthesize friends = _friends;

- (NSArray *)entries
{
    return _entries;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        _entries = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
