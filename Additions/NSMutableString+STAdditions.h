//
//  NSMutableString+STAdditions.h
//
//  Created by Buzz Andersen on 2/19/11.
//  Copyright 2011 System of Touch. All rights reserved.
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
