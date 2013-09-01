//
//  ToxChatEntry.h
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToxFriend.h"

@interface ToxChatEntry : NSObject
@property (readonly, nonatomic) ToxFriend *source;
@property (readonly, nonatomic) NSString *message;
@end
