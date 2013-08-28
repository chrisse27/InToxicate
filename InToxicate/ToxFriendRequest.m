//
//  ToxFriendRequest.m
//  InToxicate
//
//  Created by Christoph Krautz on 23.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxFriendRequest.h"
#import "NSString+HexToData.h"

#import "Messenger.h"

@implementation ToxFriendRequest

@synthesize clientId = _clientId;
@synthesize message = _message;

- (NSString *)readableClientId
{
    NSData *clientIdData = [NSData dataWithBytes:((const void *)self.clientId) length:FRIEND_ADDRESS_SIZE];
    return [NSString stringAsHexFromData:clientIdData WithSpaces:NO];
}

- (id)initWithClientId: (uint8_t *)clientId Message: (NSString *)message
{
    self = [super init];
    
    if (self) {
        _clientId = clientId;
        _message = message;
    }
    
    return self;
}

@end
