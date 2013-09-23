//
//  ToxChatViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxChatViewController.h"

#import "ToxAppDelegate.h"
#import "ToxMessenger.h"
#import "ToxChatEntry.h"

@interface ToxChatViewController ()
@property (strong, nonatomic) ToxMessenger *messenger;

- (void)registerToNotificationsOfMessenger: (ToxMessenger *)messenger;
- (void)deregisterFromNotificationsOfMessenger: (ToxMessenger *)messenger;
@end

@implementation ToxChatViewController

@synthesize messenger = _messenger;
@synthesize toxFriend = _toxFriend;

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

- (void)setToxFriend:(ToxFriend *)toxFriend
{
    if (toxFriend != _toxFriend) {
        _toxFriend = toxFriend;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.messenger = [ToxAppDelegate messenger];
    self.title = [NSString stringWithFormat:@"Chat with %@", self.toxFriend.name];
    
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)registerToNotificationsOfMessenger: (ToxMessenger *)messenger;
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasReceivedFriendNameChange:) name:ToxHasReceivedFriendNameChangeNotification object:messenger];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hasReceivedFriendMessage:) name:ToxHasReceivedFriendMessageNotification object:messenger];
}

- (void)deregisterFromNotificationsOfMessenger: (ToxMessenger *)messenger
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ToxHasReceivedFriendNameChangeNotification object:_messenger];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ToxHasReceivedFriendMessageNotification object:_messenger];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.toxFriend.chat.entries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ToxChatEntry *entry = [self.toxFriend.chat.entries objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier;
    if ([entry.source isKindOfClass:[ToxUser class]]) {
        CellIdentifier = @"ChatEntriesUser";
    } else if ([entry.source isKindOfClass:[ToxFriend class]]) {
        CellIdentifier = @"ChatEntriesFriend";
    }

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    UITextView *messageTextView = (UITextView *)[cell viewWithTag:101];
    messageTextView.text = entry.message;
//    cell.detailTextLabel.text = entry.source.name;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ComposeMessage"]) {
        ToxNewMessageViewController *destinationController = segue.destinationViewController;
        destinationController.delegate = self;
    }
}

#pragma mark - ToxNewMessageViewDelegate

- (void)sendMessage:(NSString *)message
{
    [self.messenger sendMessage:message ToFriend:self.toxFriend];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

#pragma mark - ToxMessengerNotifications

- (void)hasReceivedFriendNameChange:(NSNotification*)notification
{
    ToxFriend *friend = notification.userInfo[ToxMessengerNotificationsFriendKey];
    
    if (friend != self.toxFriend) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)hasReceivedFriendMessage:(NSNotification*)notification
{
    ToxFriend *friend = notification.userInfo[ToxMessengerNotificationsFriendKey];
    
    if (friend != self.toxFriend) {
        return;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

@end
