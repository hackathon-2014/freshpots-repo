//
//  agilitechAppDelegate.m
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

#import "agilitechAppDelegate.h"
#define DEBUG 1
#if DEBUG
# define Debug(x...) NSLog(x)
#else
# define Debug(x...)
#endif
@implementation agilitechAppDelegate{
    CLLocationManager *locationManager;
    double lattitude;
    double longitude;
}
@synthesize sqliteController = _sqliteController;

- (IBAction)getCurrentLocation:(id)sender {
    Debug(@"got to getCurrentLocation");
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager setDistanceFilter:kCLDistanceFilterNone];
    
    [locationManager startUpdatingLocation];
}
#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    longitude =currentLocation.coordinate.longitude;
    lattitude = currentLocation.coordinate.latitude;
    [locationManager stopUpdatingLocation];
    
}
-(double) getLattitude{
    return lattitude;
}
-(double) getLongitude{
    return longitude;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //Setup sqliteController
    Debug(@"got to applicationDidFinishLaunching");
    locationManager = [[CLLocationManager alloc] init];
    [self getCurrentLocation: nil];
    self.sqliteController = [[SQLiteController alloc] init];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     [self getCurrentLocation: nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
