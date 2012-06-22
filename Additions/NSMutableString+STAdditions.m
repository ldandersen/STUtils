//
//  NSMutableString+STAdditions.m
//
//  Created by Buzz Andersen on 2/19/11.
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


@implementation NSMutableString (STAdditions)

- (void)appendPredicateCondition:(NSString *)predicateCondition;
{
    if (self.length) {
        [self appendString:@" AND "];
    }
    
    [self appendString:predicateCondition];
}

- (void)appendPathComponent:(NSString *)inPathComponent;
{
    [self appendPathComponent:inPathComponent queryString:nil];
}

- (void)appendPathComponent:(NSString *)inPathComponent queryString:(NSString *)inQueryString;
{
    if (!inPathComponent.length || [inPathComponent isEqualToString:@"/"]) {
        return;
    }
    
    // See if there is already a query string
    NSRange queryRange = [self rangeOfString:@"\?.*" options:NSRegularExpressionSearch];
    if (queryRange.location != NSNotFound) {        
        // Remove the existing query string, but cache it
        NSString *foundQueryString = [self substringWithRange:queryRange];
        [self deleteCharactersInRange:queryRange];
        
        // If the user passed in a new query string, or we
        // have a query string with only a ?, simply lose
        // the existing query string. Otherwise, append it
        // after the 
        if (foundQueryString.length > 1 && !inQueryString.length) {
            [self appendPathComponent:inPathComponent queryString:foundQueryString];
            return;
        }
    } 
    
    if (!self.length || [self hasSuffix:@"/"]) {
        [self appendString:inPathComponent];
    } else {
        [self appendFormat:@"/%@", inPathComponent];
    }
    
    if (inQueryString.length) {
        [self appendString:inQueryString];
    }
}

- (void)appendPathComponents:(NSArray *)inPathComponents;
{
    for (NSString *currentPathComponent in inPathComponents) {
        [self appendPathComponent:currentPathComponent];
    }
}

@end
