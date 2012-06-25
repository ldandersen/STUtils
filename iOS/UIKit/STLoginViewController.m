//
//  STLoginViewController.m
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

#import "STUtils.h"


// Constants
#define STLoginViewControllerLoginFormTopPadding 10
#define STLoginViewControllerLoginFormHeight 100
#define STLoginViewControllerStatusAreaIndicatorPadding 8
#define STLoginViewControllerStatusAreaHeight 90

NSString *STLoginViewControllerErrorDomain = @"STLoginViewControllerErrorDomain";
NSInteger STLoginViewControllerNoUsernameError = 1000;
NSInteger STLoginViewControllerNoPasswordError = 1001;
NSInteger STLoginViewControllerInvalidEmailError = 1002;

// Constants
enum {
    UsernameRow,
    PasswordRow,
    RowCount
};


@interface STLoginViewController ()

@property (nonatomic, retain) STEditableTableViewCell *usernameCell;
@property (nonatomic, retain) STEditableTableViewCell *passwordCell;
@property (nonatomic, retain) UILabel *statusLabel;
@property (nonatomic, retain) UIActivityIndicatorView *statusIndicator;

- (void)_resizeStatusLabel;
- (void)_configureUsernameCell;
- (void)_updateFieldTextFromUsernameAndPassword;
- (void)_updateUsernameAndPasswordFromFields;
- (void)_updateActivityStatus;
- (void)_updateLoginButton;

@end


@implementation STLoginViewController

@synthesize tableView;
@synthesize usernameCell;
@synthesize passwordCell;
@synthesize statusLabel;
@synthesize statusIndicator;
@synthesize showsCancelButton;
@synthesize username;
@synthesize password;
@synthesize idleStatusMessage;
@synthesize activeStatusMessage;
@synthesize usernameIsEmail;
@synthesize loggingIn;
@synthesize indicatingActivity;

#pragma mark Initialization

- (id)initWithUsername:(NSString *)inUsername showCancelButton:(BOOL)inShowCancelButton;
{
    if (!(self = [super initWithNibName:nil bundle:nil])) {
        return nil;
    }

    self.username = inUsername;
    self.showsCancelButton = inShowCancelButton;
    self.loggingIn = NO;
    self.activeStatusMessage = STLocalizedString(@"Signing in...");
    
    return self;
}

- (void)dealloc;
{
    self.tableView = nil;
    self.usernameCell = nil;
    self.passwordCell = nil;
    self.statusLabel = nil;
    self.statusIndicator = nil;
    self.username = nil;
    self.password = nil;
    self.idleStatusMessage = nil;
    self.activeStatusMessage = nil;
    
    [super dealloc];
}

#pragma mark Accessors

- (void)setUsername:(NSString *)inUsername;
{
    [inUsername retain];
    [username release];
    username = inUsername;

    [self _updateFieldTextFromUsernameAndPassword];
}

- (void)setPassword:(NSString *)inPassword;
{
    [inPassword retain];
    [password release];
    password = inPassword;
    
    [self _updateFieldTextFromUsernameAndPassword];
}

- (void)setUsernameIsEmail:(BOOL)inUsernameIsEmail;
{
    usernameIsEmail = inUsernameIsEmail;
    [self _configureUsernameCell];
}

- (void)setShowsCancelButton:(BOOL)inShowsCancelButton;
{
    showsCancelButton = inShowsCancelButton;
    
	if (inShowsCancelButton) {
        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action: @selector(dismiss)];
		self.navigationItem.leftBarButtonItem = cancelButton;
		[cancelButton release];		
	} else {
		self.navigationItem.leftBarButtonItem = nil;
	}
}

- (UITableViewCell *)usernameCell;
{
    if (!usernameCell) {
        usernameCell = [[STEditableTableViewCell alloc] initWithDelegate:self];
        usernameCell.editableField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        usernameCell.editableField.autocorrectionType = UITextAutocorrectionTypeNo;
        [usernameCell.editableField addTarget:self action:@selector(_updateUsernameAndPasswordFromFields) forControlEvents:UIControlEventEditingChanged];
        
        [self _configureUsernameCell];
    }
    
    return usernameCell;
}

- (UITableViewCell *)passwordCell;
{
    if (!passwordCell) {
        passwordCell = [[STEditableTableViewCell alloc] initWithDelegate:self];
        passwordCell.descriptionLabel.text = STLocalizedString(@"Password");
		passwordCell.editableField.autocapitalizationType = UITextAutocapitalizationTypeNone;
		passwordCell.editableField.autocorrectionType = UITextAutocorrectionTypeNo;
		passwordCell.editableField.secureTextEntry = YES;
        [usernameCell.editableField addTarget:self action:@selector(_updateUsernameAndPasswordFromFields) forControlEvents:UIControlEventEditingChanged];
    }
    
    return passwordCell;
}

