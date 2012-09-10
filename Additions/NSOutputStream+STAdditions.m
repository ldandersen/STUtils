//
//  NSOutputStream+STAdditions.m
//
//  Created by Buzz Andersen on 4/10/12.
//  Copyright (c) 2012 System of Touch. All rights reserved.
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
    
    size_t usedByteLength;
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
