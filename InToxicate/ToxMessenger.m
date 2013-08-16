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

- (void)load;

- (void)onFriendRequest:(uint8_t*) cUserId Message:(uint8_t*) cMessage Size:(uint16_t) cMessageSize;
- (void)onFriendNameChangeWithMessenger:(Messenger *)m FriendIndex:(int)friend NewName: (NSString *) name;
@end

@implementation ToxMessenger
{
    Messenger *messenger;
    int connTryCount;
    BOOL hadConnectedToDHT;
    NSTimer *timer;
}

ToxMessenger *master;

- (NSString *) publicKey
{
    NSData *publicKeyData = [NSData dataWithBytes:((const void *)self_public_key) length:crypto_box_PUBLICKEYBYTES];
    return [NSString stringAsHexFromData:publicKeyData WithSpaces:NO];;
}

- (NSString *)dataPath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"./data"];
}

void onFriendRequest(uint8_t* cUserId, uint8_t* cMessage, uint16_t cMessageSize)
{
    [master onFriendRequest:cUserId Message:cMessage Size:cMessageSize];
}

void onNameChange(Messenger *m, int friendIndex, uint8_t *name, uint16_t nameLength)
{
    NSData *nameData = [NSData dataWithBytes:(const void *)name length:nameLength];
    NSString *friendName = [NSString stringAsHexFromData:nameData WithSpaces:NO];
    [master onFriendNameChangeWithMessenger:m FriendIndex:friendIndex NewName:friendName];
}

-(id) init
{
    self = [super init];
    if (self)
    {
        master = self;
        connTryCount = 0;
        hadConnectedToDHT = NO;
        [self start];
    }
    return self;
}

- (void)load
{
    NSData *data = [NSData dataWithContentsOfFile:self.dataPath];
    
    if (!data) {
        NSLog(@"Data file not found.");
        
        int messengerSize = Messenger_size(messenger);
        NSMutableData *newData = [NSMutableData dataWithLength:messengerSize];
        Messenger_save(messenger, (uint8_t*)[newData bytes]);
        [newData writeToFile:self.dataPath atomically:NO];
        
        return;
    } else {
        Messenger_load(messenger, (uint8_t*)[data bytes], [data length]);
    }
}

- (void)onFriendRequest:(uint8_t*) cUserId Message:(uint8_t*) cMessage Size:(uint16_t) cMessageSize
{
    NSLog(@"Received friend request");
}

- (void)onFriendNameChangeWithMessenger:(Messenger *)m FriendIndex:(int)friend NewName: (NSString *) name
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
    m_callback_namechange(messenger, onNameChange);
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
    
    [self load];
    
    timer = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(doTox) userInfo:nil repeats:YES];
    
    //cleanupMessenger(messenger);
}

@end
