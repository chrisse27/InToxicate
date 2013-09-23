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

typedef enum CONNECTIONSTATUS {
    WENT_ONLINE,
    WENT_OFFLINE
} CONNECTIONSTATUS;

typedef enum TOX_USERSTATUS {
    TOX_USERSTATUS_NONE,
    TOX_USERSTATUS_AWAY,
    TOX_USERSTATUS_BUSY,
    TOX_USERSTATUS_INVALID
} TOX_USERSTATUS;

NSString * const ToxHasReceivedFriendRequestNotification = @"ToxHasReceivedFriendRequestNotification";
NSString * const ToxHasReceivedFriendMessageNotification = @"ToxHasReceivedFriendMessageNotification";
NSString * const ToxHasReceivedFriendReadReceiptNotification = @"ToxHasReceivedFriendReadReceiptNotification";
NSString * const ToxHasReceivedFriendNameChangeNotification = @"ToxHasReceivedFriendNameChangeNotification";
NSString * const ToxHasReceivedFriendStatusChangeNotification = @"ToxHasReceivedFriendStatusChangeNotification";
NSString * const ToxHasReceivedFriendStatusMessageNotification = @"ToxHasReceivedFriendStatusMessageNotification";
NSString * const ToxHasReceivedFriendConnectionStatusMessageNotification = @"ToxHasReceivedFriendConnectionStatusMessageNotification";
NSString * const ToxHasReceivedFriendActionNotification = @"ToxHasReceivedFriendActionNotification";

NSString * const ToxMessengerNotificationsFriendKey = @"ToxMessengerNoticationsFriendKey";
NSString * const ToxMessengerNotificationsFriendRequestKey = @"ToxMessengerNoticationsFriendRequestKey";
NSString * const ToxMessengerNotificationsFriendReadReceiptKey = @"ToxMessengerNoticationsFriendReadReceiptKey";
NSString * const ToxMessengerNotificationsFriendConnectionStatusKey = @"ToxMessengerNoticationsFriendConnectionStatusKey";
NSString * const ToxMessengerNotificationsFriendUserStatusKey = @"ToxMessengerNoticationsFriendUserStatusKey";
NSString * const ToxMessengerNotificationsFriendMessageKey = @"ToxMessengerNoticationsFriendMessageKey";
NSString * const ToxMessengerNotificationsFriendActionKey = @"ToxMessengerNoticationsFriendActionKey";

@interface ToxMessenger()

- (void)load;

- (void)onFriendRequest:(uint8_t*) cUserId
                Message:(NSString*) message
               UserData: (void *) cUserData;

- (void)onFriendMessageWithMessenger:(Messenger *)m
                        FriendNumber:(int) friendNumber
                             Message:(NSString *) message
                            UserData: (void *)cUserData;

- (void)onFriendActionWithMessenger:(Messenger *)m
                       FriendNumber:(int) friendNumber
                             Action:(NSString *) action
                           UserData: (void *)cUserData;

- (void)onFriendNameChangeWithMessenger:(Messenger *)m
                           FriendNumber:(int)friendNumber
                                NewName: (NSString *) name
                               UserData: (void *) cUserData;

- (void)onFriendStatusMessageWithMessenger:(Messenger *)m
                              FriendNumber:(int) friendNumber
                             StatusMessage:(NSString *) statusMessage
                                  UserData: (void *)cUserData;

- (void)onFriendUserStatusChangeWithMessenger:(Messenger *)m
                                 FriendNumber:(int)friendNumber
                                   UserStatus:(USERSTATUS)status
                                     UserData: (void *) cUserData;

- (void)onFriendReadReceiptWithMessenger:(Messenger *)m
                            FriendNumber:(int)friendNumber
                                 Receipt:(uint32_t)receipt
                                UserData: (void *) cUserData;

- (void)onFriendConnectionStatusChangeWithMessenger:(Messenger *)m
                                       FriendNumber:(int)friendNumber
                                   ConnectionStatus:(CONNECTIONSTATUS)status
                                           UserData: (void *) cUserData;
@end

@implementation ToxMessenger
{
    Messenger *messenger;
    int connTryCount;
    BOOL hadConnectedToDHT;
    NSTimer *timer;
    
    NSMutableArray *_friends;
    NSMutableArray *_friendRequests;
}

#pragma mark static stuff

ToxMessenger *master;

void onFriendRequest(uint8_t* cUserId, uint8_t* cMessage, uint16_t cMessageLength, void *userData)
{
    NSString *message = [NSString stringWithUTF8String:(const char *)cMessage];
    [master onFriendRequest:cUserId Message:message UserData:userData];
}

