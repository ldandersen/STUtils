//
//  NSString+STAdditions.m
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

#import <CommonCrypto/CommonDigest.h>

@implementation NSString (STAdditions)

#pragma mark Paths

- (NSString *)stringByRemovingLastPathComponent;
{
    NSArray *pathComponents = [self pathComponents];
    NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
    
    NSString *lastComponent = [pathComponents lastObject];
    for (NSString *currentComponent in pathComponents) {
        if (currentComponent == lastComponent) {
            break;
        }
        
        [returnString appendPathComponent:currentComponent];
    }
    
    return returnString;
}

- (NSString *)stringWithPathComponents:(NSArray *)inPathComponents;
{
    if (!inPathComponents.count) {
        return nil;
    }
    
    NSMutableString *fullPathString = [[[NSMutableString alloc] init] autorelease];
    
    for (NSString *currentPathComponent in inPathComponents) {
        [fullPathString appendPathComponent:currentPathComponent];
    }
    
    return fullPathString;
}

#pragma mark URL Escaping

- (NSString *)stringByEscapingQueryParameters;
{
    return [(NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)self, NULL, CFSTR("!*'();:@&=+$,/?%#[]%"), kCFStringEncodingUTF8) autorelease];
}

- (NSString *)stringByReplacingPercentEscapes;
{
    return [(NSString*)CFURLCreateStringByReplacingPercentEscapes(NULL, (CFStringRef)self, CFSTR("")) autorelease];
}

#pragma mark Templating

- (NSString *)stringByParsingTagsWithStartDelimeter:(NSString *)inStartDelimiter endDelimeter:(NSString *)inEndDelimiter usingObject:(id)object;
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableString *result = [[[NSMutableString alloc] init] autorelease];
    
    [scanner setCharactersToBeSkipped:nil];
    
    while (![scanner isAtEnd]) {
        NSString *tag;
        NSString *beforeText;
        
        if ([scanner scanUpToString:inStartDelimiter intoString:&beforeText]) {
            [result appendString:beforeText];
        }
        
        if ([scanner scanString:inStartDelimiter intoString:nil]) {
            if ([scanner scanString:inEndDelimiter intoString:nil]) {
                continue;
            } else if ([scanner scanUpToString:inEndDelimiter intoString:&tag] && [scanner scanString:inEndDelimiter intoString:nil]) {
                id keyValue = [object valueForKeyPath:[tag stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
                if (keyValue != nil) {
                    [result appendFormat:@"%@", keyValue];
                }
            }
        }
    }
    
    return result;    
}

#pragma mark HTML Entities

- (NSString *)stringByReplacingHTMLEntities;
{
	NSRange range = NSMakeRange(0, [self length]);
	NSRange subrange = [self rangeOfString:@"&" options:NSBackwardsSearch range:range];
    
	// if no ampersands, we've got a quick way out
	if (subrange.length == 0) return self;
	NSMutableString *finalString = [NSMutableString stringWithString:self];
	do {
		NSRange semiColonRange = NSMakeRange(subrange.location, NSMaxRange(range) - subrange.location);
		semiColonRange = [self rangeOfString:@";" options:0 range:semiColonRange];
		range = NSMakeRange(0, subrange.location);
		// if we don't find a semicolon in the range, we don't have a sequence
		if (semiColonRange.location == NSNotFound) {
			continue;
		}
		NSRange escapeRange = NSMakeRange(subrange.location, semiColonRange.location - subrange.location + 1);
		NSString *escapeString = [self substringWithRange:escapeRange];
		NSUInteger length = [escapeString length];
		// a squence must be longer than 3 (&lt;) and less than 11 (&thetasym;)
		if (length > 3 && length < 11) {
			if ([escapeString characterAtIndex:1] == '#') {
				unichar char2 = [escapeString characterAtIndex:2];
				if (char2 == 'x' || char2 == 'X') {
					// Hex escape squences &#xa3;
					NSString *hexSequence = [escapeString substringWithRange:NSMakeRange(3, length - 4)];
					NSScanner *scanner = [NSScanner scannerWithString:hexSequence];
					unsigned value;
					if ([scanner scanHexInt:&value] && 
						value < USHRT_MAX &&
						value > 0 
						&& [scanner scanLocation] == length - 4) {
						unichar uchar = value;
						NSString *charString = [NSString stringWithCharacters:&uchar length:1];
						[finalString replaceCharactersInRange:escapeRange withString:charString];
					}
                    
				} else {
					// Decimal Sequences &#123;
					NSString *numberSequence = [escapeString substringWithRange:NSMakeRange(2, length - 3)];
					NSScanner *scanner = [NSScanner scannerWithString:numberSequence];
					int value;
					if ([scanner scanInt:&value] && 
						value < USHRT_MAX &&
						value > 0 
						&& [scanner scanLocation] == length - 3) {
						unichar uchar = value;
						NSString *charString = [NSString stringWithCharacters:&uchar length:1];
						[finalString replaceCharactersInRange:escapeRange withString:charString];
					}
				}
			} else {
				// "standard" sequences
                NSString *truncatedString = [escapeString substringWithRange:NSMakeRange(1, length-2)];
                NSString *translatedEntity = [[NSBundle mainBundle] localizedStringForKey:truncatedString value:escapeString table:@"entities"];
                if (translatedEntity) {
                    [finalString replaceCharactersInRange:escapeRange withString:translatedEntity];
                }
			}
		}
	} while ((subrange = [self rangeOfString:@"&" options:NSBackwardsSearch range:range]).length != 0);
	return finalString;
} 

#pragma mark Hashes

- (NSString *)MD5String;
{
	const char *string = [self UTF8String];
	unsigned char md5_result[16];
	CC_MD5(string, [self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], md5_result);
    
	return [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            md5_result[0], md5_result[1], md5_result[2], md5_result[3], 
            md5_result[4], md5_result[5], md5_result[6], md5_result[7],
            md5_result[8], md5_result[9], md5_result[10], md5_result[11],
            md5_result[12], md5_result[13], md5_result[14], md5_result[15]];	
}

#pragma mark Encoding

- (NSString *)base58String;
{
	long long num = strtoll([self UTF8String], NULL, 10);
	
	NSString *alphabet = @"123456789abcdefghijkmnopqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ";
	
	int baseCount = [alphabet length];
	
	NSString *encoded = @"";
	
	while (num >= baseCount) {
		double div = num / baseCount;
		long long mod = (num - (baseCount * (long long)div));
		NSString *alphabetChar = [alphabet substringWithRange: NSMakeRange(mod, 1)];
		encoded = [NSString stringWithFormat: @"%@%@", alphabetChar, encoded];
		num = (long long)div;
	}
    
	if (num) {
		encoded = [NSString stringWithFormat:@"%@%@", [alphabet substringWithRange:NSMakeRange(num, 1)], encoded];
	}
    
	return encoded;	
}

- (NSString *)base64String;
{
    NSData *stringData = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [stringData base64EncodedString];
}

#pragma mark UUIDs

+ (NSString *)UUIDString;
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *string = (NSString *)CFUUIDCreateString(NULL, uuid);
    CFRelease(uuid);
    
    return [string autorelease];
}

