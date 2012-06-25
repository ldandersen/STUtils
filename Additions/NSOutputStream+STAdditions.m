//
//  NSOutputStream+STAdditions.m
//  Hipflask
//
//  Created by Buzz Andersen on 4/10/12.
//  Copyright (c) 2012 System of Touch. All rights reserved.
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


@implementation NSOutputStream (STAdditions)

- (void)writeUTF8StringWithFormat:(NSString *)inString, ...;
{
    va_list args;
    va_start(args, inString);
    
    NSString *formattedString = [[NSString alloc] initWithFormat:inString arguments:args];
    [self writeUTF8String:formattedString];
    [formattedString release];
	
    va_end(args);
}

- (void)writeUTF8String:(NSString *)inUTF8String;
{
    [self writeString:inUTF8String usingEncoding:NSUTF8StringEncoding];
}

- (void)writeString:(NSString *)inString usingEncoding:(NSStringEncoding)inEncoding;
{
    NSUInteger byteLength = [inString lengthOfBytesUsingEncoding:inEncoding];
    
    if (!byteLength) {
        return;
    }
    
    char *buffer = malloc(byteLength);
    
    if ([inString getBytes:buffer maxLength:byteLength usedLength:NULL encoding:inEncoding options:NSStringEncodingConversionExternalRepresentation range:NSMakeRange(0,byteLength) remainingRange:NULL]) {
        [self write:(const uint8_t *)buffer maxLength:byteLength];
    }
    
    free(buffer);
}

- (void)writeData:(NSData *)inData;
{
    [self write:[inData bytes] maxLength:inData.length];
}

- (void)writeFileDataAtPath:(NSString *)inPath withBufferSize:(NSInteger)inBufferSize;
{
    if (!inPath.length || ![[NSFileManager defaultManager] fileExistsAtPath:inPath]) {
        return;
    }
    
    NSInputStream *fileInputStream = [NSInputStream inputStreamWithFileAtPath:inPath];
    while ([fileInputStream hasBytesAvailable]) {
        uint8_t fileBuffer[inBufferSize];
        [fileInputStream read:fileBuffer maxLength:inBufferSize];
        [self write:fileBuffer maxLength:inBufferSize];
    }
}

@end
