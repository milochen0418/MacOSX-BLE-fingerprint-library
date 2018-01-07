//
//  NSThread+Block.h
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSThread (Block)

- (void)performBlock:(void (^)())block;
- (void)performBlock:(void (^)())block waitUntilDone:(BOOL)wait;
+ (void)performBlockInBackground:(void (^)())block;
+ (void)performBlockOnMainThread:(void (^)())block;

@end
