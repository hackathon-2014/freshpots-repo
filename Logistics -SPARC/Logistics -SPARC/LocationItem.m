//
//  LocationItem.m
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

#import "LocationItem.h"
#import <AddressBook/AddressBook.h>

@interface LocationItem()
@property (nonatomic,copy)NSString *name;
@property (nonatomic,copy)NSString *address;
@property (nonatomic,assign) CLLocationCoordinate2D coordinate;

@end

@implementation LocationItem
-(id) initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate{
    if ((self = [super init])){
        self.name = name;
        self.address = address;
        self.coordinate = coordinate;
    }
    return self;
}
- (NSString *)title {
    return _name;
}

- (NSString *)subtitle {
    return _address;
}

- (CLLocationCoordinate2D)coordinate {
    return _coordinate;
}
- (MKMapItem*)mapItem {
    NSDictionary *addressDict = @{(NSString*)kABPersonAddressStreetKey : _address};
    
    MKPlacemark *placemark = [[MKPlacemark alloc]
                              initWithCoordinate:self.coordinate
                              addressDictionary:addressDict];
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    mapItem.name = self.title;
    
    return mapItem;
}

@end
