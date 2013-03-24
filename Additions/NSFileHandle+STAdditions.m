//
//  NSFileHandle+STAdditions.m
//
//  Created by Buzz Andersen on 7/16/12.
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

#import "NSFileHandle+STAdditions.h"


@implementation NSFileHandle (STAdditions)

- (void)writeUTF8StringWithFormat:(NSString *)inString, ...;
{
    va_list args;
    va_start(args, inString);
    
    [self writeUTF8StringWithFormat:inString arguments:args];
	
    va_end(args);
}

- (void)writeUTF8StringWithFormat:(NSString *)inString arguments:(va_list)inArguments;
{
    NSString *formattedString = [[NSString alloc] initWithFormat:inString arguments:inArguments];
    [self writeUTF8String:formattedString];
    [formattedString release];
}

- (void)writeUTF8String:(NSString *)inString;
{
    [self writeString:inString withEncoding:NSUTF8StringEncoding];
}

- (void)writeString:(NSString *)inString withEncoding:(NSStringEncoding)inEncoding;
{
    NSUInteger byteLength = [inString lengthOfBytesUsingEncoding:inEncoding];
    
    if (!byteLength) {
        return;
    }
    
    char *buffer = malloc(byteLength);
    
    NSUInteger usedLength = 0;
    if ([inString getBytes:buffer maxLength:byteLength usedLength:&usedLength encoding:inEncoding options:NSStringEncodingConversionExternalRepresentation range:NSMakeRange(0,byteLength) remainingRange:NULL]) {
        NSData *stringData = [[NSData alloc] initWithBytes:buffer length:usedLength];
        [self writeData:stringData];
        [stringData release];
    }
    
    free(buffer);
}

@end
