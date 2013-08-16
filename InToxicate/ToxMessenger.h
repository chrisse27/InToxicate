//
//  ToxMessenger.h
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToxMessenger : NSObject
@property (nonatomic,readonly) NSString *publicKey;
@property (nonatomic,readonly) NSString *dataPath;

- (void)start;
@end
