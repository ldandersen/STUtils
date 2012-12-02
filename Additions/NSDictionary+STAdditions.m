//
//  NSDictionary+STAdditions.m
//
//  Created by Buzz Andersen on 12/29/09.
//  Copyright 2012 System of Touch. All rights reserved.
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
			[listString appendFormat: @"%@=\"%@\"", currentKey, escapedStringValue];			
		}
		
		appendComma = YES;
	}
	
	return [listString autorelease];
}

#pragma mark Sorting

- (NSArray *)sortedKeys;
{
    return [[self allKeys] sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
}

- (NSArray *)sortedArrayUsingKeyValues;
{
	NSArray *sortedKeys = [self sortedKeys];
	NSMutableArray *returnArray = [[[NSMutableArray alloc] init] autorelease];
	
	id currentKey;
	
	for (currentKey in sortedKeys) {
		[returnArray addObject:[self objectForKey:currentKey]];
	}
	
	return returnArray;
}

@end


@implementation NSMutableDictionary (CCAdditions)

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