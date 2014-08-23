//
//  agilitechAppDelegate.h
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteController.h"

@interface agilitechAppDelegate : UIResponder <UIApplicationDelegate,CLLocationManagerDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, atomic) SQLiteController *sqliteController;
-(double) getLattitude;
-(double) getLongitude;
@end
