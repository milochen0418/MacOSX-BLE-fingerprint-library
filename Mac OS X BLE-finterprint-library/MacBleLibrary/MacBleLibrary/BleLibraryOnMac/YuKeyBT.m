//
//  YuKeyBT.m
//  BleLibrary
//
//  Created by sheldon on 13/10/16.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import "YuKeyBT.h"
#import <IOBluetooth/IOBluetooth.h>
#import "ProprietaryService.h"

@interface YuKeyBT () <CBCentralManagerDelegate, CBPeripheralDelegate>

@property (strong, nonatomic) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) CBCharacteristic      *c2pCharacteristic;
@property (strong, nonatomic) CBCharacteristic      *p2cCharacteristic;

-(id) init;
-(void) write:(NSData*)sendData;
-(NSData*) convertYuKeyCommand: (const char []) cmd
                     andLength: (int) length;
-(void)onParser;
-(void)appendEnrollListString:(BYTE []) uid andLength:(int)length;
-(void)callBackToUI;
-(void)callBackWithBlobType:(int)blobType;

//add by milo
@property (nonatomic,copy) void (^mShowBleStateInfoListener)(NSString* bleStateStr);
@property (nonatomic,copy) void (^mFlashReadListener)(BOOL success, BlobData* blobData, NSString* errorLog);
@property (nonatomic,copy) void (^mFlashKeyListListener)(BOOL success, NSString* keyList, NSString* errorLog);




@end


@implementation YuKeyBT

//add by milo
@synthesize mShowBleStateInfoListener;
@synthesize mFlashReadListener;
@synthesize mFlashKeyListListener;

//add by milo
-(void) setShowBleStateInfoListener:(void(^)(NSString* bleStateStr)) listener {
    mShowBleStateInfoListener = listener;
}
-(void) setFlashReadListener:(void(^)(BOOL success, BlobData* blobData, NSString* errorLog)) listener {
    mFlashReadListener = listener;
}
-(void) setFlashKeyListListener:(void(^)(BOOL success, NSString *keyList, NSString* errorLog)) listener {
//    mFlashReadListener = listener;
    mFlashKeyListListener = listener;
}



enum DtState{
    DT_STATE_INIT,
    DT_STATE_WAIT_CHECKSUM,
    DT_STATE_WAIT_RESID,
    DT_STATE_WAIT_VERSION,
    DT_STATE_WAIT_VOLTAGE,
    DT_STATE_WAIT_ENROLL_COUNT,
    DT_STATE_WAIT_DATA_LENGTH,
    DT_STATE_WAIT_DATA,
    DT_STATE_WAIT_IMAGE_INFO,
    DT_STATE_WAIT_BLOB_INFO,
    DT_STATE_WAIT_BLOB
} mmDtState = DT_STATE_INIT;

BYTE mmRes, mmChecksum;

NSString *version = nil;
//    int voltage = 0;
BYTE mCount=0;
int mmDataLen=0;
NSString *mEnrollListID=nil;
NSString *mFilterID=nil;
NSString *mKeyList=nil;
NSString *mMatchedUserID=nil;
short mImgHeight=0;
short mImgWidth=0;
int mBlobType=0;
BlobData *mBlobData;
int mmBlobRead=0;

int flashAction;

#pragma mark - my public methods

+(id) getInstance{
    static YuKeyBT *btMgr = nil;
    @synchronized(self){
        if (btMgr == nil) {
            btMgr = [[self alloc] init];
        }
    }
    return btMgr;
}

-(id) init{
    
    self = [super init];
    if(self){
        // Start up the CBCentralManager
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        _discoveredPeripheral = nil;
    }
    return self;
}

-(void) scanAndConnect{
    if(!_discoveredPeripheral){
        
        [self.centralManager scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:TAXEIA_SERVICE_UUID]]
                                                   options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@NO}];
        
        NSLog(@"Scanning started");
        //add by milo
        if(mShowBleStateInfoListener != nil) {
            mShowBleStateInfoListener(@"Scanning started");
        }
        
        
    } else {
        [self.centralManager cancelPeripheralConnection:_discoveredPeripheral];
        
    }

}

-(void) enroll:(NSString*)user_id withDupCheck:(BOOL)flag{
 
    NSUInteger dupBit = ((flag == YES) ? 0x01 : 0x00);
    char newCmdBuf[[user_id length]+3];
    memset(newCmdBuf, 0x00, [user_id length]+3);
    const char cmd[] = {BT_CMD_ENROLL, '\0'};
    memcpy(newCmdBuf, cmd, 1);
    const char dupAndIDLen[] = {dupBit, [user_id length]};
    memcpy(&newCmdBuf[1], dupAndIDLen, 2);
    memcpy(&newCmdBuf[3], [user_id UTF8String], [user_id length]);
    
    // appedn result
    for(int i = 0 ; i < [user_id length]+3 ;i++)
        NSLog(@"%02X", newCmdBuf[i]);
    
    [self write:[self convertYuKeyCommand:newCmdBuf andLength:sizeof(newCmdBuf)/sizeof(char)]];
}

