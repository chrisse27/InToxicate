//
//  ToxUserProfileViewController.h
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ToxMessenger.h"

@interface ToxUserProfileViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) ToxMessenger *messenger;

@property (weak, nonatomic) IBOutlet UITextField *txtUserName;
@property (weak, nonatomic) IBOutlet UITextField *txtUserId;

@end