#pragma mark Dates

- (NSDate *)dateValueWithMillisecondsSince1970;
{
    return [NSDate dateWithTimeIntervalSince1970:[self doubleValue] / 1000];
}

- (NSDate *)dateValueWithTimeIntervalSince1970;
{
    return [NSDate dateWithTimeIntervalSince1970:[self doubleValue]];
}

// Adapted from Sam Soffes
// http://coding.scribd.com/2011/05/08/how-to-drastically-improve-your-app-with-an-afternoon-and-instruments/

- (NSDate *)ISO8601DateValue;
{
    if (!self.length) {
        return nil;
    }
    
    struct tm tm;
    time_t t;    
    
    strptime([self cStringUsingEncoding:NSUTF8StringEncoding], "%Y-%m-%dT%H:%M:%S%z", &tm);
    tm.tm_isdst = -1;
    t = mktime(&tm);
    
    return [NSDate dateWithTimeIntervalSince1970:t];
}

#pragma mark Drawing

#if TARGET_OS_IPHONE

- (CGSize)drawInRect:(CGRect)inRect withFont:(UIFont *)inFont color:(UIColor *)inColor shadowColor:(UIColor *)inShadowColor shadowOffset:(CGSize)inShadowOffset;
{
    return [self drawInRect:inRect withFont:inFont lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentLeft color:inColor shadowColor:inShadowColor shadowOffset:inShadowOffset];
}

- (CGSize)drawInRect:(CGRect)inRect withFont:(UIFont *)inFont lineBreakMode:(UILineBreakMode)inLineBreakMode color:(UIColor *)inColor shadowColor:(UIColor *)inShadowColor shadowOffset:(CGSize)inShadowOffset;
{
    return [self drawInRect:inRect withFont:inFont lineBreakMode:inLineBreakMode alignment:UITextAlignmentLeft color:inColor shadowColor:inShadowColor shadowOffset:inShadowOffset];
}

- (CGSize)drawInRect:(CGRect)inRect withFont:(UIFont *)inFont lineBreakMode:(UILineBreakMode)inLineBreakMode alignment:(UITextAlignment)alignment color:(UIColor *)inColor shadowColor:(UIColor *)inShadowColor shadowOffset:(CGSize)inShadowOffset;
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, inShadowOffset, 0.0, inShadowColor.CGColor);
    CGContextSetFillColorWithColor(context, inColor.CGColor);
    CGSize renderedSize = [self drawInRect:inRect withFont:inFont lineBreakMode:inLineBreakMode];   
    CGContextRestoreGState(context);
    
    return renderedSize;
}

#endif

@end
