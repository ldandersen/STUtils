//
//  STEditableTableViewCell.m
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


@interface STEditableTableViewCell ()

@property (nonatomic, retain) UILabel *descriptionLabel;
@property (nonatomic, retain) UITextField *editableField;

@end


@implementation STEditableTableViewCell

@synthesize descriptionLabel;
@synthesize editableField;

#pragma mark Initialization

- (id)initWithDelegate:(id)inDelegate;
{
    if (!(self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil])) {
        return nil;
	}
    
    self.accessoryType = UITableViewCellAccessoryNone;

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.font = [UIFont boldSystemFontOfSize: 16.0];
    label.textColor = [UIColor darkTextColor];
    label.backgroundColor = [UIColor clearColor];
    self.descriptionLabel = label;
    [self addSubview:label];
    [label release];
    
    UITextField *entryField = [[UITextField alloc] initWithFrame:CGRectZero];
    entryField.textColor = [UIColor blackColor];
    entryField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    entryField.font = [UIFont systemFontOfSize:16.0];
    entryField.delegate = inDelegate;
    self.editableField = entryField;
    [self addSubview:entryField];
    [entryField release];
    
	return self;
}

- (void)dealloc;
{
    self.descriptionLabel = nil;
    self.editableField = nil;
    [super dealloc];
}

#pragma mark Accessors

- (void)setDelegate:(id)inDelegate;
{
    if (!editableField) {
        return;
    }
    
    self.editableField.delegate = inDelegate;
}

- (id)delegate;
{
    if (!editableField) {
        return nil;
    }
    
    return self.editableField.delegate;
}

- (void)layoutSubviews;
{
	[super layoutSubviews];
    
    [self.descriptionLabel sizeToFit];
	self.descriptionLabel.frame = CGRectMake(self.contentView.bounds.origin.x + 20, self.contentView.bounds.origin.y + 13, self.descriptionLabel.frame.size.width, self.descriptionLabel.frame.size.height);
	
    self.editableField.frame = CGRectMake(self.descriptionLabel.frame.origin.x + self.descriptionLabel.frame.size.width + 11, self.contentView.bounds.origin.y + 1, self.contentView.bounds.size.width - self.descriptionLabel.frame.size.width - 40, self.contentView.bounds.size.height);
}

@end
