//
//  NSDate+STAdditions.m
//
//  Created by Buzz Andersen on 12/29/09.
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


static NSCalendar *gregorianCalendar;
static NSDateFormatter *dayOfWeekOnlyFormatter;
static NSDateFormatter *timeOnlyFormatter;
static NSDateFormatter *veryShortDateFormatter;
static NSDateFormatter *shortDateFormatter;
static NSDateFormatter *longDateFormatter;
static NSDateFormatter *veryLongDateFormatter;


@implementation NSDate (STAdditions)

#pragma mark Convenience Date Creation Methods

+ (NSDate *)dateWithCTimeStruct:(time_t)inTimeStruct;
{
    // Convert the time_t to a UTC tm struct
    struct tm* UTCDateStruct = gmtime(&(inTimeStruct));
    
    // Convert the tm struct to date components
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setSecond:UTCDateStruct->tm_sec];
    [dateComponents setMinute:UTCDateStruct->tm_min];
    [dateComponents setHour:UTCDateStruct->tm_hour];
    [dateComponents setDay:UTCDateStruct->tm_mday];
    [dateComponents setMonth:UTCDateStruct->tm_mon + 1];
    [dateComponents setYear:UTCDateStruct->tm_year + 1900];
    
    // Use the date components to create an NSDate object
    NSDate *newDate = [[[NSCalendar currentCalendar] dateFromComponents:dateComponents] dateByAddingTimeInterval:[[NSTimeZone systemTimeZone] secondsFromGMT]];    
    [dateComponents release];

    return newDate;
}

#pragma mark Accessors

- (NSInteger)century;
{
    NSInteger currentYear = self.year;
    NSString *yearStr = [[NSNumber numberWithInteger:currentYear] stringValue];
    
    // in this case, the year is < 100, such as 0 to 99, making it the "0" century
    if (yearStr.length < 3) {
        return 0;
    }
    
    // strip the year off the date
    return [[[yearStr substringToIndex:(yearStr.length - 2)] stringByAppendingString:@"00"] integerValue];
}

- (NSInteger)decade;
{
    // First, get the century - year
    NSInteger decade = self.year - self.century;
    
    // this will give us 09 in the case of 2009.  Round down the whole number
    return (decade / 10) * 10;
}

- (NSInteger)year;
{
    return [[[NSCalendar currentCalendar] components:NSYearCalendarUnit fromDate:self] year];
}

- (NSInteger)month;
{
    return [[[NSCalendar currentCalendar] components:NSMonthCalendarUnit fromDate:self] month];
}

#pragma mark Convenience String Formatting Methods

- (NSString *)timeIntervalSince1970String;
{
    return [NSString stringWithFormat:@"%f", [self timeIntervalSince1970]];
}

