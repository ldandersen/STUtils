//
//  NSOutputStream+STAdditions.m
//
//  Created by Buzz Andersen on 4/10/12.
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

#import "STUtils.h"


@implementation NSOutputStream (STAdditions)

- (NSInteger)writeUTF8StringWithFormat:(NSString *)inString, ...;
{
    va_list args;
    va_start(args, inString);
    
    NSString *formattedString = [[NSString alloc] initWithFormat:inString arguments:args];
    NSInteger bytesWritten = [self writeUTF8String:formattedString];
    [formattedString release];
	
    va_end(args);
    
    return bytesWritten;
}

- (NSInteger)writeUTF8String:(NSString *)inUTF8String;
{
    return [self writeString:inUTF8String usingEncoding:NSUTF8StringEncoding];
}

- (NSInteger)writeString:(NSString *)inString usingEncoding:(NSStringEncoding)inEncoding;
{
    NSUInteger byteLength = [inString lengthOfBytesUsingEncoding:inEncoding];
    if (!byteLength) {
        return -1;
    }
    
    uint8_t *buffer = malloc(byteLength);
    NSInteger bytesWritten = 0;
    
    NSUInteger usedByteLength;
    if ([inString getBytes:buffer maxLength:byteLength usedLength:&usedByteLength encoding:inEncoding options:NSStringEncodingConversionExternalRepresentation range:NSMakeRange(0,byteLength) remainingRange:NULL]) {
        if (!self.hasSpaceAvailable) {
            NSLog(@"Output stream has no space available.");
        }
        
        bytesWritten = [self write:(const uint8_t *)buffer maxLength:usedByteLength];
    }
    
    free(buffer);
    
    return bytesWritten;
}

- (NSInteger)writeData:(NSData *)inData;
{
    return [self write:[inData bytes] maxLength:inData.length];
}

- (NSInteger)writeFileDataAtPath:(NSString *)inPath withBufferSize:(NSInteger)inBufferSize;
{
    if (!inPath.length || ![[NSFileManager defaultManager] fileExistsAtPath:inPath]) {
        return -1;
    }
    
    /*NSInputStream *fileInputStream = [NSInputStream inputStreamWithFileAtPath:inPath];
    [fileInputStream open];
    
    NSInteger bytesWritten = 0;
    while ([fileInputStream hasBytesAvailable]) {
        uint8_t fileBuffer[inBufferSize];
        [fileInputStream read:fileBuffer maxLength:inBufferSize];
        bytesWritten = [self write:fileBuffer maxLength:inBufferSize];
    }
    
    [fileInputStream close];*/
    
    return [self writeData:[NSData dataWithContentsOfFile:inPath]];
}

@end
