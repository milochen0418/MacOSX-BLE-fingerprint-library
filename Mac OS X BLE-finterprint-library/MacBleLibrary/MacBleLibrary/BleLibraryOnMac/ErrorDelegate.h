//
//  ErrorDelegate.h
//  BleLibrary
//
//  Created by sheldon on 13/10/17.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ErrorDelegate <NSObject>
-(void) Error:(NSString*)error;
@end
