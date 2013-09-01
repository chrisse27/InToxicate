//
//  ToxNewMessageViewController.m
//  InToxicate
//
//  Created by Christoph Krautz on 01.09.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import "ToxNewMessageViewController.h"

@interface ToxNewMessageViewController ()

@end

@implementation ToxNewMessageViewController

@synthesize delegate = _delegate;
@synthesize txtMessage = _txtMessage;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)sendMessage:(UIButton *)sender
{
    [self.delegate sendMessage:self.txtMessage.text];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
