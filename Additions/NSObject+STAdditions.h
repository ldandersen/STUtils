//
//  NSObject+STAdditions.h
//
//  Created by Buzz Andersen on 12/29/09.
//  Copyright 2011 System of Touch. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSObject (STAdditions)

// Selectors
- (id)performSelectorOnMainThread:(SEL)selector withArguments:(NSArray *)arguments waitUntilDone:(BOOL)waitUntilDone;

- (id)performSelectorIfResponds:(SEL)selector;
- (id)performSelectorIfResponds:(SEL)selector withObject:(id)obj;
- (id)performSelectorIfResponds:(SEL)selector withObject:(id)obj1 withObject:(id)obj2;

- (void)performSelectorOnRunloopCycle:(SEL)selector;

// URL Parameter Strings
- (NSString *)URLParameterStringValue;

@end
