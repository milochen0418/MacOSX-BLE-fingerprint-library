//
//  EgisYankeesXMLDataStruct.m
//  XMLTest
//
//  Created by Leo Lee on 13-12-14.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import "EgisYankeesXMLDataStruct.h"

@implementation EgisYankeesXMLDataStruct

-(void)dealloc{
    _pStrAttrName = nil;
    _pStrAttrValue = nil;
}
@end

//Form
@implementation EgisYankeesFormSerializable

- (id)init {
    
    if ((self = [super init])) {
        self.pFormAttr = [[NSMutableArray alloc] init];
        self.pTextAttr = [[NSMutableArray alloc] init];
        self.pEmailAttr = [[NSMutableArray alloc] init];
        self.pPswdAttr = [[NSMutableArray alloc] init];
        self.pSubmitAttr = [[NSMutableArray alloc] init];
        self.pCheckAttr = [[NSMutableArray alloc] init];
        
    }
    return self;
}

-(void)dealloc{
    _pFormAttr = nil;
    _pTextAttr = nil;
    _pEmailAttr = nil;
    _pPswdAttr = nil;
    _pSubmitAttr = nil;
    _pCheckAttr = nil;
}

@end


@implementation EgisYankeesWebSerializable

- (id)init {
    
    if ((self = [super init])) {
        self.pWebInfo = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)dealloc{
    _pStrTitle = nil;
    _pStrVerNo = nil;
    _pStrGUID = nil;
    _pStrURL = nil;
    _pWebInfo = nil;
}
@end

@implementation EgisYankeesUserInfoSerializable

- (id)init {
    
    if ((self = [super init])) {
        self.pBookMarkInfo = [[NSMutableArray alloc] init];
    }
    return self;
    
}

-(void)dealloc{
    _pUserInfo = nil;
    _pBookMarkInfo = nil;
}


@end
