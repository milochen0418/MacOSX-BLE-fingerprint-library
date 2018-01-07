//
//  NSOperationQueue+SharedQueue.h
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSOperationQueue (SharedQueue)
+(NSOperationQueue*)sharedOperationQueue;
/*
+(NSOperationQueue*)sharedOperationUploadFileQueue;
+(NSOperationQueue*)sharedOperationDownloadFileQueue;
+(NSOperationQueue*)sharedOperationDownloadListQueue;
+(NSOperationQueue*)sharedOperationLocalListQueue;
+(NSOperationQueue*)sharedOperationLoginAndRegQueue;

+(NSOperationQueue*)sharedOperationInternetAutocompleteQueue;
+(NSOperationQueue*)sharedOperationReadVideosInfoQueue;

+(NSOperationQueue*) sharedOperationVisitAllInfoQueue;
+(NSOperationQueue*) sharedOperationVisitAllPicQueue;
+(NSOperationQueue*) sharedOperationFastPassInfoQueue;
+(NSOperationQueue*) sharedOperationFastPassPicQueue;
 */
@end
