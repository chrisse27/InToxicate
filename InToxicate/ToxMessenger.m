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

- (void)onFriendRequest:(uint8_t*) cUserId Message:(uint8_t*) cMessage Size:(uint16_t) cMessageSize UserData: (void *) cUserData;
- (void)onFriendMessageWithMessenger:(Messenger *)m FriendNumber:(int) friendNumber Message:(uint8_t *) cMessage Size: (uint16_t) cMessageSize UserData: (void *) cUserData;
- (void)onFriendNameChangeWithMessenger:(Messenger *)m FriendNumber:(int)friendNumber NewName: (NSString *) name UserData: (void *) cUserData;
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

void onFriendRequest(uint8_t* cUserId, uint8_t* cMessage, uint16_t cMessageSize, void *userData)
{
    [master onFriendRequest:cUserId Message:cMessage Size:cMessageSize UserData:userData];
}

void onFriendNameChange(Messenger *m, int friendIndex, uint8_t *name, uint16_t nameLength, void *userData)
{
    NSData *nameData = [NSData dataWithBytes:(const void *)name length:nameLength];
    NSString *friendName = [NSString stringAsHexFromData:nameData WithSpaces:NO];
    [master onFriendNameChangeWithMessenger:m FriendNumber:friendIndex NewName:friendName UserData:userData];
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
        // @TODO: Encrypt file!!!!!
        [newData writeToFile:self.dataPath atomically:NO];
        
        return;
    } else {
        Messenger_load(messenger, (uint8_t*)[data bytes], [data length]);
    }
}

- (void)onFriendRequest:(uint8_t*) cUserId Message:(uint8_t*) cMessage Size:(uint16_t) cMessageSize UserData: (void *) cUserData
{
    NSLog(@"Received friend request");
}

- (void)onFriendMessageWithMessenger:(Messenger *)m FriendNumber:(int) friendNumber Message:(uint8_t *) cMessage Size: (uint16_t) cMessageSize UserData: (void *) cUserData
{
    
}

- (void)onFriendNameChangeWithMessenger:(Messenger *)m FriendNumber:(int)friend NewName: (NSString *) name UserData: (void *) cUserData
{
    
}

- (void)initTox {
    
    messenger = initMessenger();
    if (!messenger) {
        NSLog(@"Failed to allocate Messenger datastructure");
        return;
    }
    
    void *userData = NULL;
    
    m_callback_friendrequest(messenger, onFriendRequest, userData);
    //    m_callback_friendmessage(m, print_message, userData);
    m_callback_namechange(messenger, onFriendNameChange, userData);
    //    m_callback_statusmessage(m, print_statuschange, userData);
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

- (void)acceptFriendRequest:(ToxFriend *)toxFriend
{
    // Should we create the friend only here or already before????
    int friendNumber = m_addfriend_norequest(messenger, toxFriend.clientId);
}

- (void)sendMessage:(NSString *) message ToFriend:(ToxFriend *)toxFriend
{
    m_sendmessage(messenger, toxFriend.number, (uint8_t *)[message UTF8String], [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding]);
}

@end
