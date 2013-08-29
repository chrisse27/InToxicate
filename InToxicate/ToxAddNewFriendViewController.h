//
//  ToxAddNewFriendViewController.h
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ToxMessenger.h"

@protocol ToxAddNewFriendViewDelegate <NSObject>

- (void)addedNewFriend:(ToxFriend *)toxFriend;

@end

@interface ToxAddNewFriendViewController : UIViewController <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;
@property (weak, nonatomic) ToxMessenger *messenger;

@property (assign, nonatomic) id<ToxAddNewFriendViewDelegate> delegate;
@end
