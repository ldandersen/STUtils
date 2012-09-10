//
//  STTargetActionQueue.h
//
//  Created by Buzz Andersen on 6/28/12.
//  Copyright (c) 2012 System of Touch. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface STTargetActionQueue : NSObject

- (NSArray *)allKeys;
- (void)addTarget:(id)inTarget action:(SEL)inAction forKey:(NSString *)inKey;
- (void)removeTarget:(id)inTarget;
- (void)removeTarget:(id)inTarget forKey:(NSString *)inKey;
- (void)performActionsForKey:(NSString *)inKey;
- (void)performActionsForKey:(NSString *)inKey withObject:(NSDictionary *)inObject;

@end


@interface STTargetAction : NSObject

@property (nonatomic, retain) NSString *key;
@property (nonatomic, assign) id target;
@property (nonatomic, assign) SEL action;
@property (nonatomic, copy) void(^actionBlock)();

@end
