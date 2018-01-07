//
//  EgisYankeesXMLParser.m
//  XMLTest
//
//  Created by Leo Lee on 13-12-17.
//  Copyright (c) 2013 Milo Chen. All rights reserved.
//

#import "EgisYankeesXMLParser.h"
#import "./XMLSupport/GDataXMLNode.h"


@implementation EgisYankeesXMLParser


+ (EgisYankeesUserInfoSerializable *)getUserWebInfo:(NSData *)xmlData
{
    EgisYankeesUserInfoSerializable *pUserDBData = [[EgisYankeesUserInfoSerializable alloc]init];
    
    GDataXMLDocument *pDoc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:nil];
    //
    GDataXMLElement *pRootElement = [pDoc rootElement];
    
    NSString *pStrUserInfo = [[pRootElement attributeForName:@"userinfo"] stringValue];
    pUserDBData.pUserInfo = pStrUserInfo;
        
    NSArray *pWebs = [pRootElement elementsForName:@"web"];
    for (GDataXMLElement *pWeb in pWebs) {
        //_pWebInfo = nil;
        NSString *pStrTitle =   [[pWeb attributeForName:@"title"] stringValue];
        NSString *pStrVer   =   [[pWeb attributeForName:@"ver"] stringValue];
        NSString *pStrGuid  =   [[pWeb attributeForName:@"guid"] stringValue];
        NSString *pStrUrl   =   [[pWeb attributeForName:@"url"] stringValue];
        
        EgisYankeesWebSerializable *pWebData = [[EgisYankeesWebSerializable alloc]init];
        pWebData.pStrTitle   = pStrTitle;
        pWebData.pStrVerNo   = pStrVer;
        pWebData.pStrGUID    = pStrGuid;
        pWebData.pStrURL     = pStrUrl;
        
        //Get Form Attribute
        NSArray *pForms = [pWeb elementsForName:@"form"];
        if (pForms.count > 0) {
            GDataXMLElement *pForm = (GDataXMLElement *)[pForms objectAtIndex:0];
            
            EgisYankeesFormSerializable *pFormData = [[EgisYankeesFormSerializable alloc] init];
            
            NSArray* pFormAttribute = [pForm attributes];
            for (GDataXMLElement *pFormAt in pFormAttribute) {
                NSString *pStrAtName    = pFormAt.name;
                NSString *pStrAtValue   = [[pForm attributeForName:pStrAtName] stringValue];
                
                EgisYankeesXMLDataStruct *pDataStruct   = [[EgisYankeesXMLDataStruct alloc]init];
                pDataStruct.pStrAttrName                = pStrAtName;
                pDataStruct.pStrAttrValue               = pStrAtValue;
                [pFormData.pFormAttr addObject:pDataStruct];
            }
            //Add form child node data attribue info
            if (pFormAttribute > 0) {
                //Get the Text Node
                GDataXMLElement *pText = (GDataXMLElement *)[[pForm elementsForName:@"text"] objectAtIndex:0];
                if (nil != pText) {
                    NSArray* pTextAttribute = [pText attributes];
                    for (GDataXMLElement *pTextAt in pTextAttribute) {
                        NSString *pStrAtName    = pTextAt.name;
                        NSString *pStrAtValue   = [[pText attributeForName:pStrAtName] stringValue];
                        
                        EgisYankeesXMLDataStruct *pDataStruct   = [[EgisYankeesXMLDataStruct alloc]init];
                        pDataStruct.pStrAttrName                = pStrAtName;
                        pDataStruct.pStrAttrValue               = pStrAtValue;
                        [pFormData.pTextAttr addObject:pDataStruct];
                    }
                }
                
               //Get the email node
                GDataXMLElement *pEMail = (GDataXMLElement *)[[pForm elementsForName:@"email"] objectAtIndex:0];
                if (nil != pEMail) {
                    NSArray* pEmailAttribute = [pEMail attributes];
                    for (GDataXMLElement *pEmailAt in pEmailAttribute) {
                        NSString *pStrAtName    = pEmailAt.name;
                        NSString *pStrAtValue   = [[pEMail attributeForName:pStrAtName] stringValue];
                        
                        EgisYankeesXMLDataStruct *pDataStruct   = [[EgisYankeesXMLDataStruct alloc]init];
                        pDataStruct.pStrAttrName                = pStrAtName;
                        pDataStruct.pStrAttrValue               = pStrAtValue;
                        [pFormData.pEmailAttr addObject:pDataStruct];
                    }
                }
                
                //Get the Password Node
                GDataXMLElement *pPswd = (GDataXMLElement *)[[pForm elementsForName:@"password"] objectAtIndex:0];
                if (nil != pPswd) {
                    NSArray* pPswdAttribute = [pPswd attributes];
                    for (GDataXMLElement *pPswdAt in pPswdAttribute) {
                        NSString *pStrAtName    = pPswdAt.name;
                        NSString *pStrAtValue   = [[pPswd attributeForName:pStrAtName] stringValue];
                        
                        EgisYankeesXMLDataStruct *pDataStruct   = [[EgisYankeesXMLDataStruct alloc]init];
                        pDataStruct.pStrAttrName                = pStrAtName;
                        pDataStruct.pStrAttrValue               = pStrAtValue;
                        [pFormData.pPswdAttr addObject:pDataStruct];
                    }
                }
                
                //Get the submit node
                GDataXMLElement *pSubmit = (GDataXMLElement *)[[pForm elementsForName:@"submit"] objectAtIndex:0];
                if (nil != pSubmit) {
                    NSArray* pSubmitAttribute = [pSubmit attributes];
                    for (GDataXMLElement *pSubmitAt in pSubmitAttribute) {
                        NSString *pStrAtName    = pSubmitAt.name;
                        NSString *pStrAtValue   = [[pSubmit attributeForName:pStrAtName] stringValue];
                        
                        EgisYankeesXMLDataStruct *pDataStruct   = [[EgisYankeesXMLDataStruct alloc]init];
                        pDataStruct.pStrAttrName                = pStrAtName;
                        pDataStruct.pStrAttrValue               = pStrAtValue;
                        [pFormData.pSubmitAttr addObject:pDataStruct];
                    }
                }
                
                //Get the check node
                GDataXMLElement *pCheckBox = (GDataXMLElement *)[[pForm elementsForName:@"checkbox"] objectAtIndex:0];
                if (nil != pCheckBox) {
                    NSArray* pCheckBoxAttribute = [pCheckBox attributes];
                    for (GDataXMLElement *pCheckBoxAt in pCheckBoxAttribute) {
                        NSString *pStrAtName    = pCheckBoxAt.name;
                        NSString *pStrAtValue   = [[pCheckBox attributeForName:pStrAtName] stringValue];
                        
                        EgisYankeesXMLDataStruct *pDataStruct   = [[EgisYankeesXMLDataStruct alloc]init];
                        pDataStruct.pStrAttrName                = pStrAtName;
                        pDataStruct.pStrAttrValue               = pStrAtValue;
                        [pFormData.pCheckAttr addObject:pDataStruct];
                    }
                }
            }//if (pFormAttribute > 0)
            [pWebData.pWebInfo addObject:pFormData];
        }//if (pForms.count > 0)
        [pUserDBData.pBookMarkInfo addObject:pWebData];
    }//for (GDataXMLElement *pWeb in pWebs)
    //NSLog(@"The Web count is %lu", pUserDBData.pBookMarkInfo.count);
    return pUserDBData;
}

@end
