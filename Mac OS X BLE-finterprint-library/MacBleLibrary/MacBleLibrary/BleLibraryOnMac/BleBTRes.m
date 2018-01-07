//
//  BleBTRes.m
//  BleDemo
//
//  Created by sheldon on 13/10/14.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import "BleBTRes.h"

@implementation BleBTRes

+(NSString*) BleToString:(BYTE)res{
    
    switch (res) {
        case BT_RES_ENROLL_OK: return @"BT_RES_ENROLL_OK";
        case BT_RES_ENROLL_FAIL: return @"BT_RES_ENROLL_FAIL";
        case BT_RES_MATCHED_OK: return @"BT_RES_MATCHED_OK";
        case BT_RES_MATCHED_FAIL: return @"BT_RES_MATCHED_FAIL";
        case BT_RES_GETTING_IMAGE: return @"BT_RES_GETTING_IMAGE";
        case BT_RES_GETTED_IMAGE: return @"BT_RES_GETTED_IMAGE";
        case BT_RES_EXTRACTING_FEATURE:	return @"BT_RES_EXTRACTING_FEATURE";
        case BT_RES_GETTED_GOOD_IMAGE: return @"BT_RES_GETTED_GOOD_IMAGE";
        case BT_RES_GETTED_BAD_IMAGE: return @"BT_RES_GETTED_BAD_IMAGE";
        case BT_RES_ENROLL_DUPLICATED: return @"BT_RES_ENROLL_DUPLICATED";
        case BT_RES_ENROLL_COUNT: return @"BT_RES_ENROLL_COUNT";
        case BT_RES_ABORT_OK: return @"BT_RES_ABORT_OK";
        case BT_RES_ABORT_FAIL: return @"BT_RES_ABORT_FAIL";
        case BT_RES_GETTED_IMAGE_TOO_SHORT: return @"BT_RES_GETTED_IMAGE_TOO_SHORT";
        case BT_RES_SENSOR_TIMEOUT: return @"BT_RES_SENSOR_TIMEOUT";
        case BT_RES_NOT_CONNECTED: return @"BT_RES_NOT_CONNECTED";
        case BT_RES_IMAGE_INFO: return @"BT_RES_IMAGE_INFO";
        case BT_RES_BLOB: return @"BT_RES_BLOB";
        case BT_RES_DELETE_OK: return @"BT_RES_DELETE_OK";
        case BT_RES_DELETE_FAIL: return @"BT_RES_DELETE_FAIL";
        case BT_RES_GETTED_IMAGE_FAIL: return @"BT_RES_GETTED_IMAGE_FAIL";
        case BT_RES_IMAGE_TOO_HEAVY: return @"BT_RES_IMAGE_TOO_HEAVY";
        case BT_RES_IMAGE_TOO_LIGHT: return @"BT_RES_IMAGE_TOO_LIGHT";
        case BT_RES_FINGER_LIST: return @"BT_RES_FINGER_LIST";
        case BT_RES_STRING: return @"BT_RES_STRING";
        case BT_RES_VERSION: return @"BT_RES_VERSION";
        case BT_RES_COMMAND_ERROR: return @"BT_RES_COMMAND_ERROR";
        case BT_RES_CAPTURE_VERIFY_OK: return @"BT_RES_CAPTURE_VERIFY_OK";
        case BT_RES_CHECKSUM_FAIL: return @"BT_RES_CHECKSUM_FAIL";
        case BT_RES_FLASH_WRITE_OK: return @"BT_RES_FLASH_WRITE_OK";
        case BT_RES_FLASH_WRITE_FAIL: return @"BT_RES_FLASH_WRITE_FAIL";
        case BT_RES_FLASH_DELETE_OK: return @"BT_RES_FLASH_DEL_OK";
        case BT_RES_FLASH_DELETE_FAIL: return @"BT_RES_FLASH_DEL_FAIL";
        case BT_RES_FLASH_READ_OK: return @"BT_RES_FLASH_READ_OK";
        case BT_RES_FLASH_READ_FAIL: return @"BT_RES_FLASH_READ_FAIL";
        case BT_RES_FLASH_DATA_NOT_FOUND: return @"BT_RES_FLASH_DATA_NOT_FOUND";
        case BT_RES_INVALID_PASSWORD: return @"BT_RES_INVALID_PASSWORD";
        case BT_RES_KEY_LIST: return @"BT_RES_KEY_LIST";
        case BT_RES_ENROLL_FEATURE_BLOB: return @"BT_RES_ENROLL_FEATURE_BLOB";
        case BT_RES_VERIFY_FEATURE_BLOB: return @"BT_RES_VERIFY_FEATURE_BLOB";
        case BT_RES_SYSTEM_INFO: return @"BT_RES_SYSTEM_INFO";
        case BT_RES_CMD_ACK: return @"BT_RES_CMD_ACK";
        case BT_RES_NEED_AUTHORIZED: return @"BT_RES_NEED_AUTHORIZED";
        case BT_RES_INVALID_PARAMETER: return @"BT_RES_INVALID_PARAMETER";
        case BT_RES_SYSTEM_INFO_NOT_EXISTED: return @"BT_RES_SYSTEM_INFO_NOT_EXISTED";
        case BT_RES_FLASH_RESET_OK: return @"BT_RES_FLASH_RESET_OK";
        case BT_RES_FLASH_RESET_FAIL: return @"BT_RES_FLASH_RESET_FAIL";
        case BT_RES_VOLTAGE: return @"BT_RES_VOLTAGE";
        case BT_RES_NO_BATTERY: return @"BT_RES_NO_BATTERY";
        case BT_RES_POWEROFF: return @"BT_RES_POWEROFF";
        case BT_RES_OUT_OF_MEMORY: return @"BT_RES_OUT_OF_MEMORY";
        case BT_CR_RES_SCR_OPEN_OK: return @"BT_CR_RES_SCR_OPEN_OK";
        case BT_CR_RES_SCR_OPEN_FAIL: return @"BT_CR_RES_SCR_OPEN_FAIL";
        case BT_CR_RES_SCR_CLOSE_OK: return @"BT_CR_RES_SCR_CLOSE_OK";
        case BT_CR_RES_SCR_APDU_OK: return @"BT_CR_RES_SCR_APDU_OK";
        case BT_CR_RES_SCR_APDU_FAIL: return @"BT_CR_RES_SCR_APDU_FAIL";
        case BT_CR_RES_MSR_READ_OK: return @"BT_CR_RES_MSR_READ_OK";
        case BT_CR_RES_MSR_READ_FAIL: return @"BT_CR_RES_MSR_READ_FAIL";
        case BT_CR_RES_MSR_READ_TIMEOUT: return @"BT_CR_RES_MSR_READ_TIMEOUT";
    }
    return @"Unknown result message!";
}

