//
//  BeaconsTableViewController.m
//  Jaalee
//
//  Created by Per Friis on 14/06/14.
//  Copyright (c) 2014 Mobility Dream Team. All rights reserved.
//

@import CoreBluetooth;
#import "JLEBeaconConfigManager.h"
#import "JLEBeaconManager.h"

#import "BeaconsTableViewController.h"
#import "BeaconViewController.h"

@interface BeaconsTableViewController () <CBCentralManagerDelegate,JLEBeaconConfigManagerDelegate,JLEBeaconDeviceDelegate>
@property (nonatomic,strong) CBCentralManager *centralManager;
@property (nonatomic,strong) JLEBeaconConfigManager *beaconConfigManager;


@property (nonatomic,strong) NSMutableArray *beacons;




@end

@implementation BeaconsTableViewController

-(NSMutableArray *)beacons{
    if (!_beacons) {
        _beacons = [[NSMutableArray alloc] init];
    }
    return _beacons;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (self.beacons.count > 0) {
        
    
        self.title = [NSString stringWithFormat:@"%ld beacons found",self.beacons.count];
    }
    return self.beacons.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    JLEBeaconDevice *beaconDevice = [self.beacons objectAtIndex:indexPath.row];
    cell.textLabel.text = beaconDevice.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%ld", beaconDevice.rssi];
    
    if (beaconDevice.isConnected) {
        cell.backgroundColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    }
    
    // Configure the cell...
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    JLEBeaconDevice *bd = [self.beacons objectAtIndex:indexPath.row];
    [bd callJaaleeBeacon];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *index = [self.tableView indexPathForCell:sender];
    
    JLEBeaconDevice *beacon = [self.beacons objectAtIndex:index.row];
    
    
    
    if ([segue.destinationViewController respondsToSelector:@selector(setBeaconDevice:)]) {
        [segue.destinationViewController setBeaconDevice:beacon];
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}



#pragma mark - CentralManager delegate
-(void)centralManagerDidUpdateState:(CBCentralManager *)central{
    switch (central.state) {
        case CBCentralManagerStatePoweredOn:
            self.title = @"Bluetooth is ready";
            
            self.beaconConfigManager = [[JLEBeaconConfigManager alloc] init];
            self.beaconConfigManager.delegate = self;
            [self.beaconConfigManager startJaaleeBeaconsDiscovery];
            
            // TODO: start the search for devices
            
            
            break;
            
            
        case CBCentralManagerStatePoweredOff:
        case CBCentralManagerStateUnauthorized:
        case CBCentralManagerStateUnknown:
        case CBCentralManagerStateUnsupported:
        default:
        {
            UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"BlueTooth" message:@"there is a problem using Bluetooth" delegate:nil cancelButtonTitle:@"close" otherButtonTitles: nil];
            [av show];
            [av performSelector:@selector(dismissWithClickedButtonIndex:animated:) withObject:nil afterDelay:5.0];
        }
            break;
    }
}

#pragma mark - Jaalee beaconManagerDelegate
-(void)beaconConfigManager:(JLEBeaconConfigManager *)manager didDiscoverBeacon:(JLEBeaconDevice *)beacon RSSI:(NSNumber *)RSSI{
    
    if ([self.beacons indexOfObject:beacon] == NSNotFound) {
        beacon.delegate = self;
        [beacon connectToBeacon];
        NSLog(@"%s %@",__PRETTY_FUNCTION__,beacon);
        [self.beacons addObject:beacon];
        [self.tableView reloadData];
    }
}

-(void)beaconConnectionDidSucceeded:(JLEBeaconDevice *)beacon{
    [self.tableView reloadData];
    
}

@end
