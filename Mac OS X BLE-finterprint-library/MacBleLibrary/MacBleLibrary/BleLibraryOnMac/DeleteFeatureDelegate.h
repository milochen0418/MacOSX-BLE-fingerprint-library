//
//  DeleteFeatureDelegate.h
//  BleLibrary
//
//  Created by sheldon on 13/10/21.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DeleteFeatureDelegate <NSObject>
-(void) onDeleteFeatureStatus:(BOOL) status;
@end
