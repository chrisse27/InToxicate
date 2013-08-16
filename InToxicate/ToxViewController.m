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

@interface ToxViewController ()
@property ToxMessenger *messenger;
@end

@implementation ToxViewController

@synthesize messenger = _messenger;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.messenger = [ToxAppDelegate messenger];
    self.txtPublicKey.text = self.messenger.publicKey;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
