//
//  ToxViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 12.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxViewController.h"

#import "ToxAppDelegate.h"
#import "ToxMessenger.h"
#import "ToxAddNewFriendViewController.h"
#import "ToxFriendViewController.h"
#import "ToxFriendRequestViewController.h"
#import "ToxUserProfileViewController.h"

@interface ToxViewController ()
@property ToxMessenger *messenger;

- (void)registerToNotificationsOfMessenger: (ToxMessenger *)messenger;
- (void)deregisterFromNotificationsOfMessenger: (ToxMessenger *)messenger;
@end

@implementation ToxViewController

@synthesize messenger = _messenger;

- (ToxMessenger *)messenger {
    return _messenger;
}

- (void)setMessenger:(ToxMessenger *)messenger
{
    if (_messenger != messenger) {
        [self deregisterFromNotificationsOfMessenger: _messenger];
        _messenger = messenger;
        [self registerToNotificationsOfMessenger: _messenger];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.friendList.delegate = self;
    self.friendList.dataSource = self;
    
    self.messenger = [ToxAppDelegate messenger];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerToNotificationsOfMessenger: (ToxMessenger *)messenger;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasReceivedFriendRequest:) name:ToxHasReceivedFriendRequestNotification object:messenger];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasReceivedFriendNameChange:) name:ToxHasReceivedFriendNameChangeNotification object:messenger];
}

- (void)deregisterFromNotificationsOfMessenger: (ToxMessenger *)messenger
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ToxHasReceivedFriendRequestNotification object:_messenger];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ToxHasReceivedFriendNameChangeNotification object:_messenger];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Friend Requests";
        case 1:
            return @"Friends";
        default:
            return @"Unknown";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return self.messenger.friendRequests.count;
        case 1:
            return self.messenger.friends.count;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    switch (indexPath.section) {
        case 0:
        {
            static NSString *CellIdentifier = @"ToxFriendRequests";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            ToxFriendRequest *friendRequest = [self.messenger.friendRequests objectAtIndex:indexPath.row];
            cell.textLabel.text = friendRequest.message;
            break;
        }
        case 1:
        {
            static NSString *CellIdentifier = @"ToxFriends";
            cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            ToxFriend *friend = [self.messenger.friends objectAtIndex:indexPath.row];
            cell.textLabel.text = friend.name;
            cell.detailTextLabel.text = friend.status;
        }
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Navigation

- (void)prepareForShowFriendRequestSegue:(UIStoryboardSegue *)segue
{
    ToxFriendRequest *friendRequest = [self.messenger.friendRequests objectAtIndex:self.friendList.indexPathForSelectedRow.row];
    ToxFriendRequestViewController *friendRequestViewController = segue.destinationViewController;
    friendRequestViewController.delegate = self;
    friendRequestViewController.friendRequest = friendRequest;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowUserProfile"]) {
        ToxUserProfileViewController *userProfileViewController = segue.destinationViewController;
        userProfileViewController.messenger = self.messenger;
    } else if ([segue.identifier isEqualToString:@"ShowAddNewFriend"]) {
        ToxAddNewFriendViewController *addNewFriendViewController = segue.destinationViewController;
        addNewFriendViewController.delegate = self;
        addNewFriendViewController.messenger = self.messenger;
    } else if ([segue.identifier isEqualToString:@"ShowFriendRequest"]) {
        [self prepareForShowFriendRequestSegue:segue];
    } else if ([segue.identifier isEqualToString:@"ShowFriend"]) {
        ToxFriend *friend = [self.messenger.friends objectAtIndex:self.friendList.indexPathForSelectedRow.row];
        ToxFriendViewController *friendViewController = segue.destinationViewController;
        friendViewController.displayedFriend = friend;
    }
}

#pragma mark - ToxMessengerNotifications

- (void)hasReceivedFriendRequest:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.friendList reloadData];
    });
}

- (void)hasReceivedFriendNameChange:(NSNotification*)notification
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.friendList reloadData];
    });
}

#pragma mark - ToxFriendRequestViewDelegate

- (void)requested:(ToxFriendRequest *)request AcceptedBy:(id)sender
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.friendList reloadData];
    });
}

#pragma mark - ToxAddNewFriendViewDelegate

- (void)addedNewFriend:(ToxFriend *)toxFriend
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.friendList reloadData];
    });
}

@end