- (NSString *)timeString;
{
	if (!timeOnlyFormatter) {
        timeOnlyFormatter = [[NSDateFormatter alloc] init];
        [timeOnlyFormatter setDateStyle:NSDateFormatterNoStyle];
        [timeOnlyFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
	return [timeOnlyFormatter stringFromDate:self];
}

- (NSString *)dayOfWeekString;
{
	if (!dayOfWeekOnlyFormatter) {
        dayOfWeekOnlyFormatter = [[NSDateFormatter alloc] init];
        [dayOfWeekOnlyFormatter setDateFormat:@"EEEE"];
    }
    
    return [dayOfWeekOnlyFormatter stringFromDate:self];
}

- (NSString *)veryShortDateString;
{
    if (!veryShortDateFormatter) {
        veryShortDateFormatter = [[NSDateFormatter alloc] init];
        [veryShortDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [veryShortDateFormatter setTimeStyle:NSDateFormatterNoStyle];
    }
    
    return [veryShortDateFormatter stringFromDate:self];
}

- (NSString *)shortDateString;
{
    if (!shortDateFormatter) {
        shortDateFormatter = [[NSDateFormatter alloc] init];
        [shortDateFormatter setDateStyle:NSDateFormatterShortStyle];
        [shortDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return [shortDateFormatter stringFromDate:self];
}

- (NSString *)longDateString;
{
    if (!longDateFormatter) {
        longDateFormatter = [[NSDateFormatter alloc] init];
        [longDateFormatter setDateStyle:NSDateFormatterLongStyle];
        [longDateFormatter setTimeStyle:NSDateFormatterShortStyle];
    }
    
    return [longDateFormatter stringFromDate:self];
}

- (NSString *)veryLongDateString;
{
    if (!veryLongDateFormatter) {
        longDateFormatter = [[NSDateFormatter alloc] init];
        [longDateFormatter setDateStyle:NSDateFormatterLongStyle];
        [longDateFormatter setTimeStyle:NSDateFormatterLongStyle];        
    }
    
    return [veryLongDateFormatter stringFromDate:self];
}

- (NSString *)SMSStyleDateString;
{
    if (!gregorianCalendar) {
        gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
    
    NSUInteger unitFlags = NSDayCalendarUnit;
	
	NSDateComponents *comparisonComponents = [gregorianCalendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];
	NSInteger daysBetween = [comparisonComponents day];
    
	NSDateComponents *components = [gregorianCalendar components:unitFlags fromDate:self];
	NSDateComponents *nowComponents = [gregorianCalendar components:unitFlags fromDate:[NSDate date]];
	
	NSUInteger day = [components day];
	NSUInteger nowDay = [nowComponents day];
	
	NSString *dateString;
	
	if (day == nowDay) {
		return [self timeString];
	}
	else if (daysBetween < 2) {
		return NSLocalizedString(@"Yesterday", @"");
	}
	else if (daysBetween < 8) {
		return [self dayOfWeekString];
	}
	else {
		return [self veryShortDateString];
	}
	
	return dateString;
}

- (NSString *)relativeDateString;
{
    if (!gregorianCalendar) {
        gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    }
	
    NSUInteger unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
	NSDateComponents *components = [gregorianCalendar components:unitFlags fromDate:self toDate:[NSDate date] options:0];
	NSInteger days = [components day];
	NSInteger hours = [components hour];
	NSInteger minutes = [components minute];
	NSInteger seconds = [components second];
	
	NSString *timeText;
	
	if (days >= 1) {
		timeText = [self veryShortDateString];
	}
	else if (hours == 1) {
		timeText = [NSString stringWithFormat:@"%d hour", hours];			
	}
	else if (hours >= 1) {
		timeText = [NSString stringWithFormat:@"%d hours", hours];	
	}
	else if (minutes == 1) {
		timeText = [NSString stringWithFormat:@"%d minute", minutes];			
	}
	else if (minutes > 1) {
		timeText = [NSString stringWithFormat:@"%d minutes", minutes];			
	}
	else {
		if (seconds < 0) {
			timeText = @"< 1 minute";
		}
		else {
			timeText = [NSString stringWithFormat:@"%d seconds", seconds];
		}
	}
	
	return timeText;    
}

- (NSString *)HTTPTimeZoneHeaderString;
{
    return [self HTTPTimeZoneHeaderStringForTimeZone:nil];
}

- (NSString *)HTTPTimeZoneHeaderStringForTimeZone:(NSTimeZone *)inTimeZone;
{
    NSTimeZone *timeZone = inTimeZone ? inTimeZone : [NSTimeZone localTimeZone];
    NSString *dateString = [self ISO8601StringForTimeZone:timeZone];
    NSString *timeZoneHeader = [NSString stringWithFormat:@"%@;;%@", dateString, [timeZone name]];
    return timeZoneHeader;
}

- (NSString *)ISO8601String;
{
    return [self ISO8601StringForTimeZone:nil];
}

- (NSString *)ISO8601StringForTimeZone:(NSTimeZone *)inTimeZone;
{
    if (!inTimeZone) {
        inTimeZone = [NSTimeZone localTimeZone];
    }
    
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = [self timeIntervalSince1970] - [inTimeZone secondsFromGMT];
    timeinfo = localtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%S%z", timeinfo);

    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
    
}

@end