void onFriendMessage(Messenger *m, int friendNumber, uint8_t *cMessage, uint16_t cMessageLength, void *userData)
{
    NSString *message = [NSString stringWithUTF8String:(const char *)cMessage];
    [master onFriendMessageWithMessenger:m FriendNumber:friendNumber Message:message UserData:userData];
}

void onFriendAction(Messenger *m, int friendNumber, uint8_t *cAction, uint16_t cActionLength, void *userData)
{
    NSString *action = [NSString stringWithUTF8String:(const char *)cAction];
    [master onFriendActionWithMessenger:m FriendNumber:friendNumber Action:action UserData:userData];
}

void onFriendNameChange(Messenger *m, int friendNumber, uint8_t *cName, uint16_t cNameLength, void *userData)
{
    NSString *friendName = [NSString stringWithUTF8String:(const char *)cName];
    [master onFriendNameChangeWithMessenger:m FriendNumber:friendNumber NewName:friendName UserData:userData];
}

void onFriendStatusMessage(Messenger *m, int friendNumber, uint8_t *cStatusMessage, uint16_t cStatusMessageLength, void *userData)
{
    NSString *statusMessage = [NSString stringWithUTF8String:(const char *)cStatusMessage];
    [master onFriendStatusMessageWithMessenger:m FriendNumber:friendNumber StatusMessage:statusMessage UserData:userData];
}

void onFriendUserStatusChange(Messenger *m, int friendNumber, USERSTATUS status, void *userData)
{
    [master onFriendUserStatusChangeWithMessenger:m FriendNumber:friendNumber UserStatus:status UserData:userData];
}

void onFriendReadReceipt(Messenger *m, int friendNumber, uint32_t receipt, void *userData)
{
    
}

void onFriendConnectionStatusChange(Messenger *m, int friendNumber, uint8_t status, void *userData)
{
    CONNECTIONSTATUS connStatus;
    switch (status) {
        case 0:
            connStatus = WENT_OFFLINE;
            break;
        case 1:
            connStatus = WENT_ONLINE;
            break;
        default:
            connStatus = WENT_OFFLINE;
            break;
    }
    
    [master onFriendConnectionStatusChangeWithMessenger:m FriendNumber:friendNumber ConnectionStatus:connStatus UserData:userData];
}

/*
 resolve_addr():
 address should represent IPv4 or a hostname with A record
 
 returns a data in network byte order that can be used to set IP.i or IP_Port.ip.i
 returns 0 on failure
 
 TODO: Fix ipv6 support
 */
uint32_t resolve_addr(const char *address)
{
    struct addrinfo *server = NULL;
    struct addrinfo  hints;
    int              rc;
    uint32_t         addr;
    
    memset(&hints, 0, sizeof(hints));
    hints.ai_family   = AF_INET;    // IPv4 only right now.
    hints.ai_socktype = SOCK_DGRAM; // type of socket Tox uses.
    
    rc = getaddrinfo(address, "echo", &hints, &server);
    
    // Lookup failed.
    if (rc != 0) {
        return 0;
    }
    
    // IPv4 records only..
    if (server->ai_family != AF_INET) {
        freeaddrinfo(server);
        return 0;
    }
    
    
    addr = ((struct sockaddr_in *)server->ai_addr)->sin_addr.s_addr;
    
    freeaddrinfo(server);
    return addr;
}

#pragma mark instance stuff

@synthesize user = _user;

- (NSArray *)friends
{
    return _friends;
}

- (NSArray *)friendRequests
{
    return _friendRequests;
}

- (NSString *)personalId
{
    uint8_t address[FRIEND_ADDRESS_SIZE];
    getaddress(messenger, address);
    
    NSData *publicKeyData = [NSData dataWithBytes:((const void *)address) length:FRIEND_ADDRESS_SIZE];
    return [NSString stringAsHexFromData:publicKeyData WithSpaces:NO];;
}

- (NSString *)name
{
    return [NSString stringWithUTF8String:(const char *)messenger->name];
}

- (void)setName:(NSString *)name
{
    setname(messenger, (uint8_t *)[name UTF8String], name.length + 1);
}

- (NSString *)dataPath
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths objectAtIndex:0];
    return [documentPath stringByAppendingPathComponent:@"./data"];
}

-(id) init
{
    self = [super init];
    if (self)
    {
        master = self;
        connTryCount = 0;
        hadConnectedToDHT = NO;
        
        _friendRequests = [[NSMutableArray alloc] init];
        _friends = [[NSMutableArray alloc] init];
        
        _user = [[ToxUser alloc] initWithMessenger:self];
        
        [self start];
    }
    return self;
}

