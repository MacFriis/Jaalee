//
//  BeaconViewController.m
//  Jaalee
//
//  Created by Per Friis on 14/06/14.
//  Copyright (c) 2014 Mobility Dream Team. All rights reserved.
//

#import "BeaconViewController.h"

@interface BeaconViewController ()
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;

@end

@implementation BeaconViewController

-(void)setBeaconDevice:(JLEBeaconDevice *)beaconDevice{
    _beaconDevice = beaconDevice;
    
    self.title = _beaconDevice.name;
    [_beaconDevice readBeaconBatteryWithCompletion:^(unsigned short value, NSError *error) {
        NSLog(@"%s %@",__PRETTY_FUNCTION__,error.localizedDescription);
        self.label1.text = [NSString stringWithFormat:@"Battery:%d",value];
    }];
    
    [_beaconDevice readBeaconMajorWithCompletion:^(unsigned short value, NSError *error) {
        self.label2.text = [NSString stringWithFormat:@"Major:%d",value];
    }];
    
    [_beaconDevice readBeaconMeasuredPowerWithCompletion:^(unsigned short value, NSError *error) {
        self.label3.text = [NSString stringWithFormat:@"Power:%d",value];
    }];
    
    [beaconDevice readBeaconProximityUUIDWithCompletion:^(NSString *value, NSError *error) {
        self.label4.text = value;
    }];
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(writePower:)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(IBAction)writePower:(id)sender{
    [self.beaconDevice writeBeaconMesauredPower:181 withPassword:@"E00E00" Completion:^(BOOL value, NSError *error) {
        if (value) {
            NSLog(@"good -%s",__PRETTY_FUNCTION__);
        } else {
            NSLog(@"Arrraggggge %s",__PRETTY_FUNCTION__);
        }
        NSLog(@"%s %@",__PRETTY_FUNCTION__,error.localizedDescription);

    }];
}

@end
