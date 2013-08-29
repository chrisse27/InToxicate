//
//  ToxAddNewFriendViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxAddNewFriendViewController.h"

#import "NSString+HexToData.h"

@interface ToxAddNewFriendViewController ()

@end

@implementation ToxAddNewFriendViewController

@synthesize delegate = _delegate;
@synthesize messenger = _messenger;

- (void)setMessenger:(ToxMessenger *)messenger
{
    _messenger = messenger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtUserId.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.txtUserId resignFirstResponder];
    NSString *userId = self.txtUserId.text;
    NSData *userIdData = [userId hexToData];
    ToxFriend *friend = [self.messenger addFriendWithUserId:(uint8_t *)[userIdData bytes]];
    [self.delegate addedNewFriend:friend];
    [self.navigationController popViewControllerAnimated:YES];
    
    return YES;
}

@end
