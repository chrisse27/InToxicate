//
//  ToxUser.h
//  InToxicate
//
//  Created by Christoph Krautz on 23.09.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ToxPerson.h"
#import "ToxMessenger.h"

@class ToxMessenger;

@interface ToxUser : NSObject<ToxPerson>
- (id)initWithMessenger:(ToxMessenger *)messenger;
@end