- (void)setLoggingIn:(BOOL)inLoggingIn;
{
    loggingIn = inLoggingIn;
    self.indicatingActivity = inLoggingIn;
    [self _updateLoginButton];
}

- (void)setIdleStatusMessage:(NSString *)inIdleStatusMessage;
{
    [inIdleStatusMessage retain];
    [idleStatusMessage release];
    idleStatusMessage = inIdleStatusMessage;
    
    [self _updateActivityStatus];
}

- (void)setIndicatingActivity:(BOOL)inIndicatingActivity;
{
    indicatingActivity = inIndicatingActivity;
    [self _updateActivityStatus];
}

#pragma mark Login Actions

- (void)dismiss;
{
    self.loggingIn = NO;
	[self.presentingViewController dismissModalViewControllerAnimated:YES];
}

- (void)login;
{
    self.loggingIn = YES;
    [self _updateUsernameAndPasswordFromFields];
    return;
}

- (NSError *)verifyCredentials;
{	
	NSString *errorString = nil;
    NSInteger errorCode = 0;
	
	if (!self.username.length) {
		errorString = STLocalizedString(@"Please enter a username");
        errorCode = STLoginViewControllerNoUsernameError;
	} else if (!self.password.length) {
		errorString = STLocalizedString(@"Please enter a password");		
        errorCode = STLoginViewControllerNoPasswordError;
	} else if (self.usernameIsEmail && ![self.username isEmailAddress]) {
        errorString = STLocalizedString(@"Email is not a valid address");
        errorCode = STLoginViewControllerInvalidEmailError;
    }
    
    NSError *error = nil;
	
	if (errorString) {
        NSDictionary *userInfo = [NSDictionary dictionaryWithObject:errorString forKey:NSLocalizedDescriptionKey];
        error = [NSError errorWithDomain:STLoginViewControllerErrorDomain code:errorCode userInfo:userInfo];
	}	
	
	return error;
}

#pragma mark View Lifecycle

- (void)loadView;
{
	CGRect viewRect = [[UIScreen mainScreen] applicationFrame];
	UIView *loginView = [[UIView alloc] initWithFrame:viewRect];
	loginView.backgroundColor = [UIColor groupTableViewBackgroundColor];
	self.view = loginView;
}

- (void)viewDidLoad;
{
    [super viewDidLoad];
    	
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:STLocalizedString(@"Sign In") style:UIBarButtonItemStyleDone target:self action:@selector(login)];
	self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
    
    CGRect viewRect = self.view.bounds;
	CGFloat statusBarHeight = /*[[UIApplication sharedApplication] statusBarFrame].size.height*/ 0.0;
    
    CGRect navBarRect = CGRectMake(viewRect.origin.x, viewRect.origin.y - statusBarHeight, viewRect.size.width, STDefaultNavBarHeight);
	UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:navBarRect];
	[navBar pushNavigationItem: self.navigationItem animated: YES];
	[self.view addSubview:navBar];    
    [navBar release];
    
    CGRect tableRect = CGRectMake(viewRect.origin.x, navBarRect.origin.y + navBarRect.size.height + STLoginViewControllerLoginFormTopPadding, viewRect.size.width, STLoginViewControllerLoginFormHeight);
    
	self.tableView = [[UITableView alloc] initWithFrame:tableRect style:UITableViewStyleGrouped];
	self.tableView.dataSource = self;
	self.tableView.delegate = self;
	self.tableView.backgroundColor = [UIColor clearColor];
	self.tableView.opaque = NO;
	self.tableView.bounces = NO;
	[self.view addSubview:self.tableView];
	[self.tableView release];
    
	UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	self.statusIndicator = activityIndicator;
	[self.view addSubview:activityIndicator];
	[activityIndicator release];
	
	UILabel *statusTextLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	statusTextLabel.font = [UIFont systemFontOfSize:14.0];
	statusTextLabel.textColor = [UIColor colorWithRed: 31.0/256.0 green: 40.0/256.0 blue: 57.0/256.0 alpha: 1.0];
	statusTextLabel.shadowColor = [UIColor colorWithRed: 255.0 green: 255.0 blue: 255.0 alpha: 0.5];
	statusTextLabel.shadowOffset = CGSizeMake(0, 1);
	statusTextLabel.backgroundColor = [UIColor clearColor];
	self.statusLabel = statusTextLabel;
	[self.view addSubview:statusTextLabel];
	[statusTextLabel release];
    
    [self _updateFieldTextFromUsernameAndPassword];
    [self _updateLoginButton];
    
	if (self.username) {
		[self.passwordCell.editableField becomeFirstResponder];		
	}
	else {
		[self.usernameCell.editableField becomeFirstResponder];
	}
}

