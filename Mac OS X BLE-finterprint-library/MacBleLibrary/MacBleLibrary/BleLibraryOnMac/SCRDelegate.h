//
//  SCRDelegate.h
//  BleLibrary
//
//  Created by mac-mini on 2013/11/21.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SCRDelegate <NSObject>
-(void) onSCROpenStatus:(int)status;
-(void) onSCRCloseOK;
-(void) onSendAPDUCmdStatus:(int) status;
-(void) onReturnAPDUData:(BlobData*) blobData;
@end
