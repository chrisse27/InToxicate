//
//  ToxChat.h
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToxFriend.h"

@interface ToxChat : NSObject
@property (strong, nonatomic) NSArray *friends;
@property (readonly, nonatomic) NSArray *entries;
@end