- (void)didReceiveMemoryWarning;
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload;
{
	self.tableView = nil;
	self.statusLabel = nil;
	self.statusIndicator = nil;
	self.usernameCell = nil;
	self.passwordCell = nil;
    
    [super viewDidUnload];
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)inTableView;
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)inTableView numberOfRowsInSection:(NSInteger)section;
{
	return 2;
}

- (UITableViewCell *)tableView:(UITableView *)inTableView cellForRowAtIndexPath:(NSIndexPath *)inIndexPath;
{
	UITableViewCell *cell;
	
	if (inIndexPath.row == PasswordRow) {
		cell = self.passwordCell;
	}
	else {
		cell = self.usernameCell;
        cell.detailTextLabel.text = self.username;
	}
	
    return cell;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == PasswordRow) {
        [self.passwordCell.editableField becomeFirstResponder];
    } else {
        [self.usernameCell.editableField becomeFirstResponder];
    }
    
    return nil;
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{
    [self performSelectorOnRunloopCycle:@selector(_updateUsernameAndPasswordFromFields)];
    return YES;
}

#pragma mark Private Methods

- (void) _resizeStatusLabel;
{
	[self.statusIndicator sizeToFit];
	[self.statusLabel sizeToFit];
    
    CGRect statusIndicatorBounds = CGRectZero;
    
    if (indicatingActivity) {
        statusIndicatorBounds = self.statusIndicator.bounds;
    }
    
    CGRect statusLabelBounds = self.statusLabel.bounds;
    
    CGFloat maxHeight = statusLabelBounds.size.height > statusIndicatorBounds.size.height ? statusLabelBounds.size.height : statusIndicatorBounds.size.height;
    CGFloat maxWidth = statusIndicatorBounds.size.width + statusLabelBounds.size.width;
    
    CGFloat indicatorPadding = indicatingActivity ? STLoginViewControllerStatusAreaIndicatorPadding : 0.0;
    
    CGSize combinedStatusSize = CGSizeMake(maxWidth + indicatorPadding, maxHeight);
    
    CGRect viewBounds = self.view.bounds;
    CGRect tableViewBounds = self.tableView.bounds;
    
    CGRect statusArea = [self.view centeredSubRectOfSize:combinedStatusSize insideRect:CGRectMake(viewBounds.origin.x, viewBounds.origin.y + + STDefaultNavBarHeight + tableViewBounds.size.height, viewBounds.size.width, STLoginViewControllerStatusAreaHeight)];
    
    CGRect indicatorFrame = CGRectMake(statusArea.origin.x, statusArea.origin.y, statusIndicatorBounds.size.width, statusIndicatorBounds.size.width);
    CGRect labelFrame = CGRectMake(statusArea.origin.x + indicatorFrame.size.width + indicatorPadding, statusArea.origin.y, statusLabelBounds.size.width, statusLabelBounds.size.height);
    
    self.statusIndicator.frame = indicatorFrame;
    self.statusLabel.frame = labelFrame;
}

- (void)_configureUsernameCell;
{
    if (!usernameCell) {
        return;
    }
    
    usernameCell.editableField.placeholder = self.usernameIsEmail ? STLocalizedString(@"email@domain.com") : nil;
    usernameCell.descriptionLabel.text = self.usernameIsEmail ? STLocalizedString(@"Email") : STLocalizedString(@"Username");
}

- (void)_updateUsernameAndPasswordFromFields;
{
    NSString *newUsername = self.usernameCell.editableField.text;
    [newUsername retain];
    [username release];
    username = newUsername;
    
    NSString *newPassword = self.passwordCell.editableField.text;
    [newPassword retain];
    [password release];
    password = newPassword;
    
    [self _updateLoginButton];
}

- (void)_updateFieldTextFromUsernameAndPassword;
{
    self.passwordCell.editableField.text = self.password;
    self.usernameCell.editableField.text = self.username;
}

- (void)_updateActivityStatus;
{
    if (indicatingActivity) {
        self.statusLabel.text = self.activeStatusMessage;
        self.statusIndicator.hidden = NO;
        [self.statusIndicator startAnimating];
    } else {
        [self.statusIndicator stopAnimating];
        
        NSString *idleMessage = self.idleStatusMessage;
        
        if (idleMessage.length) {
            self.statusLabel.text = idleMessage;
        } else {
            self.statusIndicator.hidden = YES; 
        }
    }
    
    [self _resizeStatusLabel];
}

- (void)_updateLoginButton;
{
    self.navigationItem.rightBarButtonItem.enabled = !self.isLoggingIn && (self.username.length && self.password.length);
    
}

@end
