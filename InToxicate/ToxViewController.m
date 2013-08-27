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
#import "ToxFriendRequestViewController.h"

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
    self.txtPublicKey.text = self.messenger.personalId;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)accept:(id)sender {
    NSLog(@"Accept");
    [self.messenger acceptFriendRequest:nil];
}

#pragma mark - Table view data source

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
            if (!cell)
            {
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
            if (!cell)
            {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
            }
            ToxFriend *friend = [self.messenger.friends objectAtIndex:indexPath.row];
            cell.textLabel.text = friend.name;
        }
        default:
            break;
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowFriendOrRequest"])
    {
        ToxFriendRequest *friendRequest = [self.messenger.friendRequests objectAtIndex:self.friendList.indexPathForSelectedRow.row];
        ToxFriendRequestViewController *friendRequestViewController = segue.destinationViewController;
        friendRequestViewController.friendRequest = friendRequest;
    }
}

@end
