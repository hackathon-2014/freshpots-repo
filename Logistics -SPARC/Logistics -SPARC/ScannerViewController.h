//
//  ViewController.h
//  iOS7_BarcodeScanner
//
//  Created by Jake Widmer on 11/16/13.
//  Copyright (c) 2013 Jake Widmer. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SettingsViewController.h"
#import <CoreLocation/CoreLocation.h>
@interface ScannerViewController : UIViewController<UIAlertViewDelegate, SettingsDelegate,CLLocationManagerDelegate>
@property (strong, nonatomic) NSMutableArray * allowedBarcodeTypes;

@end
