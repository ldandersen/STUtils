//
//  NSObject+STAdditions.m
//
//  Created by Buzz Andersen on 12/29/09.
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


@implementation NSObject (STAdditions)

#pragma mark Selectors

- (id)performSelectorOnMainThread:(SEL)selector withArguments:(NSArray *)arguments waitUntilDone:(BOOL)waitUntilDone;
{    
    if (![self respondsToSelector:selector]) {
        return nil;
    }
    
    NSMethodSignature *signature = [[self class] instanceMethodSignatureForSelector:selector];
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
    [invocation setSelector:selector];
    [invocation setTarget:self];
    [invocation retainArguments];
    
    for (int currentIndex = 0; currentIndex < arguments.count; currentIndex++) {
        id currentArgument = [arguments objectAtIndex:currentIndex];
        [invocation setArgument:&currentArgument atIndex:currentIndex];
    }
    
    [invocation performSelectorOnMainThread:@selector(invoke) withObject:nil waitUntilDone:waitUntilDone];
    
    if (!waitUntilDone || ![signature methodReturnLength]) {
        return nil;
    }
    
    char *returnType = (char *)[signature methodReturnType];
    
    // If the return type is an object, return it.
    if (strchr(returnType, '@')) {
        id returnValue;
        [invocation getReturnValue:&returnValue];
        
        // Add the returned object to the autorelease pool on 
        // this thread, if we're on a secondary thread (since 
        // theoretically it could be autoreleased on the main
        // thread).
        if (![NSThread isMainThread]) {
            [[returnValue retain] autorelease];
        }
        
        return returnValue;
    }
    
    // If the return type is not an object, box it
    // up and return it as an NSValue.
    int length = [signature methodReturnLength];
    void *returnBuffer = (void *)malloc(length);
    [invocation getReturnValue:returnBuffer];
    
    NSValue *returnValue = [NSValue value:returnBuffer withObjCType:returnType];
    
    free(returnBuffer);
    
    return returnValue;
}

- (id)performSelectorIfResponds:(SEL)selector;
{
    if ([self respondsToSelector:selector]) {
        return [self performSelector:selector];
    }
    
    return nil;
}

- (id)performSelectorIfResponds:(SEL)selector withObject:(id)obj;
{
    if ([self respondsToSelector:selector]) {
        return [self performSelector:selector withObject:obj];
    }
    
    return nil;
}

- (id)performSelectorIfResponds:(SEL)selector withObject:(id)obj1 withObject:(id)obj2;
{
    if ([self respondsToSelector:selector]) {
        return [self performSelector:selector withObject:obj1 withObject:obj2];
    }
    
    return nil;
}

- (void)performSelectorOnRunloopCycle:(SEL)selector;
{
    [self performSelector:selector withObject:nil afterDelay:0.0];
}

- (void)performSelectorOnRunloopCycle:(SEL)selector withObject:(id)obj1;
{
    [self performSelector:selector withObject:obj1 afterDelay:0.0];
}

#pragma mark URL Parameter Strings

- (NSString *)URLParameterStringValue;
{
	NSString *stringValue = nil;
	
	if ([self isKindOfClass: [NSString class]]) {
		stringValue = (NSString *)self;
	}
	else if ([self isKindOfClass: [NSNumber class]]) {		
		stringValue = [(NSNumber *)self stringValue];
	}
	else if ([self isKindOfClass: [NSDate class]]) {
		stringValue = [(NSDate *)self HTTPTimeZoneHeaderString];
	}
	
	return stringValue;
}

@end
