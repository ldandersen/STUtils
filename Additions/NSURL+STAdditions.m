//
//  NSURL+STAdditions.m
//
//  Created by Buzz Andersen on 12/29/09.
//  Copyright 2011 System of Touch. All rights reserved.
//

#import "STUtils.h"


@implementation NSURL (STAdditions)

- (NSString *)absoluteStringMinusQueryString;
{
    NSMutableString *returnString = [[[NSMutableString alloc] init] autorelease];
    [returnString appendFormat:@"%@://%@", [self scheme], [self host]];
    
    NSString *thePath = [self path];
    if (thePath) {
        [returnString appendString:thePath];
    }

    return returnString;
}

- (NSString *)absoluteStringMinusScheme;
{
	return [[self resourceSpecifier] substringFromIndex:2];
}

- (NSDictionary *)queryParameters;
{
    NSString *query = [self query];
    NSArray *keyValuePairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    
    for (NSString *pair in keyValuePairs) {
        NSArray *components = [pair componentsSeparatedByString:@"="];
        
        if (components.count == 2) {
            NSString *key = [[components firstObject] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *value = [[components objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (key && value) {
                [params setObject:value forKey:key];
            }
        }
    }
    
    return params;
}

- (NSURL *)URLByAppendingString:(NSString *)string;
{
    NSString *baseURL = [self absoluteString];
    
    if ([baseURL hasSuffix:@"/"] && [string hasPrefix:@"/"]) {
        string = [string substringFromIndex:1];
    } else if (string.length && ![baseURL hasSuffix:@"/"] && ![string hasPrefix:@"/"]) {
        // Don't append a trailing / if string is empty.
        string = [@"/" stringByAppendingString:string];
    }
    
    return [NSURL URLWithString:[baseURL stringByAppendingString:string]];
}

- (NSURL *)URLByAppendingQueryParameters:(NSDictionary *)parameters;
{
    if (!parameters.count) {
        return self;
    }
    
    NSMutableString *urlString = [[self absoluteString] mutableCopy];
    
    if ([self query]) {
        [urlString appendString:@"&"];
    } else {
        [urlString appendString:@"?"];
    }
    
    [urlString appendString:[parameters URLEncodedStringValue]];
    NSURL *returnURL = [NSURL URLWithString:urlString];
    [urlString release];
    
    return returnURL;
}

@end
