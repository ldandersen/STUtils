//
//  NSMutableString+STAdditions.h
//
//  Created by Buzz Andersen on 2/19/11.
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

#import <Foundation/Foundation.h>


@interface NSMutableString (STAdditions)

// Predicates
- (void)appendPredicateCondition:(NSString *)predicateCondition;
- (void)appendPredicateConditionWithOperator:(NSString *)inOperator string:(NSString *)inPredicateConditionString;

- (void)appendPredicateConditionWithFormat:(NSString *)inPredicateConditionString, ...;
- (void)appendPredicateConditionWithOperator:(NSString *)inOperator format:(NSString *)inPredicateCondition, ...;
- (void)appendPredicateConditionWithOperator:(NSString *)inOperator format:(NSString *)inPredicateCondition arguments:(va_list)inArguments;

// Paths
- (void)appendPathComponent:(NSString *)inPathComponent;
- (void)appendPathComponent:(NSString *)inPathComponent queryString:(NSString *)inQueryString;
- (void)appendPathComponents:(NSArray *)inPathComponents;

@end
