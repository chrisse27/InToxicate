//
//  ToxNewMessageViewController.h
//  InToxicate
//
//  Created by Christoph Krautz on 01.09.13.
//  Copyright (c) 2013 Neuronics. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToxNewMessageViewDelegate <NSObject>

- (void)sendMessage:(NSString *)message;

@end

@interface ToxNewMessageViewController : UIViewController
@property (assign, nonatomic) id<ToxNewMessageViewDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *txtMessage;

- (IBAction)sendMessage:(UIButton *)sender;
@end
