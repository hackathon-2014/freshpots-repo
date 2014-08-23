//
//  SQLiteController.h
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "iPhoneDefs.h"
#import "Barcode.h"
#import <MapKit/MKAnnotation.h>

@interface SQLiteController : NSObject{
    FMDatabase *db; //our database
    NSString *databasePath;
    
}
-(int) addBarCodeToDatabase:(Barcode*) barcode;
-(int) addInventoryToDatabase:(int) barcodeID withLatitude:(NSString*) latitude andLongitude:(NSString*) longitude andName:(NSString*) name;
-(NSMutableArray*) getCoordinateData;
//-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates withName:(NSString *) name;
@end
