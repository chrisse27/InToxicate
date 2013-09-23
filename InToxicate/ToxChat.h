//
//  ToxChat.h
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToxPerson.h"
#import "ToxFriend.h"

@class ToxFriend;

@interface ToxChat : NSObject
@property (strong, nonatomic) NSArray *friends;
@property (readonly, nonatomic) NSArray *entries;

- (void) addFriend:(ToxFriend *)aFriend;
- (void) addMessage:(NSString *)message From:(id<ToxPerson>)source;
@end
