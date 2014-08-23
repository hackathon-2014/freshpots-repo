//
//  InventoryItem.h
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <MapKit/MKAnnotation.h>

@interface InventoryItem : NSObject{
   // NSString *name;
   // CLLocationCoordinate2D coordinate;
}
@property (nonatomic,retain) NSString *name;
//@property CLLocationCoordinate2D coordinate;
@property (nonatomic,retain) NSDictionary *point;

@end