+(int) BleToYuKeyLibBlobType:(int)type{
    
    int shift = 1000;
    switch(type) {
        case BLOB_TYPE_IMAGE: return BLOB_TYPE_IMAGE+shift;
        case BLOB_TYPE_ENROLL_FEATURE: return BLOB_TYPE_ENROLL_FEATURE+shift;
        case BLOB_TYPE_VERIFY_FEATURE: return BLOB_TYPE_VERIFY_FEATURE+shift;
        case BLOB_TYPE_FLASH_DATA: return BLOB_TYPE_FLASH_DATA;
        case BLOB_TYPE_AES_ENCRYPTED_DATA: return BLOB_TYPE_AES_ENCRYPTED_DATA+shift;
        case BLOB_TYPE_AES_DECRYPTED_DATA: return BLOB_TYPE_AES_DECRYPTED_DATA+shift;
        case BLOB_TYPE_RSA_ENCRYPTED_DATA: return BLOB_TYPE_RSA_ENCRYPTED_DATA+shift;
        case BLOB_TYPE_RSA_DECRYPTED_DATA: return BLOB_TYPE_RSA_DECRYPTED_DATA+shift;
        case BLOB_TYPE_SIGNATURE_DATA: return BLOB_TYPE_SIGNATURE_DATA+shift;
        case BLOB_TYPE_RSA_PUBLIC_KEY: return BLOB_TYPE_RSA_PUBLIC_KEY+shift;
        case BLOB_TYPE_SYS_INFO: return BLOB_TYPE_SYS_INFO+shift;
        default: return BLOB_TYPE+type+shift;
    }

}

@end
