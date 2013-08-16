//
//  ToxMessenger.m
//  InToxicate
//
//  Created by Christoph Krautz on 16.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxMessenger.h"
#import "NSString+HexToData.h"

#import "network.h"
#import "DHT.h"
#import "Messenger.h"

@interface ToxMessenger()
- (void)onFriendRequest:(uint8_t*) cUserId Message:(uint8_t*) cMessage Size:(uint16_t) cMessageSize;
@end

@implementation ToxMessenger
{
    Messenger *messenger;
    int connTryCount;
    BOOL hadConnectedToDHT;
    NSTimer *timer;
}

ToxMessenger *master;

void onFriendRequest(uint8_t* cUserId, uint8_t* cMessage, uint16_t cMessageSize)
{
    [master onFriendRequest:cUserId Message:cMessage Size:cMessageSize];
}

-(id) init
{
    self = [super init];
    if (self)
    {
        connTryCount = 0;
        hadConnectedToDHT = NO;
        [self start];
    }
    return self;
}

- (void)onFriendRequest:(uint8_t*) cUserId Message:(uint8_t*) cMessage Size:(uint16_t) cMessageSize
{
}

- (void)initTox {
    
    messenger = initMessenger();
    if (!messenger) {
        NSLog(@"Failed to allocate Messenger datastructure");
        return;
    }
    
    m_callback_friendrequest(messenger, onFriendRequest);
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
    
    NSString *publicKey = @"728925473812C7AAC482BE7250BCCAD0B8CB9F737BF3D42ABD34459C1768F854";
    
    NSData *publicKeyData = [publicKey hexToData];
    //    NSData *publicKeyData = [publicKey createDataWithHexString];
    
    IP_Port bootstrap_ip_port;
    bootstrap_ip_port.port = htons(port);
    int resolved_address = resolve_addr([ip UTF8String]);
    if (resolved_address != 0) {
        bootstrap_ip_port.ip.i = resolved_address;
    } else {
        NSLog(@"Failed to resolve IP address");
        return;
    }
    
    DHT_bootstrap(bootstrap_ip_port, (uint8_t*)[publicKeyData bytes]);
}

- (void)doTox
{
    doMessenger(messenger);
    
    if (!hadConnectedToDHT && !DHT_isconnected() && !(connTryCount++ % 1000)) {
        [self initConnection];
        NSLog(@"Establishing connection...\n");
    }
    else if (!hadConnectedToDHT && DHT_isconnected()) {
        hadConnectedToDHT = YES;
        NSLog(@"DHT connected.\n");
    }
    else if (hadConnectedToDHT && !DHT_isconnected()) {
        hadConnectedToDHT = NO;
        NSLog(@"DHT disconnected. Attempting to reconnect.\n");
        [self initConnection];
    }
}

- (void)start
{
    [self initTox];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doTox) userInfo:nil repeats:YES];
    
    //cleanupMessenger(messenger);
}

@end
