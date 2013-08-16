//
//  NSString+HexToData.m
//  InToxicate
//
//  Created by Christoph Krautz on 13.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "NSString+HexToData.h"

@implementation NSString (HexToData)

int char2hex(unichar c) {
    switch (c) {
        case '0' ... '9': return c - '0';
        case 'a' ... 'f': return c - 'a' + 10;
        case 'A' ... 'F': return c - 'A' + 10;
        default: return -1;
    }
}

- (NSData *)hexToData
{
    unsigned stringIndex=0, resultIndex=0, max=[self length];
    NSMutableData* result = [NSMutableData dataWithLength:(max + 1)/2];
    unsigned char* bytes = [result mutableBytes];
    
    unsigned num_nibbles = 0;
    unsigned char byte_value = 0;
    
    for (stringIndex = 0; stringIndex < max; stringIndex++) {
        int val = char2hex([self characterAtIndex:stringIndex]);
        if (val < 0) continue;
        num_nibbles++;
        byte_value = byte_value * 16 + (unsigned char)val;
        if (! (num_nibbles % 2)) {
            bytes[resultIndex++] = byte_value;
            byte_value = 0;
        }
    }
    
    //final nibble
    if (num_nibbles % 2) {
        bytes[resultIndex++] = byte_value;
        byte_value = 0;
    }
    
    [result setLength:resultIndex];
    return result;
}

- (NSData *)createDataWithHexString
{
    NSUInteger inLength = [self length];
    
    unichar *inCharacters = alloca(sizeof(unichar) * inLength);
    [self getCharacters:inCharacters range:NSMakeRange(0, inLength)];
    
    UInt8 *outBytes = malloc(sizeof(UInt8) * ((inLength / 2) + 1));
    
    NSInteger i, o = 0;
    UInt8 outByte = 0;
    for (i = 0; i < inLength; i++) {
        UInt8 c = inCharacters[i];
        SInt8 value = -1;
        
        if      (c >= '0' && c <= '9') value =      (c - '0');
        else if (c >= 'A' && c <= 'F') value = 10 + (c - 'A');
        else if (c >= 'a' && c <= 'f') value = 10 + (c - 'a');
        
        if (value >= 0) {
            if (i % 2 == 1) {
                outBytes[o++] = (outByte << 4) | value;
                outByte = 0;
            } else {
                outByte = value;
            }
            
        } else {
            if (o != 0) break;
        }
    }
    
    return [[NSData alloc] initWithBytesNoCopy:outBytes length:o freeWhenDone:YES];
}

@end
