//
//  CaptureVerifyDelegate.h
//  BleLibrary
//
//  Created by sheldon on 13/10/18.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CaptureVerifyDelegate <NSObject>
-(void) onMatchedUser:(NSString*)uid;
@end
