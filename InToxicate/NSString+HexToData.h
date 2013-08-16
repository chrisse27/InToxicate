//
//  NSString+HexToData.h
//  InToxicate
//
//  Created by Christoph Krautz on 13.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HexToData)

+ (NSString*)stringAsHexFromData:(NSData *) data WithSpaces:(BOOL)spaces;

- (NSData *)createDataWithHexString;
- (NSData *)hexToData;
@end
