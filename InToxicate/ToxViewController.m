//
//  ToxViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 12.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxViewController.h"
#import "network.h"
#import "DHT.h"
#import "Messenger.h"

@interface ToxViewController ()

@end

@implementation ToxViewController

Messenger *messenger;
int conn_try = 0;
BOOL dht_on = NO;
NSTimer *timer;

int char2hex(unichar c) {
    switch (c) {
        case '0' ... '9': return c - '0';
        case 'a' ... 'f': return c - 'a' + 10;
        case 'A' ... 'F': return c - 'A' + 10;
        default: return -1;
    }
}

- (NSData *)hexToData:(NSString *)text {
    unsigned stringIndex=0, resultIndex=0, max=[text length];
    NSMutableData* result = [NSMutableData dataWithLength:(max + 1)/2];
    unsigned char* bytes = [result mutableBytes];
    
    unsigned num_nibbles = 0;
    unsigned char byte_value = 0;
    
    for (stringIndex = 0; stringIndex < max; stringIndex++) {
        int val = char2hex([text characterAtIndex:stringIndex]);
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

- (NSData *)createDataWithHexString:(NSString *)inputString
{
    NSUInteger inLength = [inputString length];
    
    unichar *inCharacters = alloca(sizeof(unichar) * inLength);
    [inputString getCharacters:inCharacters range:NSMakeRange(0, inLength)];
    
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

- (void)initTox {

    messenger = initMessenger();
    
    if (!messenger) {
        NSLog(@"Failed to allocate Messenger datastructure");
        return;
    }
    
    //    m_callback_friendrequest(m, print_request);
    //    m_callback_friendmessage(m, print_message);
    //    m_callback_namechange(m, print_nickchange);
    //    m_callback_statusmessage(m, print_statuschange);
}

- (void)initConnection {
    if (DHT_isconnected()) {
        return;
    }
    
    NSString *ip = @"198.46.136.167";
    int port = 33445;
    
    NSData *publicKey = [self hexToData:@"728925473812C7AAC482BE7250BCCAD0B8CB9F737BF3D42ABD34459C1768F854"];
    
    NSData *pk = [self createDataWithHexString:@"728925473812C7AAC482BE7250BCCAD0B8CB9F737BF3D42ABD34459C1768F854"];
    
    IP_Port bootstrap_ip_port;
    bootstrap_ip_port.port = htons(port);
    int resolved_address = resolve_addr([ip UTF8String]);
    if (resolved_address != 0) {
        bootstrap_ip_port.ip.i = resolved_address;
    } else {
        NSLog(@"Failed to resolve IP address");
        return;
    }
    
    DHT_bootstrap(bootstrap_ip_port, (uint8_t*)[publicKey bytes]);
}

- (void)doTox {
    doMessenger(messenger);
    
    NSLog(@"doTox connection...\n");
    if (!dht_on && !DHT_isconnected() && !(conn_try++ % 1000000)) {
        [self initConnection];
        NSLog(@"Establishing connection...\n");
    }
    else if (!dht_on && DHT_isconnected()) {
        dht_on = YES;
        NSLog(@"DHT connected.\n");
    }
    else if (dht_on && !DHT_isconnected()) {
        dht_on = NO;
        NSLog(@"DHT disconnected. Attempting to reconnect.\n");
        [self initConnection];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initTox];
        
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doTox) userInfo:nil repeats:YES];
    
    //cleanupMessenger(messenger);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
