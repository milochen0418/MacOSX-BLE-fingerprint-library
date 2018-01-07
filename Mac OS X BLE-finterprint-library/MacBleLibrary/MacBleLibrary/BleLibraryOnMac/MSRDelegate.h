//
//  MSRDelegate.h
//  BleLibrary
//
//  Created by mac-mini on 2013/11/22.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DefStruct.h"

@protocol MSRDelegate <NSObject>
-(void) onMSRReadStatus:(int)status;
-(void) onMSRTimeout;
-(void) onReturnMSRFirstTrack:(BlobData*) blobData;
-(void) onReturnMSRSecondTrack:(BlobData*) blobData;
-(void) onDecodeFailed;
@end
