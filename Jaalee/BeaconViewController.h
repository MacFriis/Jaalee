//
//  BeaconViewController.h
//  Jaalee
//
//  Created by Per Friis on 14/06/14.
//  Copyright (c) 2014 Mobility Dream Team. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLEBeaconDevice.h"

@interface BeaconViewController : UIViewController
@property (strong,nonatomic) JLEBeaconDevice *beaconDevice;
@end
