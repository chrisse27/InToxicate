//
//  ToxChat.m
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxChat.h"
#import "ToxChatEntry.h"

@implementation ToxChat
{
    NSMutableArray *_entries;
    NSMutableArray *_friends;
}

- (NSArray *)friends
{
    return _friends;
}

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

- (void) addFriend:(ToxFriend *)friend
{
    [_friends addObject:friend];
}

- (void) addMessage:(NSString *)message From:(ToxFriend *)aFriend
{
    ToxChatEntry *entry = [[ToxChatEntry alloc] initWithSource:aFriend Message: message];
    
    [_entries addObject:entry];
}

@end
