//
//  STTargetActionQueue.m
//
//  Created by Buzz Andersen on 6/28/12.
//  Copyright (c) 2012 System of Touch. All rights reserved.
//

#import "STTargetActionQueue.h"
#import "STUtils.h"


@interface STTargetActionQueue ()

@property (nonatomic, retain) NSMutableDictionary *targetActionInfo;

- (void)_addTargetAction:(STTargetAction *)inTargetAction;

@end


@implementation STTargetActionQueue

@synthesize targetActionInfo;

#pragma mark Initialization

- (void)dealloc;
{
    [targetActionInfo release];
    [super dealloc];
}

#pragma mark Accessors

- (NSMutableDictionary *)targetActionInfo;
{
    if (targetActionInfo == NULL) {
        targetActionInfo = [[NSMutableDictionary alloc] init];
    }
    
    return targetActionInfo;
}

- (NSArray *)allKeys;
{
    return [self.targetActionInfo allKeys];
}

#pragma mark Target/Action Methods

- (void)addTarget:(id)inTarget action:(SEL)inAction forKey:(NSString *)inKey;
{
    if (!inTarget || !inKey.length || !inAction) {
        return;
    }
    
    STTargetAction *targetAction = [[[STTargetAction alloc] init] autorelease];
    targetAction.key = inKey;
    targetAction.target = inTarget;
    targetAction.action = inAction;
    
    [self _addTargetAction:targetAction];
}

- (void)addTarget:(id)inTarget actionBlock:(void(^)())inActionBlock forKey:(NSString *)inKey;
{
    if (!inTarget || !inKey.length || !inActionBlock) {
        return;
    }
    
    STTargetAction *targetAction = [[[STTargetAction alloc] init] autorelease];
    targetAction.key = inKey;
    targetAction.actionBlock = inActionBlock;
    
    [self _addTargetAction:targetAction];
}
 
- (void)_addTargetAction:(STTargetAction *)inTargetAction;
{
    if (!inTargetAction) {
        return;
    }
    
    NSMutableArray *keyTargetActionsArray = (NSMutableArray *)[self.targetActionInfo objectForKey:inTargetAction.key];
    if (!keyTargetActionsArray) {
        // If we don't already have an array of target/actions for this
        // key, create one and add it to the mapping.
        keyTargetActionsArray = [[[NSMutableArray alloc] init] autorelease];
        [keyTargetActionsArray addObject:inTargetAction];
        [self.targetActionInfo setObject:keyTargetActionsArray forKey:inTargetAction.key];
        return;
    }
    
    // If a target/action is specified and we already have an array of
    // target/actions for this key, search to see if we already have this
    // target present
    if (inTargetAction.target) {
        [self removeTarget:inTargetAction.target forKey:inTargetAction.key];
    }
    
    [keyTargetActionsArray addObject:inTargetAction];
}

- (void)removeTarget:(id)inTarget;
{
    // Iterate through all the keys and remove this target
    // from each as appropriate
    NSArray *keys = [self.targetActionInfo allKeys];
    for (NSString *currentKey in keys) {
        [self removeTarget:inTarget forKey:currentKey];
    }
}

- (void)removeTarget:(id)inTarget forKey:(NSString *)inKey;
{
    NSMutableArray *keyTargetActionsArray = (NSMutableArray *)[self.targetActionInfo objectForKey:inKey];
    
    NSInteger currentIndex = 0;
    for (STTargetAction *currentTargetAction in keyTargetActionsArray) {
        if (currentTargetAction.target == inTarget) {
            // If the target is present for this key, remove it
            [keyTargetActionsArray removeObjectAtIndex:currentIndex];
        }
        
        currentIndex++;
    }
}

- (void)performActionsForKey:(NSString *)inKey;
{
    [self performActionsForKey:inKey withObject:nil];
}

- (void)performActionsForKey:(NSString *)inKey withObject:(NSDictionary *)inObject;
{
    if (!inKey.length) {
        return;
    }
    
    NSMutableArray *keyTargetActionsArray = (NSMutableArray *)[self.targetActionInfo objectForKey:inKey];

    for (STTargetAction *currentTargetAction in keyTargetActionsArray) {
        // If the target/action specifies a block, execute it
        // Otherwise, call the action selector on the target
        if (currentTargetAction.actionBlock) {
            if (inObject) {
                currentTargetAction.actionBlock(inKey, inObject);
            } else {
                currentTargetAction.actionBlock(inKey);
            }
        } else if (currentTargetAction.target && currentTargetAction.action && [currentTargetAction.target respondsToSelector:currentTargetAction.action]) {
            [currentTargetAction.target performSelectorOnMainThread:currentTargetAction.action withObject:inObject waitUntilDone:NO];
        }
    }
}

@end


@implementation STTargetAction

@synthesize key;

@synthesize target;
@synthesize action;

@synthesize actionBlock;

#pragma mark Initialization

- (void)dealloc;
{
    [key release];
    
    self.target = nil;
    self.action = NULL;
    
    [actionBlock release];

    [super dealloc];
}

@end
