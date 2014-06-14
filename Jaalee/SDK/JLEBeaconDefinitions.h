//
//  JLEBeaconDefinitions.h
//  JaaleeBeaconSDK
//
//  Created by jaalee on 14-4-22.
//  Copyright (c) 2014年 jaalee. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : char
{
    JLEBeaconPowerLevel1 = -23,
    JLEBeaconPowerLevel2 = -6,
    JLEBeaconPowerLevel3 = 0
} JLEBeaconPower;


typedef void(^JLECompletionBlock) (NSError* error);
typedef void(^JLEUnsignedShortCompletionBlock) (unsigned short value, NSError* error);
typedef void(^JLEPowerCompletionBlock) (JLEBeaconPower value, NSError* error);
typedef void(^JLEBoolCompletionBlock) (BOOL value, NSError* error);
typedef void(^JLEStringCompletionBlock) (NSString* value, NSError* error);




////////////////////////////////////////////////////////////////////
// Interface definition

@interface JLEBeaconDefinitions : NSObject

@end
