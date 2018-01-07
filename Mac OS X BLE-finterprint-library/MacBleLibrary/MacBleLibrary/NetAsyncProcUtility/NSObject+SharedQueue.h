//
//  NSObject+SharedQueue.h
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SharedQueue)
-(void)performSelectorOnBackgroundQueue:(SEL)aSelector withObject:(id)anObject;
@end
