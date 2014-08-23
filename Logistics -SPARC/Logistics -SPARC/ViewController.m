//
//  ViewController.m
//  PRAR-Simple
//
//  Created by Geoffroy Lesage on 3/27/14.
//  Copyright (c) 2014 Promet Solutions Inc,. All rights reserved.
//

#import "ViewController.h"

#include <stdlib.h>
#import "agilitechAppDelegate.h"


#define NUMBER_OF_POINTS    20
#define DEBUG 1
#if DEBUG
# define Debug(x...) NSLog(x)
#else
# define Debug(x...)
#endif


@interface ViewController ()

@property (nonatomic, strong) PRARManager *prARManager;

@end


@implementation ViewController{
    
}


- (void)alert:(NSString*)title withDetails:(NSString*)details {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:details
                                                   delegate:nil
                                          cancelButtonTitle:@"Ok"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Debug(@"viewDidLoad");
    // Initialize the manager so it wakes up (can do this anywhere you want
    self.prARManager = [[PRARManager alloc] initWithSize:self.view.frame.size delegate:self showRadar:YES];
    
}





-(void)viewDidAppear:(BOOL)animated
{
    Debug(@"viewDidAppear");
    // Initialize your current location as 0,0 (since it works with our randomly generated locations)
    agilitechAppDelegate *logisticsApp = (agilitechAppDelegate *) [[UIApplication sharedApplication] delegate];
    double lattitude = logisticsApp.getLattitude;
    double longitude = logisticsApp.getLongitude;
    NSNumber *doubleLongitude = [NSNumber numberWithDouble:longitude];
    NSNumber *doubleLattitude = [NSNumber numberWithDouble:lattitude];
    NSString *longitudeString = [doubleLongitude stringValue];
    NSString *lattitudeString = [doubleLattitude stringValue];
    Debug(@"!!!!!!!!!!!!thinks current lattitude:%@  longitude:%@",lattitudeString,longitudeString);
    CLLocationCoordinate2D locationCoordinates = CLLocationCoordinate2DMake(lattitude, longitude);

    
    [self.prARManager startARWithData:[self getLocationsFromInventory] forLocation:locationCoordinates];
}
#pragma mark - Get data from database LRJ

-(NSArray *) getLocationsFromInventory
{
    agilitechAppDelegate *logisticsApp = (agilitechAppDelegate *) [[UIApplication sharedApplication] delegate];
    return [logisticsApp.sqliteController getCoordinateData];
}

#pragma mark - Dummy AR Data

// Creates data for `NUMBER_OF_POINTS` AR Objects
/*
-(NSArray*)getDummyData
{
    NSMutableArray *points = [NSMutableArray arrayWithCapacity:NUMBER_OF_POINTS];
    
    srand48(time(0));
    for (int i=0; i<NUMBER_OF_POINTS; i++)
    {
        CLLocationCoordinate2D pointCoordinates = [self getRandomLocation];
        NSDictionary *point = [self createPointWithId:i at:pointCoordinates];
        [points addObject:point];
    }
    
    return [NSArray arrayWithArray:points];
}

// Returns a random location
-(CLLocationCoordinate2D)getRandomLocation
{
    double latRand = drand48() * 90.0;
    double lonRand = drand48() * 180.0;
    double latSign = drand48();
    double lonSign = drand48();
    
    CLLocationCoordinate2D locCoordinates = CLLocationCoordinate2DMake(latSign > 0.5 ? latRand : -latRand,
                                                                       lonSign > 0.5 ? lonRand*2 : -lonRand*2);
    return locCoordinates;
}
 */

// Creates the Data for an AR Object at a given location
/*
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates
{
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" : [NSString stringWithFormat:@"Place Num %d", the_id],
                            @"lon" : @(locCoordinates.longitude),
                            @"lat" : @(locCoordinates.latitude)
                           };
    return point;
}*/


#pragma mark - PRARManager Delegate

-(void)prarDidSetupAR:(UIView *)arView withCameraLayer:(AVCaptureVideoPreviewLayer *)cameraLayer andRadarView:(UIView *)radar
{
    NSLog(@"Finished displaying ARObjects");
    
    [self.view.layer addSublayer:cameraLayer];
    [self.view addSubview:arView];
    
    [self.view bringSubviewToFront:[self.view viewWithTag:AR_VIEW_TAG]];
    
    [self.view addSubview:radar];
    
    [loadingV setHidden:YES];
}

-(void)prarUpdateFrame:(CGRect)arViewFrame
{
    [[self.view viewWithTag:AR_VIEW_TAG] setFrame:arViewFrame];
}

-(void)prarGotProblem:(NSString *)problemTitle withDetails:(NSString *)problemDetails
{
    [loadingV setHidden:YES];
    [self alert:problemTitle withDetails:problemDetails];
}

@end
