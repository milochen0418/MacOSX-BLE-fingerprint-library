//
//  NSThread+Block.m
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSThread+Block.h"

@implementation NSThread (Block)

- (void)performBlock:(void (^)())block
{
	if ([[NSThread currentThread] isEqual:self]) {
		block();
    }
	else {
		[self performBlock:block waitUntilDone:NO];
    }
}

- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait
{
    [NSThread performSelector:@selector(ng_runBlock:) onThread:self withObject:[block copy] waitUntilDone:wait];
}

+ (void)ng_runBlock:(void (^)())block
{
	block();
}

+ (void)performBlockInBackground:(void (^)())block
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0), ^{
		block();
	});
	//[NSThread performSelectorInBackground:@selector(ng_runBlock:) withObject:[block copy]];
}

+ (void)performBlockOnMainThread:(void (^)())block
{
	dispatch_async(dispatch_get_main_queue(), ^{
		block();
	});
    //[[NSThread currentThread] performSelectorOnMainThread:@selector(ng_runBlock:) withObject:[block copy] waitUntilDone:NO];
}

@end
