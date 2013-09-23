//
//  ToxChatEntry.h
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ToxPerson.h"

@interface ToxChatEntry : NSObject
@property (readonly, nonatomic) id<ToxPerson> source;
@property (readonly, nonatomic) NSString *message;

- (id)initWithSource:(id<ToxPerson>)source Message:(NSString *)message;
@end
