//
//  ToxFriendViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 27.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxFriendViewController.h"

#import "ToxChatViewController.h"

@interface ToxFriendViewController ()

@end

@implementation ToxFriendViewController

@synthesize displayedFriend = _displayedFriend;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"StartChat"]) {
        ToxChatViewController *destinationController = segue.destinationViewController;
        destinationController.toxFriend = self.displayedFriend;
    }
}

@end
