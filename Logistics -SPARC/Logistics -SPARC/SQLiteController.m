//
//  SQLiteController.m
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

#import "SQLiteController.h"
#import "InventoryItem.h"

#define DEBUG 1
#if DEBUG 
# define Debug(x...) NSLog(x)
#else
# define Debug(x...)
#endif

@implementation SQLiteController

-(id) init {
    if (self = [super init]) {
        //I'll figure out the Documents directory.
		//we'll setup the database and folders if they aren't there already
		//find Documents Directory
		NSArray *arrayPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *docDir = [arrayPaths objectAtIndex:0];
        databasePath = [[NSString alloc] initWithString:[docDir stringByAppendingPathComponent:DATABASE]];
        databasePath = [[NSString alloc] initWithString:[docDir stringByAppendingPathComponent:DATABASE]];
		BOOL isDirectory;
        //This code checks to see if the file is there, if it isn't it creates the database and the tables necessary
        if (![[NSFileManager defaultManager] fileExistsAtPath:databasePath isDirectory:&isDirectory]) {
            Debug(@"database doesn't exist, creating the file:%@",databasePath);
			[[NSFileManager defaultManager] createFileAtPath:databasePath contents:nil attributes:nil];
            db = [FMDatabase databaseWithPath:databasePath];
            		[db setLogsErrors:YES];
            if (![db open]) {
				Debug(@"Could not open DB at path: %@",databasePath);
				//should display a message with error
			} else {
                Debug(@"creating tables for inventory");
				[db executeUpdate:CREATEINVENTORYTABLE,nil];
                [db executeUpdate:CREATEBARCODEDTABLE,nil];
                [db close];
            }
            
        }else {
            Debug(@"database exists");
        }
   
    }
    return self;
}
-(int) addInventoryToDatabase:(int) barcodeID withLatitude:(NSString*) latitude andLongitude:(NSString*) longitude andName:(NSString*) name{
    Debug(@"Got to addInventoryToDatabase with barcodeID:%d  latitude:%@  longitude:%@ andName:%@",barcodeID,latitude,longitude,name);
	sqlite_int64 lastRowID;
	Debug(@"setting up database");
	db = [FMDatabase databaseWithPath:databasePath];
	//////Debug(@"setting database to log errors");
	[db setLogsErrors:YES];
	Debug(@"trying to open database");
	if (![db open]) {
		Debug(@"Could not open DB at path: %@",databasePath);
		return -1; //don't need to close because not open
	}
	
	Debug(@"testing to see if the inventory exists exists");
	int inventoryID = -1; //initiallize to -1 if found it will be reset
	FMResultSet *rs = [db executeQuery:@"select inventoryID from inventoryTable where barcodeID = ?",[NSString stringWithFormat:@"%d",barcodeID], nil];
	while ([rs next]) {
		Debug(@"in [rs next] so there was something, setting the inventoryID");
		inventoryID = [rs intForColumn:@"inventoryID"];
		
	}
	[rs close];
	if (inventoryID != -1) { //found an inventory item with the same barcodeID
				Debug(@" the inventoryID was not -1 it was:%d",inventoryID);
        
        //need to update the inventory location and name information
        NSString* sqlUpdateStatement = @" update inventoryTable set name = ?, lat = ?, long = ? where inventoryID = ?";
        [db executeUpdate:sqlUpdateStatement,name,latitude,longitude,[NSString stringWithFormat:@"%d",inventoryID],nil];
        
        
        [db close]; //make sure we close the database first.

        
        
        
        
		return (inventoryID);
	}
    
    

	
	Debug(@"inventory item doesn't exist we need to add it.");
	//album not found so we'll add it
	
	
	
	Debug(@"setting up transaction");
	[db beginTransaction];
	Debug(@"trying to insert into database");
	//sequence is 0 so it will initially show up on top
	//-1 for firstPicID will mean there is no thumbnail..could also figure out if the count is 0
	Debug(@"trying to execute: insert into inventoryTable (name,barcodeID,lat,long) values (?,?,?,?): %@, %d,%@,%@",name,barcodeID,latitude,longitude);
	[db executeUpdate:@"insert into inventoryTable (name,barcodeID,lat,long) values (?,?,?,?)",name,[NSString stringWithFormat:@"%d",barcodeID],latitude,longitude,nil];
	lastRowID =    [db lastInsertRowId];
	Debug(@" lastRowID:%lld",lastRowID);
    
    
	Debug(@"trying to commit");
	[db commit];
	
	Debug(@"close the database");
	[db close];
	//need to close database before returning
	return lastRowID;
}
-(int) addBarCodeToDatabase:(Barcode*) barcode{
    //int ratingToAdd = (int) (rating*2);
	//TODO see if I can do this in a separate thread
	Debug(@"Got to addBarCodeToDatabase:%@",barcode.getBarcodeType);
	sqlite_int64 lastRowID;
	Debug(@"setting up database");
	db = [FMDatabase databaseWithPath:databasePath];
	//////Debug(@"setting database to log errors");
	[db setLogsErrors:YES];
	Debug(@"trying to open database");
	if (![db open]) {
		Debug(@"Could not open DB at path: %@",databasePath);
		return -1; //don't need to close because not open
	}
	
	Debug(@"testing to see if the album exists");
	int barcodeID = -1; //initiallize to -1 if found it will be reset
	FMResultSet *rs = [db executeQuery:@"select barcodeID from barcodeTable where barcodeData = ? and barcodeType = ?",barcode.getBarcodeData,barcode.getBarcodeType, nil];
	while ([rs next]) {
		Debug(@"in [rs next] so there was something, setting the barcodeID");
		barcodeID = [rs intForColumn:@"barcodeID"];
		
	}
	[rs close];
	if (barcodeID != -1) { //found another album with same title
		[db close]; //make sure we close the database first.
		Debug(@" the barcodeID was not -1 it was:%d",barcodeID);
		return (barcodeID);
	}
	
	Debug(@"album doesn't exist so we're adding it");
	//album not found so we'll add it
	
	
	
	Debug(@"setting up transaction");
	[db beginTransaction];
	Debug(@"trying to insert into database");
	//sequence is 0 so it will initially show up on top
	//-1 for firstPicID will mean there is no thumbnail..could also figure out if the count is 0
	Debug(@"trying to execute: insert into barcodeTable (barcodeType,barcodeData) values (?,?): %@,%@",barcode.getBarcodeType,barcode.getBarcodeData);
	[db executeUpdate:@"insert into barcodeTable (barcodeType,barcodeData) values (?,?)",barcode.getBarcodeType,barcode.getBarcodeData,nil];
	lastRowID =    [db lastInsertRowId];
	Debug(@" lastRowID:%lld",lastRowID);
    
    
	Debug(@"trying to commit");
	[db commit];
	
	Debug(@"close the database");
	[db close];
	//need to close database before returning
	return lastRowID;
}
-(NSDictionary*)createPointWithId:(int)the_id at:(CLLocationCoordinate2D)locCoordinates withName:(NSString *) name
{
    NSDictionary *point = @{
                            @"id" : @(the_id),
                            @"title" : name,
                            @"lon" : @(locCoordinates.longitude),
                            @"lat" : @(locCoordinates.latitude)
                            };
    return point;
}
-(NSMutableArray*) getCoordinateData{
    NSMutableArray *tmpArray = [[NSMutableArray alloc] initWithCapacity:0];
	db = [FMDatabase databaseWithPath:databasePath];
	[db setLogsErrors:YES];
	if (![db open]) {
		Debug(@"Could not open DB at path: %@",databasePath);
        //		[tmpArray release];
		return 0;
	}
	
	Debug(@"executing query:select * from InventoryTable");
	FMResultSet *rs = [db executeQuery:@"select * from InventoryTable",nil];
    int i = 0;
	while ([rs next]) {
		Debug(@"in [rs next] ");
		NSString *name = [rs stringForColumn:@"name"];
		NSString *latitude =[rs stringForColumn:@"lat"];
		NSString *longitude =[rs stringForColumn:@"long"];
		
        Debug(@"read name:%@  latitude:%@  longitude:%@",name,latitude,longitude);
		//InventoryItem *inventoryItem = [[InventoryItem alloc] init];
       // [inventoryItem setName:name];
        CLLocationCoordinate2D locCoordinates = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);
        NSDictionary *point = [self createPointWithId:i at:locCoordinates withName:name];
        //[inventoryItem setPoint:point];
        [tmpArray addObject:point];
        i++;
	}
	//close the resultset
	[rs close];
	[db close];
	
	return tmpArray;
    
}

@end
