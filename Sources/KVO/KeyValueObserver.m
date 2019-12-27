//
//  KeyValueObserver.m
//  Lab Color Space Explorer
//
//  Created by Daniel Eggert on 01/12/2013.
//  Copyright (c) 2013 objc.io. All rights reserved.
//

#import "KeyValueObserver.h"

//
// Created by chris on 7/24/13.
//

#import "KeyValueObserver.h"

@interface KeyValueObserver ()
@property (nonatomic, weak) id observedObject;
@property (nonatomic, copy) NSString* keyPath;
@property (nonatomic, assign) BOOL shouldObserver;
@end

@implementation KeyValueObserver

- (id)initWithObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options;
{
    if (object == nil) {
        return nil;
    }
    NSParameterAssert(target != nil);
    NSParameterAssert([target respondsToSelector:selector]);
    self = [super init];
    if (self) {
        _shouldObserver = YES;
        self.target = target;
        self.selector = selector;
        self.observedObject = object;
        self.keyPath = keyPath;
        [object addObserver:self forKeyPath:keyPath options:options context:(__bridge void *)(self)];
    }
    return self;
}

+ (NSObject *)observeObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector __attribute__((warn_unused_result));
{
    return [self observeObject:object keyPath:keyPath target:target selector:selector options:0];
}

+ (NSObject *)observeObject:(id)object keyPath:(NSString*)keyPath target:(id)target selector:(SEL)selector options:(NSKeyValueObservingOptions)options __attribute__((warn_unused_result));
{
    return [[self alloc] initWithObject:object keyPath:keyPath target:target selector:selector options:options];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void*)context
{
    if (context == (__bridge void *)(self)) {
        [self didChange:change];
    }
}

- (void)didChange:(NSDictionary *)change {
    
    if (!self.shouldObserver) {
        return;
    }
    
    id strongTarget = self.target;
    
    if ([strongTarget respondsToSelector:self.selector]) {
        #pragma clang diagnostic push
        #pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [strongTarget performSelector:self.selector withObject:change];
        #pragma clang diagnostic pop
    }
}

- (void)dealloc {
    [self.observedObject removeObserver:self forKeyPath:self.keyPath];
}

- (void)unObserver {
    self.shouldObserver = NO;
}

@end
