//
//  FlashDelegate.h
//  BleLibrary
//
//  Created by sheldon on 2013/11/15.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefStruct.h"	

@protocol FlashDelegate <NSObject>
-(void) onFlashKeyList:(NSString *) keyList;
-(void) onFlashWriteStatus:(BOOL) status;
-(void) onFlashReadStatus:(NSInteger) status;
-(void) onFlashData:(BlobData*)blobData;
-(void) onFlashDelStatus:(NSInteger) status;
@end
