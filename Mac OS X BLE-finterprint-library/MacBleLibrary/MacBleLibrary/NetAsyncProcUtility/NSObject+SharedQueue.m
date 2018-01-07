//
//  NSObject+SharedQueue.m
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//

#import "NSOperationQueue+SharedQueue.h"
#import "NSObject+SharedQueue.h"

@implementation NSObject (SharedQueue)

-(void)performSelectorOnBackgroundQueue:(SEL)aSelector withObject:(id)anObject;
{
    NSOperation* operation = [[NSInvocationOperation alloc] initWithTarget:self
                                                                  selector:aSelector
                                                                    object:anObject];
    [[NSOperationQueue sharedOperationQueue] addOperation:operation];
//    [operation release];
    operation = nil;
}

@end
