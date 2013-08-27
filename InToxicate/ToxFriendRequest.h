//
//  ToxFriendRequest.h
//  InToxicate
//
//  Created by Christoph Krautz on 23.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToxFriendRequest : NSObject
@property (nonatomic, readonly) uint8_t *clientId;
@property (nonatomic, readonly) NSString *message;

- (id)initWithClientId: (uint8_t *)clientId Message: (NSString *)message;
@end
