//
//  iPhoneDefs.h
//  Logistics -SPARC
//
//  Created by LUCIUS R JUNEVICUS on 8/23/14.
//  Copyright (c) 2014 LUCIUS R JUNEVICUS. All rights reserved.
//

#ifndef Logistics__SPARC_iPhoneDefs_h
#define Logistics__SPARC_iPhoneDefs_h

#define DATABASE @"logistics.db"
#define CREATEINVENTORYTABLE @"create table inventoryTable (inventoryID INTEGER PRIMARY KEY,name text, barcodeID integer,lat text, long text)"
#define CREATEBARCODEDTABLE  @"create table barcodeTable (barcodeID INTEGER PRIMARY KEY, barcodeType text, barcodeData text)"


#endif
