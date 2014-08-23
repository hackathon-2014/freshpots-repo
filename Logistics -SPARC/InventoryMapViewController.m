//
//  InventoryMapViewController.m
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

#import "InventoryMapViewController.h"
#import "agilitechAppDelegate.h"
#define MEETERS_PER_MILE 1609.344

@interface InventoryMapViewController ()

@end

@implementation InventoryMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) placePins{
    agilitechAppDelegate *logisticsApp = (agilitechAppDelegate *) [[UIApplication sharedApplication] delegate];
    NSArray *inventoryData = [logisticsApp.sqliteController getCoordinateData];
    for (NSDictionary *arObjectData in inventoryData) {
        NSNumber *ar_id = @([arObjectData[@"id"] intValue]);
        arObject = [[ARObject alloc] initWithId:ar_id.intValue
                                          title:arObjectData[@"title"]
                                    coordinates:CLLocationCoordinate2DMake([arObjectData[@"lat"] doubleValue],
                                                                           [arObjectData[@"lon"] doubleValue])
                             andCurrentLocation:newLocation];
        
        x_pos = [self.locationMath getARObjectXPosition:arObject]-arObject.view.frame.size.width;
        
        geoobjectOverlays[ar_id] = arObject;
        geoobjectPositions[ar_id] = @(x_pos);
        geoobjectVerts[ar_id] = @1;
    }
    
}
-(void) viewWillAppear:(BOOL)animated{
    CLLocationCoordinate2D zoomLocation;
    agilitechAppDelegate *logisticsApp = (agilitechAppDelegate *) [[UIApplication sharedApplication] delegate];
    

    zoomLocation.latitude = logisticsApp.getLattitude;
    zoomLocation.longitude = logisticsApp.getLongitude;
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*MEETERS_PER_MILE,0.5*MEETERS_PER_MILE);
    [_mapView setRegion:viewRegion animated:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self placePins];
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

@end