-(void) identify{
    
    const char cmd[] = {BT_CMD_IDENTIFY, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(void) abort{
    const char cmd[] = {BT_CMD_ABORT, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(void) deleteFeature:(NSString *)uid{
    if ([uid length] > 1) {
        NSString *tmpStr = @"*";
        uid = [tmpStr stringByAppendingString:uid];
    }
    
    char newCmdBuf[[uid length]+2];
    memset(newCmdBuf, 0x00, [uid length]+2);
    const char cmd[] = {BT_CMD_DELETE, [uid length], '\0'};
    strcat(newCmdBuf, cmd);
    strcat(newCmdBuf, [uid UTF8String]);
    
    // appedn result
    for(int i = 0 ; i < [uid length]+2 ;i++)
        NSLog(@"deleteFeature cmd: %02X", newCmdBuf[i]);
    
    NSLog(@"delete length: %lu", (unsigned long)[uid length]);
    [self write:[self convertYuKeyCommand:newCmdBuf andLength:strlen(newCmdBuf)]];
    
}

-(void) requestVersion{
    
    const char cmd[] = {BT_CMD_GET_VERSION, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(void) requestVoltage{
    const char cmd[] = {BT_CMD_GET_VOLTAGE, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(void) requestSysinfo{
    const char cmd[] = {BT_CMD_LOAD_SYSINFO, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(void) requestFingerprintImage{
    char cmd[] = {BT_CMD_GET_IMAGE, 0x00, 0x00, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(void) requestFlashKeyList{
    mKeyList = nil;
    char cmd[] = {BT_CMD_FLASH_GET_KEY_LIST, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(BOOL) getEnrollList:(NSString *)uid{
    mEnrollListID=nil;
    if([uid length] == 0) return NO;
    if ([uid rangeOfString:@"*"].location != NSNotFound) {
        NSLog(@"string contain *");
        mFilterID = @"";
    }else{
        NSLog(@"string not contain *");
        mFilterID = [uid stringByAppendingString:@"_"];
    }
    NSLog(@"uid.length=%lu", (unsigned long)[mFilterID length]);
    
    char newCmdBuf[[mFilterID length]+2];
    memset(newCmdBuf, 0x00, [mFilterID length]+2);
    const char cmd[] = {BT_CMD_GET_ENROLL_LIST, [mFilterID length], '\0'};

    strcat(newCmdBuf, cmd);
    strcat(newCmdBuf, [mFilterID UTF8String]);

    [self write:[self convertYuKeyCommand:newCmdBuf andLength:strlen(newCmdBuf)]];
    
    return YES;
}

-(void) writeFlashData:(NSString *)key Value:(NSString *)value password:(NSString *)password{
    
    const int valueLen =2;
    char newCmdBuf[3+valueLen+[key length]+[value length]+[password length]];
    memset(newCmdBuf, 0x00, sizeof(newCmdBuf)/sizeof(char));
    const char cmd[] = {BT_CMD_FLASH_WRITE, '\0'};
    strcat(newCmdBuf, cmd);
    
    const char keyLen[] = {[key length],'\0'};
    strcat(newCmdBuf, keyLen);
    strcat(newCmdBuf, [key UTF8String]);

    const char pwdLen[] = {[password length], '\0'};
    strcat(newCmdBuf, pwdLen);
    strcat(newCmdBuf, [password UTF8String]);
   
    int intValue = [value length];
    char valueBytes[valueLen];
    valueBytes[1] = (intValue >> 16) & 0xFF;
    valueBytes[0] = intValue & 0xFF;
    //NSLog(@"%x %x", valueBytes[0], valueBytes[1]);

    memcpy(&newCmdBuf[1+1+[key length]+1+[password length]], valueBytes, valueLen);
    memcpy(&newCmdBuf[1+1+[key length]+1+[password length]+valueLen], [value UTF8String], [value length]);

    /*
    // appedn result
    for(int i = 0 ; i < sizeof(newCmdBuf)/sizeof(char) ;i++)
        NSLog(@"%02X", newCmdBuf[i]);
    */
    
    [self write:[self convertYuKeyCommand:newCmdBuf andLength:sizeof(newCmdBuf)/sizeof(char)]];
  }

-(void) requestFlashData:(NSString *)key password:(NSString *)password{
    
    flashAction = BT_CMD_FLASH_READ;
    
    char newCmdBuf[3+[key length]+[password length]];
    memset(newCmdBuf, 0, 3+[key length]+[password length]);
    const char cmd[] = {BT_CMD_FLASH_READ, '\0'};
    strcat(newCmdBuf, cmd);
    
    const char keyLen[] = {[key length],'\0'};
    strcat(newCmdBuf, keyLen);
    strcat(newCmdBuf, [key UTF8String]);
    
    const char pwdLen[] = {[password length], '\0'};
    strcat(newCmdBuf, pwdLen);
    strcat(newCmdBuf, [password UTF8String]);
    
    /*
     // appedn result
     for(int i = 0 ; i < sizeof(newCmdBuf)/sizeof(char) ;i++)
     NSLog(@"%02X", newCmdBuf[i]);
    */
    
    [self write:[self convertYuKeyCommand:newCmdBuf andLength:sizeof(newCmdBuf)/sizeof(char)]];
    
}

-(void) deleteFlashData:(NSString *)key password:(NSString *)password{
    
    flashAction = BT_CMD_FLASH_DEL;
    
    char newCmdBuf[3+[key length]+[password length]];
    memset(newCmdBuf, 0, 3+[key length]+[password length]);
    const char cmd[] = {BT_CMD_FLASH_DEL, '\0'};
    strcat(newCmdBuf, cmd);
    
    const char keyLen[] = {[key length],'\0'};
    strcat(newCmdBuf, keyLen);
    strcat(newCmdBuf, [key UTF8String]);
    const char pwdLen[] = {[password length], '\0'};
    strcat(newCmdBuf, pwdLen);
    strcat(newCmdBuf, [password UTF8String]);
    
    [self write:[self convertYuKeyCommand:newCmdBuf andLength:sizeof(newCmdBuf)/sizeof(char)]];
    
}

-(void) scrOpen{
    const char cmd[] = {BT_CMD_SCR_OPEN, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(void) scrClose{
    const char cmd[] = {BT_CMD_SCR_CLOSE, '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
}

-(BOOL) msrRead:(int) timeout{
    
    if (timeout<=0) return NO;
    
    char newCmdBuf[2];
    memset(newCmdBuf, 0x00, 2);
    const char cmd[] = {BT_CMD_MSR_READ,(Byte)(timeout & 0xFF), '\0'};
    [self write:[self convertYuKeyCommand:cmd andLength:strlen(cmd)]];
    return YES;
}

-(void) scrAPDU:(NSString *)apduCmd{
    apduCmd=[apduCmd stringByReplacingOccurrencesOfString:@" " withString:@""];
    char * cByteCmd = [self HexToByteArray:apduCmd];
    
    char newCmdBuf[3+[apduCmd length]/2];
    memset(newCmdBuf, 0, 3+[apduCmd length]/2);
    const char cmd[] = {BT_CMD_SCR_ADPU, '\0'};
    strcat(newCmdBuf, cmd);

    const char cmdLen[] = {[apduCmd length]/2 & 0xFF,[apduCmd length]/2 >>8 & 0xFF,'\0'};
    memcpy(&newCmdBuf[1], cmdLen, sizeof(cmdLen)/sizeof(char));
    memcpy(&newCmdBuf[sizeof(cmdLen)/sizeof(char)], cByteCmd, [apduCmd length]/2);

    for (int i = 0; i<sizeof(newCmdBuf)/sizeof(char); i++) {
        NSLog(@"%02X", newCmdBuf[i]);
    }
    NSLog(@"newCmdBuf len: %lu",sizeof(newCmdBuf)/sizeof(char));
    [self write:[self convertYuKeyCommand:newCmdBuf andLength:sizeof(newCmdBuf)/sizeof(char)]];
}

-(void) setDelegate:(id<VersionDelegate,
                        ErrorDelegate,
                        CaptureVerifyDelegate,
                        StatusDelegate,
                        CaptureEnrollDelegate,
                        DeleteFeatureDelegate,
                        FlashDelegate,
                        SCRDelegate,
                        MSRDelegate>)adelegate{
    delegate = adelegate;
}

#pragma mark - my private methods

-(void) write:(NSData*)sendData{
    
    //NSLog(@"sedn str: %@", sendData);
    //NSData  *data_to_send = [string_to_send dataUsingEncoding:NSUTF8StringEncoding];
    //NSData *data_to_send = [NSData dataWithBytes:(const void *)sendData length:(NSUInteger)sizeof(sendData)];
    NSLog(@"sendData: %@", sendData);
    
    /*
     [_discoveredPeripheral writeValue:data_to_send
     forCharacteristic:_c2pCharacteristic
     type:CBCharacteristicWriteWithoutResponse];
     */
    
    
    if([sendData length] <= BLEBLUETOOTH_SEND_BUFFER_MAX){
    
        [_discoveredPeripheral writeValue:sendData
                        forCharacteristic:_c2pCharacteristic
                                     type:CBCharacteristicWriteWithResponse];
    }else{
        int len = [sendData length];
        int remainder = [sendData length] % BLEBLUETOOTH_SEND_BUFFER_MAX;
        int loop=0;
        NSRange range;
        do {
            range = NSMakeRange(BLEBLUETOOTH_SEND_BUFFER_MAX*loop, BLEBLUETOOTH_SEND_BUFFER_MAX);
            UInt8 buf[range.length];
            memset(buf, 0, range.length);
            [sendData getBytes:buf range:range];
            NSData *result = [[NSData alloc] initWithBytes:buf length:sizeof(buf)];
            NSLog(@"write vaule: %@", result);
            [_discoveredPeripheral writeValue:result
                            forCharacteristic:_c2pCharacteristic
                                         type:CBCharacteristicWriteWithResponse];
            loop++;
        } while ((len-=BLEBLUETOOTH_SEND_BUFFER_MAX) > BLEBLUETOOTH_SEND_BUFFER_MAX);
        range = NSMakeRange(BLEBLUETOOTH_SEND_BUFFER_MAX*loop, remainder);
        UInt8 buf[range.length];
        memset(buf, 0, range.length);
        [sendData getBytes:buf range:range];
        NSData *result = [[NSData alloc] initWithBytes:buf length:sizeof(buf)];
        NSLog(@"write vaule: %@", result);
        [_discoveredPeripheral writeValue:result
                        forCharacteristic:_c2pCharacteristic
                                     type:CBCharacteristicWriteWithResponse];

    }
}

/**
 add yu+ at begin and checksum at end
*/
-(NSData*) convertYuKeyCommand: (const char []) cmd andLength:(int)length{
    char newCmd[length+4];
    memset(newCmd, 0x00, length+4);
    const char *c = "yu+";
    strcat(newCmd, c);
    memcpy(&newCmd[3], cmd, length);
    
    char *checkSum =(char *) cmd;
    if(length > 1){
        for(int i = 1 ; i < length ; i ++){
            *checkSum ^= cmd[i];
        }
    }
    memcpy(&newCmd[3+length], checkSum, 1);
    
    // appedn result
    for(int i = 0 ; i < length+4 ;i++)
        NSLog(@"%02X", newCmd[i]);
    
    NSData *data = [NSData dataWithBytes:(const void *)newCmd length:(NSUInteger)sizeof(newCmd)];
    NSLog(@"senddata: %@", data);
    NSLog(@"length: %lu", (unsigned long)data.length);
    return data;
}

-(void) appendEnrollListString:(BYTE [])uid andLength:(int)length{
    NSLog(@"appendEnrollListString:andLength:");
    
    NSString *fid = [[NSString alloc] initWithBytes:uid
                                      length:length
                                      encoding:NSASCIIStringEncoding];
    NSLog(@"enroll id = %@", fid);
    if (mEnrollListID == nil) {
        mEnrollListID = fid;
    }else{
        mEnrollListID = [mEnrollListID stringByAppendingString:@";"];
        mEnrollListID = [mEnrollListID stringByAppendingString:fid];
    }
    NSLog(@"mEnrollListID=%@", mEnrollListID);
}

-(void) callBackToUI{
    NSLog(@"CallBackToUI: %02X", mmRes);
    switch (mmRes) {
        case BT_RES_VERSION:
            [delegate getVersion:version];
            break;
        case BT_RES_VOLTAGE:
            
            break;
        case BT_RES_ENROLL_COUNT:
            [delegate onProgress];
            break;
        case BT_RES_MATCHED_OK:
            [delegate onMatchedUser:mMatchedUserID];
            break;
        case BT_RES_MATCHED_FAIL:
            [delegate onMatchedUser:nil];
            break;
        case BT_RES_KEY_LIST:
            [delegate onFlashKeyList:mKeyList];
            //add by milo
            if(mFlashKeyListListener != nil) {
                mFlashKeyListListener(YES, mKeyList, nil);
            }
            break;
        case BT_RES_FINGER_LIST:
            [delegate onEnrollListString:mEnrollListID];
            break;
        case BT_RES_GETTING_IMAGE:
            [delegate onFingerFetch];
            break;
        case BT_RES_EXTRACTING_FEATURE:
            
            break;
        case BT_RES_DELETE_OK:
            [delegate onDeleteFeatureStatus:YES];
            break;
        case BT_RES_DELETE_FAIL:
            [delegate onDeleteFeatureStatus:NO];
            break;
        case BT_RES_ENROLL_OK:
            [delegate onSuccess];
            break;
        case BT_RES_ENROLL_FAIL:
            [delegate onFail:BT_RES_ENROLL_FAIL];
            break;
        case BT_RES_ENROLL_DUPLICATED:
            [delegate onFail:BT_RES_ENROLL_DUPLICATED];
            break;
        case BT_RES_NEED_AUTHORIZED:
            [delegate onStatus:BT_RES_NEED_AUTHORIZED];
            break;
        case BT_RES_IMAGE_TOO_HEAVY:
        case BT_RES_IMAGE_TOO_LIGHT:
        case BT_RES_GETTED_IMAGE_TOO_SHORT:
        case BT_RES_GETTED_IMAGE_FAIL:
        case BT_RES_GETTED_BAD_IMAGE:
        case BT_RES_GETTED_GOOD_IMAGE:
            [delegate onBadImage:mmRes];
            break;
        case BT_RES_ABORT_OK:
            [delegate onUserAbort:YES];
            break;
        case BT_RES_ABORT_FAIL:
            [delegate onUserAbort:NO];
            break;
        case BT_RES_FLASH_WRITE_OK:
            [delegate onFlashWriteStatus:YES];
            break;
        case BT_RES_FLASH_WRITE_FAIL:
            [delegate onFlashWriteStatus:NO];
            break;
        case BT_RES_FLASH_READ_OK:
            [delegate onFlashReadStatus:BT_RES_FLASH_READ_OK];
            //[delegate onFlashData:mBlobData];
            break;
        case BT_RES_FLASH_READ_FAIL:
            //change by milo
//            (flashAction == BT_CMD_FLASH_READ)?[delegate onFlashReadStatus:BT_RES_FLASH_READ_FAIL]:[delegate onFlashDelStatus:BT_RES_FLASH_READ_FAIL];
            if(flashAction == BT_CMD_FLASH_READ) {
                [delegate onFlashReadStatus:BT_RES_FLASH_READ_FAIL];
                if(mFlashReadListener != nil ) {
                    mFlashReadListener(NO,nil,@"BT_RES_FLASH_READ_FAIL");
                }
            }
            else {
                [delegate onFlashDelStatus:BT_RES_FLASH_READ_FAIL];
            }
            break;
        case BT_RES_FLASH_DATA_NOT_FOUND:
            //change by milo
//            (flashAction == BT_CMD_FLASH_READ)?[delegate onFlashReadStatus:BT_RES_FLASH_DATA_NOT_FOUND]:[delegate onFlashDelStatus:BT_RES_FLASH_DATA_NOT_FOUND];
            if(flashAction == BT_CMD_FLASH_READ) {
                [delegate onFlashReadStatus:BT_RES_FLASH_DATA_NOT_FOUND];
                if(mFlashReadListener != nil ) {
                    mFlashReadListener(NO,nil,@"BT_RES_FLASH_DATA_NOT_FOUND");
                }
            }
            else {
                [delegate onFlashDelStatus:BT_RES_FLASH_DATA_NOT_FOUND];
            }
            break;
        case BT_RES_FLASH_DELETE_OK:
            [delegate onFlashDelStatus:BT_RES_FLASH_DELETE_OK];
            break;
        case BT_RES_FLASH_DELETE_FAIL:
            [delegate onFlashDelStatus:BT_RES_FLASH_DELETE_FAIL];
            break;
        case BT_RES_INVALID_PASSWORD:
            [delegate onFlashDelStatus:BT_RES_INVALID_PASSWORD];
            break;
        case BT_CR_RES_SCR_OPEN_OK:
            [delegate onSCROpenStatus:BT_CR_RES_SCR_OPEN_OK];
            break;
        case BT_CR_RES_SCR_OPEN_FAIL:
            [delegate onSCROpenStatus:BT_CR_RES_SCR_OPEN_FAIL];
            break;
        case BT_CR_RES_SCR_CLOSE_OK:
            [delegate onSCRCloseOK];
            break;
        case BT_CR_RES_MSR_READ_OK:
            [delegate onMSRReadStatus:BT_CR_RES_MSR_READ_OK];
            break;
        case BT_CR_RES_MSR_READ_FAIL:
            [delegate onMSRReadStatus:BT_CR_RES_MSR_READ_FAIL];
            break;
        case BT_CR_RES_MSR_READ_TIMEOUT:
            [delegate onMSRTimeout];
            break;
        case BT_CR_RES_SCR_APDU_OK:
            [delegate onSendAPDUCmdStatus:BT_CR_RES_SCR_APDU_OK];
            break;
        case BT_CR_RES_SCR_APDU_FAIL:
            [delegate onSendAPDUCmdStatus:BT_CR_RES_SCR_APDU_FAIL];
            break;
    }
    
}

-(void)callBackWithBlobType:(int)blobType{
 
    NSLog(@"blobType is %d", blobType);
    switch (blobType) {
        case BLOB_TYPE_IMAGE:
            
            break;
        case BLOB_TYPE_ENROLL_FEATURE:
            
            break;
        case BLOB_TYPE_VERIFY_FEATURE:
            
            break;
        case BLOB_TYPE_FLASH_DATA:
            [delegate onFlashData:mBlobData];
            //add by milo
            if(mFlashReadListener!=nil ) {
                mFlashReadListener(YES,mBlobData,@"Read data ok");
            }
            break;
        case BLOB_TYPE_AES_ENCRYPTED_DATA:
            
            break;
        case BLOB_TYPE_AES_DECRYPTED_DATA:
            
            break;
        case BLOB_TYPE_RSA_ENCRYPTED_DATA:
            
            break;
        case BLOB_TYPE_RSA_DECRYPTED_DATA:
            
            break;
        case BLOB_TYPE_SIGNATURE_DATA:
            
            break;
        case BLOB_TYPE_RSA_PUBLIC_KEY:
            
            break;
        case BLOB_TYPE_SYS_INFO:
            
            break;
        case BLOB_TYPE_APDU_DATA:
            [delegate onReturnAPDUData:mBlobData];
            break;
        case BLOB_TYPE_MSR_DATA:
            [self splitMSRData:mBlobData];
            break;
    }
    
}

-(void)onParser{
    NSLog(@"onParser");
    
parser_begin:
    while (true) {
        switch (mmDtState) {
            
            case DT_STATE_INIT:{
                while (true) {
                    if (queue_len() < 3) return;
                    if (queue_get() != DT_CMD_TAG0) continue;
                    if (queue_get() != DT_CMD_TAG1) continue;
                    if (queue_get() != DT_CMD_TAG2) continue;
                    mmDtState = DT_STATE_WAIT_RESID;
                    goto parser_begin;
                }
            } // end of case DT_STATE_INIT
                
            case DT_STATE_WAIT_RESID:{ //result ID
                if(queue_len() < 1) return;
                mmChecksum = mmRes = queue_get();
                if(mmRes != BT_RES_SENSOR_TIMEOUT)
                    NSLog(@"res=%@", [BleBTRes BleToString:mmRes]);
                
                NSLog(@"DT_STATE_WAIT_RESID");
                switch (mmRes) {
                    case BT_RES_ABORT_OK:
                    case BT_RES_CMD_ACK:
                    case BT_RES_COMMAND_ERROR:
                    case BT_RES_CHECKSUM_FAIL:
                    case BT_RES_NO_BATTERY:
                    case BT_CR_RES_SCR_OPEN_OK:
                    case BT_CR_RES_SCR_OPEN_FAIL:
                    case BT_CR_RES_SCR_CLOSE_OK:
                    case BT_CR_RES_MSR_READ_OK:
                    case BT_CR_RES_MSR_READ_FAIL:
                    case BT_CR_RES_MSR_READ_TIMEOUT:
                    case BT_CR_RES_SCR_APDU_OK:
                    case BT_CR_RES_SCR_APDU_FAIL:
                    {
                        mmDtState = DT_STATE_WAIT_CHECKSUM;
                        //if(mmRes != BT_RES_CMD_ACK){
                        //    [delegate Error:[BleBTRes BleToString:mmRes]];
                        //}
                        
                        goto parser_begin;
                    }
                        
                    case BT_RES_ENROLL_COUNT:{
                        mmDtState = DT_STATE_WAIT_ENROLL_COUNT;
                        goto parser_begin;
                    }
                    
                    case BT_RES_MATCHED_OK:
                    case BT_RES_ENROLL_DUPLICATED:{
                        mmDtState = DT_STATE_WAIT_DATA_LENGTH;
                        goto parser_begin;
                    }
                    
                    case BT_RES_IMAGE_INFO:{
                        mmDtState = DT_STATE_WAIT_IMAGE_INFO;
                        goto  parser_begin;
                    }
                    
                    case BT_RES_BLOB:{
                        mmDtState = DT_STATE_WAIT_BLOB_INFO;
                        goto parser_begin;
                    }
                        
                    case BT_RES_FINGER_LIST:
                    case BT_RES_KEY_LIST:{
                        mmDtState = DT_STATE_WAIT_DATA_LENGTH;
                        NSLog(@"BT_RES_FINGER_LIST/BT_RES_KEY_LIST:%02X : DT_STATE_WAIT_DATA_LENGTH", mmRes);
                        goto parser_begin;
                    }
                        
                    case BT_RES_VERSION:{
                        mmDtState = DT_STATE_WAIT_VERSION;
                        goto parser_begin;
                    }
                        
                    case BT_RES_VOLTAGE:{
                        mmDtState = DT_STATE_WAIT_VOLTAGE;
                        goto parser_begin;
                    }
                        
                    case BT_RES_FLASH_WRITE_OK:
                    case BT_RES_FLASH_WRITE_FAIL:
                    case BT_RES_FLASH_DELETE_OK:
                    case BT_RES_FLASH_DELETE_FAIL:
                    case BT_RES_FLASH_READ_FAIL:
                    case BT_RES_FLASH_DATA_NOT_FOUND:
                    case BT_RES_INVALID_PASSWORD:{
                        mmDtState = DT_STATE_WAIT_CHECKSUM;
                        goto parser_begin;
                    }
                        
                        
                } // end of switch(mmRes)
                
                mmDtState = DT_STATE_WAIT_CHECKSUM;
                goto parser_begin;
                
            } // end of case DT_STATE_WAIT_RESID
            
            case DT_STATE_WAIT_VERSION:{
                if(queue_len() < 4) return;
                BYTE buf[4];
                
                memset(buf, 0x00, strlen((const char*)buf));
                for (int i = 0; i < 4; i++) {
                    buf[i] = queue_get();
                    mmChecksum ^= buf[i]; // compute the checksum
                }
                
                //NSLog(@"the checksum is %02X", mmChecksum);
                mmDtState = DT_STATE_WAIT_CHECKSUM;
                version = [NSString stringWithFormat:@"%d.%d.%d.%d", buf[3], buf[2], buf[1], buf[0]];
                //NSLog(@"version: %@", version);
                goto parser_begin;
            } // end of case DT_STATE_WAIT_VERSION
            
            case DT_STATE_WAIT_VOLTAGE:{
                if(queue_len() < 2) return;
                mmDtState = DT_STATE_WAIT_CHECKSUM;
                /*
                int v = queue_get_short();
                if(v >= BT_VOLTAGE_MAX){
                    voltage = 100;
                }else if(v <= BT_VOLTAGE_MIN){
                    voltage = 0;
                }else{
                    voltage = (v - BT_VOLTAGE_MIN)*100/(BT_VOLTAGE_MAX - BT_VOLTAGE_MIN);
                }
                */
            } // end of case DT_STATE_WAIT_VOLTAGE
             
            case DT_STATE_WAIT_ENROLL_COUNT:{
                if(queue_len() < 1) return;
                mCount = queue_get();
                mmChecksum ^= mCount;
                NSLog(@"ENROLL_COUNT: %hhu", mCount);
                mmDtState = DT_STATE_WAIT_CHECKSUM;
                goto parser_begin;
            } // end of case DT_STATE_WAIT_ENROLL_COUNT
            
            case DT_STATE_WAIT_DATA_LENGTH:{
                if(queue_len() < 1) return;
                mmDataLen = queue_get();
                NSLog(@"mmDataLen: %02X", mmDataLen);
                mmChecksum ^= mmDataLen;
                if (mmDataLen<=0) {
                    mmDtState = DT_STATE_WAIT_CHECKSUM;
                    mmChecksum ^= mmDataLen;
//                    /[self callBackToUI];
                }else{
                    mmDtState = DT_STATE_WAIT_DATA;
                    NSLog(@"DT_STATE_WAIT_DATA_LENGTH: get data len=%d", mmDataLen);
                }
                goto parser_begin;
            } // end of case DT_STATE_WAIT_DATA_LENGTH
            
            case DT_STATE_WAIT_DATA:{
                NSLog(@"DT_STATE_WAIT_DATA");
                NSLog(@"mmDataLen=%d", mmDataLen);
                NSLog(@"queue len: %d", queue_len());
                if (queue_len() < mmDataLen) return;
                BYTE buf[mmDataLen];
                memset(buf, 0x00, mmDataLen);
                for (int i = 0; i < mmDataLen; i++){
                    buf[i] = queue_get();
                    NSLog(@"DATA: %02X", buf[i]);
                    mmChecksum ^= buf[i];
                }
                if (mmRes == BT_RES_FINGER_LIST) {
                    [self appendEnrollListString:buf andLength:mmDataLen];
                }else if(mmRes == BT_RES_KEY_LIST){
                    NSString *key = [[NSString alloc] initWithBytes:buf
                                                      length:sizeof(buf)
                                                      encoding:NSASCIIStringEncoding];
                    
                    NSLog(@"key: %@", key);
                    if (mKeyList == nil){
                        mKeyList = key;
                    }else{
                        mKeyList = [mKeyList stringByAppendingString:@";"];
                        mKeyList = [mKeyList stringByAppendingString:key];
                    }
                }else if (mmRes == BT_RES_MATCHED_OK){
                    mMatchedUserID = [[NSString alloc] initWithBytes:buf
                                                       length:sizeof(buf)
                                                       encoding:NSASCIIStringEncoding];
                    
                }
                mmDtState = ((mmRes == BT_RES_FINGER_LIST) || (mmRes == BT_RES_KEY_LIST))
                             ? DT_STATE_WAIT_DATA_LENGTH : DT_STATE_WAIT_CHECKSUM;

                goto parser_begin;
                
            } //end of DT_STATE_WAIT_DATA_LENGTH
            
            case DT_STATE_WAIT_IMAGE_INFO:{
                if (queue_len() < 4) return;
                mImgHeight = queue_get_short();
                mImgWidth = queue_get_short();
                mmChecksum ^= mImgHeight;
                mmChecksum ^= mImgWidth;
                NSLog(@"Width = %d, Height = %d", mImgWidth, mImgHeight);
                mmDtState = DT_STATE_WAIT_CHECKSUM;
                goto parser_begin;
            }
             
            case DT_STATE_WAIT_BLOB_INFO:{
                if(queue_len() < 5) return;
                mBlobType = queue_get();
                NSLog(@"blobType %d", mBlobType);
                mmChecksum ^= mBlobType;
                int len = queue_get_int();
                NSLog(@"DT_STATE_WAIT_BLOB_INFO: %d", len);
                mmChecksum ^= len;
                NSLog(@"Blob Type=%@,Length=%@", [NSNumber numberWithInt:mBlobType],[NSNumber numberWithInt:len]);
                mBlobData = malloc(sizeof(BlobData));
                mBlobData->length = len;
                mBlobData->data = malloc(len*sizeof(BYTE));
                memset(mBlobData->data, 0, len);
                NSLog(@"DT_STATE_WAIT_BLOB_INFO, len=%lu", len*sizeof(BYTE));
                mmBlobRead = 0;
                mmDtState = DT_STATE_WAIT_BLOB;
                goto parser_begin;
            } // end case of DT_STATE_WAIT_BLOB_INFO
            
            case DT_STATE_WAIT_BLOB:{
                int count = queue_len();
                if (count < mBlobData->length) return;

                NSLog(@"count: %d", count);
                NSLog(@"DT_STATE_WAIT_BLOB, len=%d", mBlobData->length);
                for(int i=0 ; i<count ; i++){
                    if (mmBlobRead < mBlobData->length) {
                        mBlobData->data[i] = queue_get();
                        NSLog(@"aaa %02X", mBlobData->data[i]);
                        mmChecksum ^= mBlobData->data[i];
                        mmBlobRead++;
                    }
                }
                if (mmBlobRead >= mBlobData->length){
                    mBlobData->data[mmBlobRead] = '\0';
                    mmDtState = DT_STATE_WAIT_CHECKSUM;
                }
                goto parser_begin;
            } // end of DT_STATE_WAIT_BLOB
                
            case DT_STATE_WAIT_CHECKSUM:{
                if(queue_len() < 1) return;
                mmDtState = DT_STATE_INIT;
                NSLog(@"mmChecksum: %02X", mmChecksum);
                BYTE cmpToChecksum = queue_get();
                NSLog(@"queue_get: %02X", cmpToChecksum);
                if(mmChecksum != cmpToChecksum){
                    [delegate Error:[BleBTRes BleToString:BT_RES_CHECKSUM_FAIL]];
                }else{
                    
                    (mmRes == BT_RES_BLOB) ? [self callBackWithBlobType:mBlobType] : [self callBackToUI];
                    
                }
                goto parser_begin;
            } // end of DT_STATE_WAIT_CHECKSUM
                
        } // end of switch
        
    } // end of while loop

}


#pragma mark - CentralManager Delegate

/** This callback comes whenever a peripheral that is advertising the TAXEIA_SERVICE_UUID is discovered.
 *  We check the RSSI, to make sure it's close enough that we're interested in it, and if it is,
 *  we start the connection process
 */
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    NSLog(@"didDiscoverPeripheral");
    /*
     // Reject any where the value is above reasonable range
     if (RSSI.integerValue > -15) {
     return;
     }
     
     // Reject if the signal strength is too low to be close enough (Close is around -22dB)
     if (RSSI.integerValue < -35) {
     return;
     }
     */
    
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);
    
    // Stop scanning
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    // Ok, it's in range - have we already seen it?
    if (self.discoveredPeripheral != peripheral) {
        
        // Save a local copy of the peripheral, so CoreBluetooth doesn't get rid of it
        self.discoveredPeripheral = peripheral;
        
        // And connect
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
        
        //_label_status.text = @"Connecting...";
    }

}


/** centralManagerDidUpdateState is a required protocol method.
 *  Usually, you'd check for other states to make sure the current device supports LE, is powered on, etc.
 *  In this instance, we're just using it to wait for CBCentralManagerStatePoweredOn, which indicates
 *  the Central is ready to be used.
 */


- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    
    //add by milo
    void (^listener )(NSString* bleStateStr)=  mShowBleStateInfoListener;
    
    NSLog(@"centralManagerDidUpdateState");
    
    NSMutableString* nsmstring=[NSMutableString stringWithString:@"BleState:"];
    
    switch (central.state) {
        case CBCentralManagerStateUnknown:
            [nsmstring appendString:@"Unknown\n"];
            break;
        case CBCentralManagerStateUnsupported:
            [nsmstring appendString:@"Unsupported\n"];
            break;
        case CBCentralManagerStateUnauthorized:
            [nsmstring appendString:@"Unauthorized\n"];
            break;
        case CBCentralManagerStateResetting:
            [nsmstring appendString:@"Resetting\n"];
            break;
        case CBCentralManagerStatePoweredOff:
            [nsmstring appendString:@"PoweredOff\n"];
            break;
        case CBCentralManagerStatePoweredOn:
            [nsmstring appendString:@"PoweredOn\n"];
            break;
        default:
            [nsmstring appendString:@"none\n"];
            break;
    }

    NSLog(@"%@",nsmstring);
    //add by milo
    if(listener != nil) {
        listener(nsmstring);
    }
    
}


/** If the connection fails for whatever reason, we need to deal with it.
 */
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"didFailToConnectPeripheral");
    NSLog(@"Failed to connect to %@. (%@)", peripheral, [error localizedDescription]);
}

/** We've connected to the peripheral, now we need to discover the services and characteristics to find the 'transfer' characteristic.
 */
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"Peripheral Connected");
    
    //_label_status.text = @"Peripheral Connected";
    //[_button_scan setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    // Make sure we get the discovery callbacks
    peripheral.delegate = self;
    
    // Search only for services that match our UUID
    [peripheral discoverServices:@[[CBUUID UUIDWithString:TAXEIA_SERVICE_UUID]]];
    
    //[delegate onDeviceConnected];
    
}

/** Once the disconnection happens, we need to clean up our local copy of the peripheral
 */
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"Peripheral Disconnected");
    
    //_label_status.text = @"Peripheral Disconnected";
    //[_button_scan setTitle:@"Scan" forState:UIControlStateNormal];
    
    self.discoveredPeripheral = nil;
    self.p2cCharacteristic = nil;
    self.c2pCharacteristic = nil;
    [delegate onDeviceDisConnected];
}

#pragma mark - Peripheral Delegate

/** The Transfer Service was discovered
*/
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices");
    
    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        return;
    }
    
    // Discover the characteristic we want...
    
    // Loop through the newly filled peripheral.services array, just in case there's more than one.
    for (CBService *service in peripheral.services) {
        
        // We are only interested in our proprietary service
        if([service.UUID isEqual:[CBUUID UUIDWithString:TAXEIA_SERVICE_UUID]]) {
            
            NSArray *characteristicArray = [NSArray arrayWithObjects:[CBUUID UUIDWithString:P2C_CHARACTERISTIC_UUID],
                                            [CBUUID UUIDWithString:C2P_CHARACTERISTIC_UUID],
                                            nil];
            
            [peripheral discoverCharacteristics:characteristicArray forService:service];
            
            break;
        }
    }
    
}

/** The Transfer characteristic was discovered.
 *  Once this has been found, we want to subscribe to it, which lets the peripheral know we want the data it contains
 */
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    NSLog(@"didDiscoverCharacteristicsForService");
    // Deal with errors (if any)
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    // Again, we loop through the array, just in case.
    for (CBCharacteristic *characteristic in service.characteristics) {
        
        // If this characteristic is P2C, then we can subscribe to it.
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:P2C_CHARACTERISTIC_UUID]]) {
            
            // If it is, subscribe to it
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
            
            _p2cCharacteristic = characteristic;
        }
        
        // If this characteristic is C2P, save it for further use.
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:C2P_CHARACTERISTIC_UUID]]) {
            _c2pCharacteristic = characteristic;
        }
        
    }
    
    // Once this is complete, we just need to wait for the data to come in.
}


