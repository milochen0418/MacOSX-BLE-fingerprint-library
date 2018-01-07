//
//  BleBTRes.h
//  BleDemo
//
//  Created by sheldon on 13/10/14.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sys_queue.h"

#define BT_RES_ENROLL_OK                0x01
#define BT_RES_ENROLL_FAIL              0x02
#define BT_RES_MATCHED_OK               0x03
#define BT_RES_MATCHED_FAIL             0x04
#define BT_RES_GETTING_IMAGE            0x05
#define BT_RES_GETTED_IMAGE             0x06
#define BT_RES_EXTRACTING_FEATURE       0x07
#define BT_RES_GETTED_GOOD_IMAGE        0x08
#define BT_RES_GETTED_BAD_IMAGE         0x09
#define BT_RES_ENROLL_DUPLICATED        0x0A
#define BT_RES_ENROLL_COUNT             0x0B
#define BT_RES_ABORT_OK                 0x0C
#define BT_RES_ABORT_FAIL               0x0E
#define BT_RES_GETTED_IMAGE_TOO_SHORT   0x0F
#define BT_RES_SENSOR_TIMEOUT           0x10
#define BT_RES_NOT_CONNECTED            0x11
#define BT_RES_IMAGE_INFO               0x12
#define BT_RES_BLOB                     0x13
#define BT_RES_DELETE_OK                0x14
#define BT_RES_DELETE_FAIL              0x15
#define BT_RES_GETTED_IMAGE_FAIL        0x16
#define BT_RES_IMAGE_TOO_HEAVY          0x17
#define BT_RES_IMAGE_TOO_LIGHT          0x18
#define BT_RES_FINGER_LIST              0x19
#define BT_RES_STRING                   0x1A
#define BT_RES_VERSION                  0x1B
#define BT_RES_COMMAND_ERROR            0x1C
#define BT_RES_CAPTURE_VERIFY_OK        0x1D
#define BT_RES_CHECKSUM_FAIL            0x1E
#define BT_RES_FLASH_WRITE_OK           0x1F
#define BT_RES_FLASH_WRITE_FAIL         0x20
#define BT_RES_FLASH_DELETE_OK          0x21
#define BT_RES_FLASH_DELETE_FAIL        0x22
#define BT_RES_FLASH_READ_OK            0x23
#define BT_RES_FLASH_READ_FAIL          0x24
#define BT_RES_FLASH_DATA_NOT_FOUND     0x25
#define BT_RES_INVALID_PASSWORD         0x26
#define BT_RES_KEY_LIST                 0x27
#define BT_RES_ENROLL_FEATURE_BLOB      0x28
#define BT_RES_VERIFY_FEATURE_BLOB      0x29
#define BT_RES_SYSTEM_INFO              0x2A
#define BT_RES_CMD_ACK                  0x2B
#define BT_RES_NEED_AUTHORIZED          0x2C
#define BT_RES_INVALID_PARAMETER        0x2D

#define BT_RES_SYSTEM_INFO_NOT_EXISTED  0x3B
#define BT_RES_FLASH_RESET_OK           0x3C
#define BT_RES_FLASH_RESET_FAIL         0x3D

#define BT_RES_VOLTAGE                  0x44
#define BT_RES_NO_BATTERY               0x45
#define BT_RES_POWEROFF                 0x46
#define BT_RES_OUT_OF_MEMORY            0x47

#define BT_CR_RES_SCR_OPEN_OK           0x50
#define BT_CR_RES_SCR_OPEN_FAIL         0x51
#define BT_CR_RES_SCR_CLOSE_OK          0x52
#define BT_CR_RES_SCR_APDU_OK           0x53
#define BT_CR_RES_SCR_APDU_FAIL         0x54
#define BT_CR_RES_MSR_READ_OK           0x55
#define BT_CR_RES_MSR_READ_FAIL         0x56
#define BT_CR_RES_MSR_READ_TIMEOUT      0x57

#define BLOB_TYPE                           0
#define BLOB_TYPE_IMAGE                     1
#define BLOB_TYPE_ENROLL_FEATURE            2
#define BLOB_TYPE_VERIFY_FEATURE            3
#define BLOB_TYPE_FLASH_DATA                4
#define BLOB_TYPE_AES_ENCRYPTED_DATA        5
#define BLOB_TYPE_AES_DECRYPTED_DATA        6
#define BLOB_TYPE_RSA_ENCRYPTED_DATA		7
#define BLOB_TYPE_RSA_DECRYPTED_DATA        8
#define BLOB_TYPE_SIGNATURE_DATA            9
#define BLOB_TYPE_RSA_PUBLIC_KEY            10
#define BLOB_TYPE_SYS_INFO                  11
#define BLOB_TYPE_APDU_DATA                 12
#define BLOB_TYPE_MSR_DATA                  13

#define BT_VOLTAGE_MAX                      2547
#define BT_VOLTAGE_MIN                      2209

#define BT_ENROL_UNDUPLICATE_FLAG            0x00
#define BT_ENROLL_DUPLICATE_FLAG             0x01


@interface BleBTRes : NSObject

+(NSString*) BleToString: (BYTE) res;
+(int) BleToYuKeyLibBlobType:(int)type;
@end
