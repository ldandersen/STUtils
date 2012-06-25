//
//  NSData+STAdditions.h
//
//  Created by Buzz Andersen on 12/29/09.
//  Copyright 2011 System of Touch. All rights reserved.

#import <Foundation/Foundation.h>


@interface NSData (STAdditions)

#pragma mark Base 64 Encoding
- (id)initWithBase64String:(NSString *)string;

#pragma mark HMAC
- (NSData *)hmacSHA1DataValueWithKey:(NSData *)keyData;

#pragma mark Hex Strings
- (NSString *)hexString;

#pragma mark UTF8
- (NSString *)UTF8String;

@end


@interface NSMutableData (STAdditions)

- (void)appendUTF8String:(NSString *)inString;
- (void)appendUTF8StringWithFormat:(NSString *)inString, ...;
- (void)appendString:(NSString *)inString withEncoding:(NSStringEncoding)inEncoding;

@end