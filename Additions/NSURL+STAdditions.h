//
//  NSURL+STAdditions.h
//
//  Created by Buzz Andersen on 12/29/09.
//  Copyright 2011 System of Touch. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSURL (STAdditions)

- (NSString *)absoluteStringMinusScheme;
- (NSString *)absoluteStringMinusQueryString;
- (NSDictionary *)queryParameters;
- (NSURL *)URLByAppendingString:(NSString *)string;
- (NSURL *)URLByAppendingQueryParameters:(NSDictionary *)parameters;

@end