- (void) dealloc
{
    [self shutdown];
}

- (void)shutdown
{
    cleanupMessenger(messenger);
}

- (void)load
{
    NSData *data = [NSData dataWithContentsOfFile:self.dataPath];
    
    if (!data) {
        NSLog(@"Data file not found.");
        [self save];
        
        return;
    } else {
        Messenger_load(messenger, (uint8_t*)[data bytes], [data length]);
        
        for (int i=0; i < messenger->numfriends; ++i) {
            ToxFriend *friend = [[ToxFriend alloc] initWithFriend:&messenger->friendlist[i] Number:i];
            [_friends addObject:friend];
        }
    }
}

- (void)save
{
    int messengerSize = Messenger_size(messenger);
    NSMutableData *newData = [NSMutableData dataWithLength:messengerSize];
    Messenger_save(messenger, (uint8_t*)[newData bytes]);
    //TODO: Encrypt file!!!!!
    [newData writeToFile:self.dataPath atomically:NO];
}

- (void)initTox
{
    messenger = initMessenger(false);
    if (!messenger) {
        NSLog(@"Failed to allocate Messenger datastructure");
        return;
    }
    
    // set-up callbacks
    void *userData = NULL;
    m_callback_friendrequest(messenger, onFriendRequest, userData);
    m_callback_friendmessage(messenger, onFriendMessage, userData);
    m_callback_action(messenger, onFriendAction, userData);
    m_callback_namechange(messenger, onFriendNameChange, userData);
    m_callback_statusmessage(messenger, onFriendStatusMessage, userData);
    m_callback_userstatus(messenger, onFriendUserStatusChange, userData);
    m_callback_read_receipt(messenger, onFriendReadReceipt, userData);
    m_callback_connectionstatus(messenger, onFriendConnectionStatusChange, userData);
}


- (void)initConnection
{
    if (DHT_isconnected(messenger->dht)) {
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
        bootstrap_ip_port.ip.ip4.uint32 = resolved_address;
    } else {
        NSLog(@"Failed to resolve IP address");
        return;
    }
    
    DHT_bootstrap(messenger->dht, bootstrap_ip_port, (uint8_t*)[publicKeyData bytes]);
}

- (void)doTox
{
    doMessenger(messenger);
    
    if (!hadConnectedToDHT && !DHT_isconnected(messenger->dht) && !(connTryCount++ % 1000)) {
        [self initConnection];
        NSLog(@"Establishing connection...\n");
    }
    else if (!hadConnectedToDHT && DHT_isconnected(messenger->dht)) {
        hadConnectedToDHT = YES;
        NSLog(@"DHT connected.\n");
    }
    else if (hadConnectedToDHT && !DHT_isconnected(messenger->dht)) {
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
}

- (ToxFriend *)addFriendWithUserId:(uint8_t *)userId
{
    NSString *dummyMessage = @"Dummy Message";
    
    int result = m_addfriend(messenger, userId, (uint8_t *)[dummyMessage UTF8String], dummyMessage.length + 1);
    
    switch (result) {
        case FAERR_TOOLONG:
            NSLog(@"Message is too long.");
            return nil;

        case FAERR_NOMESSAGE:
            NSLog(@"Please add a message to your request.");
            return nil;
            
        case FAERR_OWNKEY:
            NSLog(@"That appears to be your own ID.");
            return nil;
            
        case FAERR_ALREADYSENT:
            NSLog(@"Friend request already sent.");
            return nil;
            
        case FAERR_UNKNOWN:
            NSLog(@"Undefined error when adding friend.");
            return nil;
            
        case FAERR_BADCHECKSUM:
            NSLog(@"Bad checksum in address.");
            return nil;
            
        case FAERR_SETNEWNOSPAM:
            NSLog(@"Nospam was different.");
            return nil;
            
        default:
            NSLog(@"Friend added as %d.", result);
            ToxFriend *friend = [[ToxFriend alloc] initWithFriend:&messenger->friendlist[result] Number: result];
            [_friends addObject:friend];
            [self save];
            return friend;
    }
}

- (void)acceptFriendRequest:(ToxFriendRequest *)toxFriendRequest
{
    int friendNumber = m_addfriend_norequest(messenger, toxFriendRequest.clientId);
    ToxFriend *friend = [[ToxFriend alloc] initWithFriend:&messenger->friendlist[friendNumber] Number:friendNumber];
    [_friends addObject:friend];
    [_friendRequests removeObject:toxFriendRequest];

    [self save];
}

- (void)sendMessage:(NSString *) message ToFriend:(ToxFriend *)toxFriend
{
    int result = m_sendmessage(messenger, toxFriend.number, (uint8_t *)[message UTF8String], [message lengthOfBytesUsingEncoding:NSUTF8StringEncoding] + 1); // add 1 for null termination
    
    if (result == 0) {
        NSLog(@"Failed to send message to %@", toxFriend.name);
    } else {
        [toxFriend.chat addMessage:message From:self.user];
    }
}

#pragma mark - Instance callbacks

- (void)onFriendRequest:(uint8_t*) cUserId Message:(NSString*) message UserData: (void *) cUserData
{
    ToxFriendRequest *friendRequest = [[ToxFriendRequest alloc] initWithClientId:cUserId Message:message];
    NSLog(@"Received friend request with message %@", message);
    
    [_friendRequests addObject:friendRequest];

    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendRequestNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendRequestKey:friendRequest}];
}

