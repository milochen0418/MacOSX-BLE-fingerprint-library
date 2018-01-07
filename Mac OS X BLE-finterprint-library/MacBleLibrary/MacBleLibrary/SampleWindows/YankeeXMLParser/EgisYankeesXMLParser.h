//
//  EgisYankeesXMLParser.h
//  XMLTest
//
//  Created by Leo Lee on 13-12-17.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EgisYankeesXMLDataStruct.h"

@interface EgisYankeesXMLParser : NSObject{
    
}


+ (EgisYankeesUserInfoSerializable *)getUserWebInfo:(NSData *)xmlData;

@end