/** This callback lets us know more data has arrived via notification on the characteristic
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateValueForCharacteristic");
    
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    // We are only interested in P2C characteristic.
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:P2C_CHARACTERISTIC_UUID]]) {
        // Show the data we are notified.
        
        NSData *receivedData = characteristic.value;
        
        NSLog(@"%lu bytes received.", (unsigned long)[receivedData length]);
        
        NSString *buf;
        buf = [[NSString alloc] initWithFormat:@"%lu bytes received", (unsigned long)[receivedData length]];
        
        //_label_status.text = buf;
        
        NSString *result = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        
        //_textview_result.text = result;
        NSLog(@"received data: %@", result);
        
        if([receivedData length] > 0){
            
            BYTE queue[[receivedData length]];
            memset(queue, 0x00, [receivedData length]);
            [receivedData getBytes:queue];
            for(int i = 0 ; i < [receivedData length] ; i++){
                NSLog(@"%02x", queue[i]);
            }
            NSLog(@"before add queue len= %d", queue_len());
            queue_add_data(queue, [receivedData length]);
            NSLog(@"after add queue len= %d", queue_len());
            [self onParser];
            //NSLog(@"end of parser");
        }
    }
    
}

/** The peripheral letting us know whether our subscribe/unsubscribe happened or not
 */
- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didUpdateNotificationStateForCharacteristic");
    
    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }
    
    // Exit if it's not the transfer characteristic
    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:P2C_CHARACTERISTIC_UUID]]) {
        return;
    }
    
    // Notification has started
    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    }
    
    // Notification has stopped
    else {
        // so disconnect from the peripheral
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
    [delegate onDeviceConnected];
    
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    NSLog(@"didWriteValueForCharacteristec");
    
    if (error) {
        NSLog(@"Error didWriteValueForCharacteristic: %@", error.debugDescription);
    }
    
}

- (void) splitMSRData:(BlobData *) msrData {
    int i=0,startIndex=0,decodeSucces=0;
    BlobData *mFirstBlobData = malloc(sizeof(BlobData));
    mFirstBlobData->data = malloc(msrData->length*sizeof(BYTE));
    BlobData *mSecondBlobData = malloc(sizeof(BlobData));
    mSecondBlobData->data = malloc(msrData->length*sizeof(BYTE));
    
    if(msrData->data[i]==37){
        startIndex=i+1;
        for (i++; i<msrData->length; i++) {
            if (msrData->data[i]==63){
                mFirstBlobData->data[i]='\0';
                mFirstBlobData->length=i-startIndex;
                [delegate onReturnMSRFirstTrack:mFirstBlobData];
                decodeSucces++;
                break;
            }
            mFirstBlobData->data[i-startIndex]=msrData->data[i];
        }
    }
    i++;
    
    if(msrData->data[i]==59)
    {
        startIndex=i+1;
        for (i++; i<msrData->length; i++) {
            if (msrData->data[i]==63){
                mSecondBlobData->data[i-startIndex]='\0';
                mSecondBlobData->length=i-startIndex;
                [delegate onReturnMSRSecondTrack:mSecondBlobData];
                decodeSucces++;
                break;
            }
            mSecondBlobData->data[i-startIndex]=msrData->data[i];
        }
     }
    if(decodeSucces<2)
        [delegate onDecodeFailed];
}

-(char *) HexToByteArray:(NSString*) s{
    char * cBuffer = (char *)malloc((int)[s length]/2+1);
    for (int i = 0; i<[s length]-1; i+=2) {
        unsigned int anInt;
        NSString * hexCharStr = [s substringWithRange:NSMakeRange(i, 2)];
        NSScanner * scanner = [[NSScanner alloc] initWithString:hexCharStr];
        [scanner scanHexInt:&anInt];
        cBuffer[i/2]=(char)anInt;
    }
    return cBuffer;
}


@end
