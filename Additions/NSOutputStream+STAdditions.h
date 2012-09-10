//
//  NSOutputStream+STAdditions.h
//  Hipflask
//
//  Created by Buzz Andersen on 4/10/12.
//  Copyright (c) 2012 System of Touch. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOutputStream (STAdditions)

- (NSInteger)writeUTF8StringWithFormat:(NSString *)inString, ...;
- (NSInteger)writeUTF8String:(NSString *)inUTF8String;
- (NSInteger)writeString:(NSString *)inString usingEncoding:(NSStringEncoding)inEncoding;
- (NSInteger)writeData:(NSData *)inData;
- (NSInteger)writeFileDataAtPath:(NSString *)inPath withBufferSize:(NSInteger)inBufferSize;

@end
