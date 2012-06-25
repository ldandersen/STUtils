//
//  STLoginViewController.h
//
//  Created by Buzz Andersen on 3/30/11.
//  Copyright 2011 System of Touch. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person
//  obtaining a copy of this software and associated documentation
//  files (the "Software"), to deal in the Software without
//  restriction, including without limitation the rights to use,
//  copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the
//  Software is furnished to do so, subject to the following
//  conditions:
//
//  The above copyright notice and this permission notice shall be
//  included in all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
//  EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
//  OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
//  OTHER DEALINGS IN THE SOFTWARE.
//

#import <UIKit/UIKit.h>


extern NSString *STLoginViewControllerErrorDomain;
extern NSInteger STLoginViewControllerNoUsernameError;
extern NSInteger STLoginViewControllerNoPasswordError;


@class STEditableTableViewCell;


@interface STLoginViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
    STEditableTableViewCell *usernameCell;
    STEditableTableViewCell *passwordCell;
    UILabel *statusLabel;
	UIActivityIndicatorView *statusIndicator;
    NSString *username;
    NSString *password;
	NSString *idleStatusMessage;
	NSString *activeStatusMessage;
    BOOL showsCancelButton;
    BOOL indicatingActivity;
    BOOL usernameIsEmail;
    BOOL loggingIn;
}

@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) BOOL showsCancelButton;
@property (nonatomic, retain) NSString *idleStatusMessage;
@property (nonatomic, retain) NSString *activeStatusMessage;
@property (nonatomic, assign, getter=isIndicatingActivity) BOOL indicatingActivity;
@property (nonatomic, assign) BOOL usernameIsEmail;
@property (nonatomic, assign, getter=isLoggingIn) BOOL loggingIn;

// Initialization
- (id)initWithUsername:(NSString *)inUsername showCancelButton:(BOOL)inShowCancelButton;

// Login Actions
- (void)dismiss;
- (void)login;
- (NSError *)verifyCredentials;

@end
