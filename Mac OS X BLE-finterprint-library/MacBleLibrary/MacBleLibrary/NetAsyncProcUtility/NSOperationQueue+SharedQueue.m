//
//  NSOperationQueue+SharedQueue.m
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//

#import "NSOperationQueue+SharedQueue.h"

@implementation NSOperationQueue (SharedQueue)
+(NSOperationQueue*)sharedOperationQueue;
{
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}
/*

+(NSOperationQueue*)sharedOperationUploadFileQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
    
}
+(NSOperationQueue*)sharedOperationDownloadFileQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
    
}
+(NSOperationQueue*)sharedOperationDownloadListQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 2;
    return sharedQueue;
    
}


+(NSOperationQueue*)sharedOperationLocalListQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}

+(NSOperationQueue*)sharedOperationLoginAndRegQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}




+(NSOperationQueue*)sharedOperationInternetAutocompleteQueue;
{
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}

+(NSOperationQueue*)sharedOperationReadVideosInfoQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;    
}


+(NSOperationQueue*) sharedOperationVisitAllInfoQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}
+(NSOperationQueue*) sharedOperationVisitAllPicQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 2;
    return sharedQueue;
    
}
+(NSOperationQueue*) sharedOperationFastPassInfoQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}
+(NSOperationQueue*) sharedOperationFastPassPicQueue {
    static NSOperationQueue* sharedQueue = nil;
    if (sharedQueue == nil) {
        sharedQueue = [[NSOperationQueue alloc] init];
    }
    sharedQueue.maxConcurrentOperationCount = 1;
    return sharedQueue;
}
*/
@end
