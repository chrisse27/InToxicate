//
//  ToxViewController.h
//  InToxicate
//
//  Created by Christoph Krautz on 12.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UITableView.h>

#import "ToxAddNewFriendViewController.h"
#import "ToxFriendRequestViewController.h"

@interface ToxViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, ToxFriendRequestViewDelegate, ToxAddNewFriendViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtPublicKey;
@property (weak, nonatomic) IBOutlet UITableView *friendList;

@end