- (void)onFriendMessageWithMessenger:(Messenger *)m FriendNumber:(int) friendNumber Message:(NSString *) message UserData: (void *) cUserData
{
    NSLog(@"Received message from friend %d: %@", friendNumber, message);

    ToxFriend *friend = self.friends[friendNumber];
    [friend.chat addMessage:message From:friend];
    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendMessageNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendKey        : friend,
                                                                 ToxMessengerNotificationsFriendMessageKey : message}];
}

- (void)onFriendActionWithMessenger:(Messenger *)m FriendNumber:(int)friendNumber Action:(NSString *)action UserData:(void *)cUserData
{
    NSLog(@"Received action %@", action);
    
    ToxFriend *friend = self.friends[friendNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendActionNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendKey       : friend,
                                                                 ToxMessengerNotificationsFriendActionKey : action}];
}

- (void)onFriendNameChangeWithMessenger:(Messenger *)m FriendNumber:(int)friendNumber NewName: (NSString *) name UserData: (void *) cUserData
{
    NSLog(@"Received name change for friend %d to %@", friendNumber, name);

    ToxFriend *friend = self.friends[friendNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendNameChangeNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendKey : friend}];
}

- (void)onFriendStatusMessageWithMessenger:(Messenger *)m FriendNumber:(int) friendNumber StatusMessage:(NSString *) statusMessage UserData: (void *)cUserData
{
    NSLog(@"Received status message from friend %d: %@", friendNumber, statusMessage);
    
    ToxFriend *friend = self.friends[friendNumber];
    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendStatusMessageNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendKey       : friend,
                                                                 ToxMessengerNotificationsFriendActionKey : statusMessage}];
}

- (void)onFriendUserStatusChangeWithMessenger:(Messenger *)m FriendNumber:(int)friendNumber UserStatus:(USERSTATUS)status UserData:(void *)cUserData
{
    NSLog(@"Received user status change for friend %d to state %d", friendNumber, status);
    
    ToxFriend *friend = self.friends[friendNumber];
    NSValue *statusValue = [NSValue value: &status withObjCType: @encode(enum TOX_USERSTATUS)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendStatusChangeNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendKey           : friend,
                                                                 ToxMessengerNotificationsFriendUserStatusKey : statusValue}];
}

- (void)onFriendReadReceiptWithMessenger:(Messenger *)m FriendNumber:(int)friendNumber Receipt:(uint32_t)receipt UserData: (void *) cUserData
{
    NSLog(@"Received read receipt %d from friend %d", receipt, friendNumber);
    
    ToxFriend *friend = self.friends[friendNumber];
    NSNumber *receiptValue = [NSNumber numberWithInt:receipt];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendStatusChangeNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendKey            : friend,
                                                                 ToxMessengerNotificationsFriendReadReceiptKey : receiptValue}];
}

- (void)onFriendConnectionStatusChangeWithMessenger:(Messenger *)m FriendNumber:(int)friendNumber ConnectionStatus:(CONNECTIONSTATUS)status UserData:(void *)cUserData
{
    NSLog(@"Received user connection status change for friend %d to state %d", friendNumber, status);
    
    ToxFriend *friend = self.friends[friendNumber];
    NSValue *statusValue = [NSValue value: &status withObjCType: @encode(enum CONNECTIONSTATUS)];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:ToxHasReceivedFriendStatusChangeNotification
                                                        object:self
                                                      userInfo:@{ToxMessengerNotificationsFriendKey                 : friend,
                                                                 ToxMessengerNotificationsFriendConnectionStatusKey : statusValue}];
}
@end
