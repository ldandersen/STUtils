//
//  NSURL+STAdditions.m
//
//  Created by Florent Morin on 06/24/12.
//  Copyright 2012 Kaeli Soft. All rights reserved.
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

@implementation NSData (STAdditions)

- (NSString *)base64EncodedString {
    return [self base64EncodedStringWithLineLength:0];
}

- (NSString *)base64EncodedStringWithLineLength:(NSInteger)length
{
	static char *encodingTable = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

	const unsigned char *bytes = [self bytes];

	NSMutableString *result = [[NSMutableString alloc] init];

	NSInteger idxSource = 0;
	NSInteger idx = 0;
	NSInteger lengthSource = [self length];
	NSInteger idxCharOnLine = 0;

	while (1) {
		NSInteger remaining = lengthSource - idx;
		unsigned char inBuffer[3];
		unsigned char outBuffer[4];
		NSInteger toCopy = 4;

		if (remaining <= 0) {
			break;
		}

		for (NSInteger i = 0; i < 3; i++) {
			idx = idxSource + i;
			if (idx < lengthSource) {
				inBuffer[i] = bytes[idx];
			} else {
				inBuffer[i] = '\0';
			}
		}

		outBuffer[0] = (inBuffer[0] & 0xfc) >> 2;
        outBuffer[1] = ((inBuffer[0] & 0x03) << 4) | ((inBuffer[1] & 0xf0) >> 4);
        outBuffer[2] = ((inBuffer[1] & 0x0f) << 2) | ((inBuffer[2] & 0xc0) >> 6);
        outBuffer[3] = inBuffer[2] & 0x3f;

		toCopy = 4;

		if (remaining < 3) {
			toCopy = remaining + 1;
		}

		for (NSInteger i = 0;i < toCopy;i++) {
			unsigned char c = outBuffer[i];
			[result appendFormat:@"%c", encodingTable[c]];
		}

		for (NSInteger i = toCopy;i < 4;i++) {
			[result appendFormat:@"%c", '='];
		}

		idxSource += 3;
		idxCharOnLine += 4;

		if (length > 0 && idxCharOnLine >= length) {
			idxCharOnLine = 0;
			[result appendString:@"\n"];
		}
	}

	return (NSString *)result;
}

- (NSString *)hexadecimalString
{
    static const char hexValues[] = "0123456789abcdef";
    const size_t len = [self length];
    const unsigned char *data = [self bytes];
    char *buffer = (char *)calloc(len * 2 + 1, sizeof(char));
    char *hex = buffer;
    NSString *hexBytes = nil;
    
    for (int i = 0; i < len; i++) {
        const unsigned char c = data[i];
        *hex++ = hexValues[(c >> 4) & 0xF];
        *hex++ = hexValues[(c ) & 0xF];
    }
    
    hexBytes = [NSString stringWithUTF8String:buffer];
    
    free(buffer);
    
    return hexBytes;
}

@end
