//
//  YuKey.h
//  BleLibrary
//
//  Created by sheldon on 13/10/16.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import "sys_queue.h"
#import <Foundation/Foundation.h>
#import <IOBluetooth/IOBluetooth.h>
#import "BleBTRes.h"
#import "VersionDelegate.h"
#import "ErrorDelegate.h"
#import "CaptureVerifyDelegate.h"
#import "StatusDelegate.h"
#import "CaptureEnrollDelegate.h"
#import "DeleteFeatureDelegate.h"
#import "FlashDelegate.h"
#import "SCRDelegate.h"
#import "MSRDelegate.h"


//request cmd to yukey
#define BT_CMD_ENROLL               0x01
#define BT_CMD_IDENTIFY             0x02
#define BT_CMD_ABORT                0x03
#define BT_CMD_DELETE               0x04
#define BT_CMD_GET_IMAGE            0x05
#define BT_CMD_GET_ENROLL_LIST      0x06
#define BT_CMD_GET_VERSION          0x08
#define BT_CMD_CAPTURE_ENROLL       0x0E
#define BT_CMD_CAPTURE_VERIFY       0x0F
#define BT_CMD_FLASH_DEL            0x10
#define BT_CMD_FLASH_READ           0x11
#define BT_CMD_FLASH_WRITE          0x12
#define BT_CMD_FLASH_GET_KEY_LIST   0x13
#define BT_CMD_LOAD_SYSINFO         0x14
#define BT_CMD_GET_VOLTAGE          0x1B
#define BT_CMD_SCR_OPEN             0x20
#define BT_CMD_SCR_CLOSE            0x21
#define BT_CMD_SCR_ADPU             0x22
#define BT_CMD_MSR_READ             0x23

#define DT_CMD_TAG0 'y'
#define DT_CMD_TAG1 'u'
#define DT_CMD_TAG2 '+'

#define BLEBLUETOOTH_SEND_BUFFER_MAX 20

@interface YuKeyBT : NSObject{
    id delegate;
}

+(id)getInstance;
-(void) setDelegate:(id<VersionDelegate,
                        ErrorDelegate,
                        CaptureVerifyDelegate,
                        StatusDelegate,
                        CaptureEnrollDelegate,
                        DeleteFeatureDelegate,
                        FlashDelegate>)delegate;
-(void) scanAndConnect;
-(void) enroll:(NSString*)uid withDupCheck:(BOOL)flag;
-(void) identify;
-(void) abort;
-(void) deleteFeature:(NSString*)uid;
-(void) requestVersion;
-(void) requestVoltage;
-(void) requestSysinfo;
-(void) requestFingerprintImage;
-(BOOL) getEnrollList:(NSString*)uid;
-(void) requestFlashKeyList;
-(void) writeFlashData:(NSString*) key Value:(NSString*) value password: (NSString*)password;
-(void) requestFlashData:(NSString*) key password:(NSString*) password;
-(void) deleteFlashData:(NSString*)key password:(NSString*)password;
-(void) scrOpen;
-(void) scrClose;
-(void) scrAPDU:(NSString *)apduCmd;
-(BOOL) msrRead:(int) timeout;

-(void) setShowBleStateInfoListener:(void(^)(NSString* bleStateStr)) listener;
//-(void) setFlashReadListener:(void(^)(BOOL success, NSString* accountStr, NSString* passwdStr, NSString* errorLog)) flashReadListener;
-(void) setFlashReadListener:(void(^)(BOOL success, BlobData* blobData, NSString* errorLog)) flashReadListener;
-(void) setFlashKeyListListener:(void(^)(BOOL success, NSString* keyList ,NSString* errorLog)) flashKeyListListener ;
@end