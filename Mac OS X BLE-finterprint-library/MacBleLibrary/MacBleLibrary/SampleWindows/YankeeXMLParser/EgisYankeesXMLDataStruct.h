//
//  EgisYankeesXMLDataStruct.h
//  XMLTest
//
//  Created by Leo Lee on 13-12-14.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

//Attribute
@interface EgisYankeesXMLDataStruct : NSObject{
    
}

@property (nonatomic, copy) NSString *pStrAttrName;
@property (nonatomic, copy) NSString *pStrAttrValue;

@end

//Form
@interface EgisYankeesFormSerializable : NSObject{
    
}
@property (nonatomic, retain) NSMutableArray *pFormAttr;
@property (nonatomic, retain) NSMutableArray *pTextAttr;
@property (nonatomic, retain) NSMutableArray *pEmailAttr;
@property (nonatomic, retain) NSMutableArray *pPswdAttr;
@property (nonatomic, retain) NSMutableArray *pSubmitAttr;
@property (nonatomic, retain) NSMutableArray *pCheckAttr;

@end


//Web
@interface EgisYankeesWebSerializable : NSObject{
    
}

@property (nonatomic, copy) NSString *pStrTitle;
@property (nonatomic, copy) NSString *pStrVerNo;
@property (nonatomic, copy) NSString *pStrGUID;
@property (nonatomic, copy) NSString *pStrURL;
@property (nonatomic, retain) NSMutableArray *pWebInfo;

@end

// db-userinfo
@interface EgisYankeesUserInfoSerializable : NSObject{
    
}

@property (nonatomic, copy) NSString *pUserInfo; //userinfo
@property (nonatomic, retain) NSMutableArray *pBookMarkInfo;

@end
