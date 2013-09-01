//
//  ToxChatViewController.h
//  InToxicate
//
//  Created by Christoph Krautz on 29.08.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ToxNewMessageViewController.h"

#import "ToxFriend.h"

@interface ToxChatViewController : UITableViewController<ToxNewMessageViewDelegate>
@property (strong, nonatomic) ToxFriend *toxFriend;
@end
