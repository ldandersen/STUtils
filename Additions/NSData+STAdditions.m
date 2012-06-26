//
//  NSData+STAdditions.m
//
//  Created by Buzz Andersen on 12/29/09.
//  Copyright 2011 System of Touch. All rights reserved.
//

#import "STUtils.h"


@implementation NSData (STAdditions)

#pragma mark UTF8

- (NSString *)UTF8String;
{
    return [[[NSString alloc] initWithBytes:[self bytes] length:[self length] encoding:NSUTF8StringEncoding] autorelease];
}

@end


@implementation NSMutableData (STAdditions)

- (void)appendUTF8StringWithFormat:(NSString *)inString, ...;
{
    va_list args;
    va_start(args, inString);
    
    NSString *formattedString = [[NSString alloc] initWithFormat:inString arguments:args];
    [self appendUTF8String:formattedString];
    [formattedString release];
	
    va_end(args);
}

- (void)appendUTF8String:(NSString *)inString;
{
    [self appendString:inString withEncoding:NSUTF8StringEncoding];
}

- (void)appendString:(NSString *)inString withEncoding:(NSStringEncoding)inEncoding;
{
    NSUInteger byteLength = [inString lengthOfBytesUsingEncoding:inEncoding];
    
    if (!byteLength) {
        return;
    }
    
    char *buffer = malloc(byteLength);
    
    if ([inString getBytes:buffer maxLength:byteLength usedLength:NULL encoding:inEncoding options:NSStringEncodingConversionExternalRepresentation range:NSMakeRange(0,byteLength) remainingRange:NULL]) {
        [self appendBytes:buffer length:byteLength];
    }
    
    free(buffer);
}

@end