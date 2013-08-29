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
    
    self.userName.delegate = self;
    self.userName.text = _messenger.name;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [self.userName resignFirstResponder];
    self.messenger.name = self.userName.text;
    [self.navigationController popViewControllerAnimated:YES];
    return YES;
}
@end
