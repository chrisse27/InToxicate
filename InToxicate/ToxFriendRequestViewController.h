//
//  ToxFriendRequestViewController.h
//  InToxicate
//
//  Created by Christoph Krautz on 27.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ToxFriendRequest.h"

@protocol ToxFriendRequestViewDelegate <NSObject>

- (void)requested:(ToxFriendRequest *)request AcceptedBy:(id)sender;

@end

@interface ToxFriendRequestViewController : UIViewController
@property (nonatomic, strong) ToxFriendRequest *friendRequest;
@property (weak, nonatomic) IBOutlet UITextField *friendId;
@property (nonatomic, assign) id<ToxFriendRequestViewDelegate> delegate;

- (IBAction)acceptRequest:(id)sender;
@end
