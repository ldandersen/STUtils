//
//  NSDate+STAdditions.h
//
//  Created by Buzz Andersen on 12/29/09.
//  Copyright 2012 System of Touch. All rights reserved.
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

#import <Foundation/Foundation.h>
#include "time.h"


@interface NSDate (STAdditions)

@property (nonatomic, readonly) NSInteger century;
@property (nonatomic, readonly) NSInteger decade;
@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;

// Convenience Date Creation Methods
+ (NSDate *)dateWithCTimeStruct:(time_t)inTimeStruct;

// Convenience Date Formatter Methods
+ (NSDateFormatter *)ISO8601DateFormatterConfiguredForTimeZone:(NSTimeZone *)inTimeZone supportingFractionalSeconds:(BOOL)inSupportFractionalSeconds;

// Fixed String Parsing
+ (NSDate *)dateFromISO8601String:(NSString *)inDateString;
+ (NSDate *)dateFromISO8601String:(NSString *)inDateString timeZone:(NSTimeZone *)inTimeZone supportingFractionalSeconds:(BOOL)inSupportFractionalSeconds;

// Convenience String Formatting Methods
- (NSString *)timeIntervalSince1970String;
- (NSString *)timeString;
- (NSString *)dayOfWeekString;
- (NSString *)veryShortDateString;
- (NSString *)shortDateString;
- (NSString *)longDateString;
- (NSString *)veryLongDateString;
- (NSString *)SMSStyleDateString;
- (NSString *)relativeDateString;

// HTTP Dates
- (NSString *)HTTPTimeZoneHeaderString;
- (NSString *)HTTPTimeZoneHeaderStringForTimeZone:(NSTimeZone *)inTimeZone;
- (NSString *)ISO8601String;
- (NSString *)ISO8601StringForLocalTimeZone;
- (NSString *)ISO8601StringForTimeZone:(NSTimeZone *)inTimeZone;
- (NSString *)ISO8601StringForTimeZone:(NSTimeZone *)inTimeZone usingFractionalSeconds:(BOOL)inUseFractionalSeconds;

@end
