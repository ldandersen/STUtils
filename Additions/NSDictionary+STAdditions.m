//
//  NSDictionary+STAdditions.m
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


@implementation NSDictionary (STAdditions)

#pragma mark URL Parameter Strings

+ (NSDictionary *)dictionaryWithURLEncodedString:(NSString *)urlEncodedString;
{
    NSMutableDictionary *mutableResponseDictionary = [[[NSMutableDictionary alloc] init] autorelease];
    // split string by &s
    NSArray *encodedParameters = [urlEncodedString componentsSeparatedByString:@"&"];
    for (NSString *parameter in encodedParameters) {
        NSArray *keyValuePair = [parameter componentsSeparatedByString:@"="];
        if (keyValuePair.count == 2) {
            NSString *key = [[keyValuePair objectAtIndex:0] stringByReplacingPercentEscapes];
            NSString *value = [[keyValuePair objectAtIndex:1] stringByReplacingPercentEscapes];
            [mutableResponseDictionary setObject:value forKey:key];
        }
    }
    return mutableResponseDictionary;
}

- (NSString *)URLEncodedStringValue;
{
	if (self.count < 1) {
        return @"";
    }
	
	NSEnumerator *keyEnum = [self keyEnumerator];
	NSString *currentKey;
	
	BOOL appendAmpersand = NO;
	
	NSMutableString *parameterString = [[NSMutableString alloc] init];
	
	while ((currentKey = (NSString *)[keyEnum nextObject]) != nil) {
		id currentValue = [self objectForKey:currentKey];
		NSString *stringValue = [currentValue URLParameterStringValue];
		
		if (stringValue != nil) {
			if (appendAmpersand) {
				[parameterString appendString: @"&"];
			}
			
			NSString *escapedStringValue = [stringValue stringByEscapingQueryParameters];
			
			[parameterString appendFormat: @"%@=%@", currentKey, escapedStringValue];			
		}
		
		appendAmpersand = YES;
	}
	
	return [parameterString autorelease];
}

- (NSString *)URLEncodedQuotedKeyValueListValue;
{
	if (self.count < 1) {
        return @"";
    }
	
	NSEnumerator *keyEnum = [self keyEnumerator];
	NSString *currentKey;
	
	BOOL appendComma = NO;
	
	NSMutableString *listString = [[NSMutableString alloc] init];
	
	while ((currentKey = (NSString *)[keyEnum nextObject]) != nil) {
		id currentValue = [self objectForKey:currentKey];
		NSString *stringValue = [currentValue URLParameterStringValue];
		
		if (stringValue != nil) {
			if (appendComma) {
				[listString appendString: @", "];
			}
			
			NSString *escapedStringValue = [stringValue stringByEscapingQueryParameters];
			
			[listString appendFormat: @"%@=%\"%@\"", currentKey, escapedStringValue];			
		}
		
		appendComma = YES;
	}
	
	return [listString autorelease];
}

#pragma mark Sorting

- (NSArray *)sortedArrayUsingKeyValues;
{
	NSArray *sortedKeys = [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	id currentKey;
	
	for (currentKey in sortedKeys) {
		[returnArray addObject:[self objectForKey:currentKey]];
	}
	
	return returnArray;
}

@end


@implementation NSMutableDictionary (STAdditions)

- (void)addUniqueEntriesFromDictionary:(NSDictionary *)inDictionary;
{
    NSArray *keys = [inDictionary allKeys];
    
    for (NSString *currentKey in keys) {
        if (![self objectForKey:currentKey]) {
            id object = [inDictionary objectForKey:currentKey];
            [self setObject:object forKey:currentKey];
        }
    }
}

@end