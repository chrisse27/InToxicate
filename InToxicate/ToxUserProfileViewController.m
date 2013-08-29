//
//  ToxUserProfileViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxUserProfileViewController.h"

@interface ToxUserProfileViewController ()

@end

@implementation ToxUserProfileViewController

@synthesize messenger = _messenger;

- (void)setMessenger:(ToxMessenger *)messenger
{
    _messenger = messenger;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.txtUserName.delegate = self;
    self.txtUserName.text = _messenger.name;
    
    self.txtUserId.text = self.messenger.personalId;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.txtUserName resignFirstResponder];
    self.messenger.name = self.txtUserName.text;
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
@end
