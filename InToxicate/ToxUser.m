//
//  ToxUser.m
//  InToxicate
//
//  Created by Christoph Krautz on 23.09.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxUser.h"

@interface ToxUser()
@property (nonatomic, strong) ToxMessenger *messenger;
@end

@implementation ToxUser

@synthesize messenger = _messenger;

- (NSString *)name
{
    return self.messenger.name;
}

- (id)initWithMessenger:(ToxMessenger *)messenger
{
    self = [super init];
    if (self) {
        self.messenger = messenger;
    }
    
    return self;
}
@end
