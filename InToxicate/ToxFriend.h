//
//  ToxFriend.h
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Messenger.h"

@interface ToxFriend : NSObject
@property (nonatomic, readonly) Friend *cFriend;
@property (nonatomic, readonly) int number;
@property (nonatomic, readonly) NSString *name;

- (id)initWithFriend:(Friend *) cFriend;
@end
