//
//  StatusDelegate.h
//  BleLibrary
//
//  Created by sheldon on 13/10/21.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol StatusDelegate <NSObject>
-(void) onBadImage:(int) status;
-(void) onDeviceConnected;
-(void) onDeviceDisConnected;
-(void) onFingerFetch;
//-(void) onFingerImageGetted;
-(void) onUserAbort:(BOOL)status;
-(void) onStatus:(int) status;
@end
