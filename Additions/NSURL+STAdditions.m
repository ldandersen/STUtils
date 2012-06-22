//
//  NSURL+STAdditions.m
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
