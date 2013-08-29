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
@end

@implementation ToxViewController

@synthesize messenger = _messenger;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.friendList.delegate = self;
    self.friendList.dataSource = self;
    
    self.messenger = [ToxAppDelegate messenger];
    //TODO Make sure this is always set as delegate when active
    self.messenger.delegate = self;
    self.txtPublicKey.text = self.messenger.personalId;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)messenger:(ToxMessenger *)messenger hasReceivedFriendRequest:(ToxFriendRequest *)friendRequest
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
