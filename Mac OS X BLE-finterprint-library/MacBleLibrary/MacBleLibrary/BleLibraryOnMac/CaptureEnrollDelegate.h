//
//  CaptureEnrollDelegate.h
//  BleLibrary
//
//  Created by sheldon on 13/10/21.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys_queue.h"

@protocol CaptureEnrollDelegate <NSObject>
-(void) onSuccess;
-(void) onFail:(int)errorCode;
-(void) onProgress;
-(void) onGetFeature:(BYTE []) feature withSize:(int) size;
-(void) onEnrollListString:(NSString*)uidList;
@end
