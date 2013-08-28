//
//  ToxFriendRequestViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 27.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxFriendRequestViewController.h"

#import "ToxAppDelegate.h"

@interface ToxFriendRequestViewController ()
@property ToxMessenger *messenger;
@end

@implementation ToxFriendRequestViewController

@synthesize messenger = _messenger;
@synthesize friendRequest = _friendRequest;
@synthesize delegate;

- (void)setFriendRequest:(ToxFriendRequest *)friendRequest
{
    _friendRequest = friendRequest;
    
    self.friendId.text = _friendRequest.readableClientId;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.messenger = [ToxAppDelegate messenger];
}

- (IBAction)acceptRequest:(id)sender
{
    NSLog(@"Accepting request");
    //TODO if this view provides a delegate property for notifiying the view above that it accepted the request then we do not need to provide a reference to the messenger (check)
    [self.messenger acceptFriendRequest:self.friendRequest];
    [self.delegate requested:self.friendRequest AcceptedBy:self];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
