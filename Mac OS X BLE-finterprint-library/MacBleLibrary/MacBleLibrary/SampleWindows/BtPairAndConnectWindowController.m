//
//  BtPairAndConnectWindowController.m
//  MacBleLibrary
//
//  Created by Milo Chen on 1/2/14.
//  Copyright (c) 2014 Milo Chen. All rights reserved.
//

//import BT delegates
#import "VersionDelegate.h"
#import "ErrorDelegate.h"
#import "CaptureEnrollDelegate.h"
#import "CaptureVerifyDelegate.h"
#import "StatusDelegate.h"
#import "DeleteFeatureDelegate.h"
#import "FlashDelegate.h"




#import "YuKeyBT.h"
#import "BleBTRes.h"

#import "BtPairAndConnectWindowController.h"


//import for bookmark xml parse
#import "EgisYankeesXMLParser.h"

#import "NSObject+SharedQueue.h"
#import "NSOperationQueue+SharedQueue.h"


@interface FPBookmarkVars:NSObject {
    NSString* pStrKeyList;
    CGFloat kPublicLeftMenuWidth;
    NSString* strNormalText;
    int m_nWebSitCount;
}
+(FPBookmarkVars *) sharedInstance;


@property (nonatomic,strong) EgisYankeesUserInfoSerializable *m_pYankeesInfo;
-(void) parseXmlData ;
-(int) numberOfItems;

-(NSImage*) getImageWithIdx:(int)idx;
-(NSString*) getTitleWithIdx:(int)idx;
-(NSString*) getUrlStrWithIdx:(int)idx;

-(NSString*)getAccountName:(NSString *)strInfo;
-(NSString*)getPassword:(NSString *)strInfo;




@end

@implementation FPBookmarkVars
@synthesize m_pYankeesInfo;

+(FPBookmarkVars *) sharedInstance {
    static FPBookmarkVars * vars = nil;
    if(vars == nil) {
        vars = [[FPBookmarkVars alloc] init];
    }
    return vars;
}

-(id) init{
    self = [super init];
    if(self) {
        kPublicLeftMenuWidth = 150.0f;
        strNormalText = @"Swipe your finger repeatedly until the fingerprint fill up with orange colour.";
        m_nWebSitCount = 0;
        [self parseXmlData];
    }
    return self;
}


-(void) parseXmlData {
    NSLog(@"FPBookmarkVars start to ParseXmlData");
    NSString *pStrXMLFile = [[NSBundle mainBundle]pathForResource:@"sample" ofType:@"xml"];
    NSData *pDataXML = [[NSData alloc] initWithContentsOfFile:pStrXMLFile];
    
    m_pYankeesInfo = [EgisYankeesXMLParser getUserWebInfo:pDataXML];
    m_nWebSitCount = m_pYankeesInfo.pBookMarkInfo.count;
    NSLog(@"FPBookmarkVars end ParseXmlData");
}

-(int) numberOfItems {
    return m_nWebSitCount;
}

-(NSImage*) getImageWithIdx:(int)idx {
    EgisYankeesWebSerializable *pWebData = [m_pYankeesInfo.pBookMarkInfo objectAtIndex:idx];
    NSString *strImage = @"web_";
    strImage = [strImage stringByAppendingString:pWebData.pStrGUID];
    NSImage * img = [NSImage imageNamed:strImage];
    return img;
}

-(NSString*) getTitleWithIdx:(int)idx {
    EgisYankeesWebSerializable *pWebData = [m_pYankeesInfo.pBookMarkInfo objectAtIndex:idx];
    NSString * title =pWebData.pStrTitle;
    return title;
}

-(NSString*) getUrlStrWithIdx:(int)idx {
    EgisYankeesWebSerializable *pWebData = [m_pYankeesInfo.pBookMarkInfo objectAtIndex:idx];
    NSString * urlStr =pWebData.pStrURL;
    return urlStr;
}





-(NSString*) getWebDataStrGUIDWithIdx:(int) idx { //for mBtMgr call requestFlashData:returnStr password:@"egistec"
//    pVCEditBookmark.m_nLinkFrom = EDITE_ADDBOOKMARK;
    EgisYankeesWebSerializable *pWebData = [m_pYankeesInfo.pBookMarkInfo objectAtIndex:idx];
    if (nil != pWebData) {
        //[pVCEditBookmark setBookMarkInfo:(EgisYankeesWebSerializable*)pWebData];
        //if (_m_nLinkFrom == EDITE_MAINUILONGPRESS) {
        //if(YES) {
        //    [mBtMgr requestFlashData:pSelWebInfo.pStrGUID password:@"egistec"];
        //}
        
        return pWebData.pStrGUID;
    }
    
    return nil;
}


-(NSString*)getAccountName:(NSString *)strInfo
{
    //id:$Email:egiszwt@yahoo.com;password:$Password:Ab123456
    NSString *strTag = @";";
    NSRange range = [strInfo rangeOfString:strTag];
    int location = range.location;
    NSString *strAccountInfo = [strInfo substringToIndex:location];
    
    NSString *strTagInsert = @":";
    NSRange rangeInsert = [strAccountInfo rangeOfString:strTagInsert];
    int locationInsert = rangeInsert.location;
    locationInsert++;
    NSString *strRet = [strAccountInfo substringFromIndex:locationInsert];
    
    rangeInsert = [strRet rangeOfString:strTagInsert];
    locationInsert = rangeInsert.location;
    locationInsert++;
    strRet = [strRet substringFromIndex:locationInsert];
    
    NSLog(@"The Account is : %@", strRet);
    
    return strRet;
}

-(NSString*)getPassword:(NSString *)strInfo
{
    //id:$Email:egiszwt@yahoo.com;password:$Password:Ab123456
    NSString *strTag = @";";
    NSRange range = [strInfo rangeOfString:strTag];
    int location = range.location;
    location++;
    NSString *strAccountInfo = [strInfo substringFromIndex:location];
    
    NSString *strTagInsert = @":";
    NSRange rangeInsert = [strAccountInfo rangeOfString:strTagInsert];
    int locationInsert = rangeInsert.location;
    locationInsert++;
    NSString *strRet = [strAccountInfo substringFromIndex:locationInsert];
    
    rangeInsert = [strRet rangeOfString:strTagInsert];
    locationInsert = rangeInsert.location;
    locationInsert++;
    strRet = [strRet substringFromIndex:locationInsert];
    
    NSLog(@"The Password is : %@", strRet);
    
    return strRet;
}



@end




@interface FPVerifyVars:NSObject {
    NSString* pStrKeyList;
    CGFloat kPublicLeftMenuWidth;
    NSString* strNormalText;
}
+(FPVerifyVars *) sharedInstance;

@end

@implementation FPVerifyVars

+(FPVerifyVars *) sharedInstance {
    static FPVerifyVars * vars = nil;
    if(vars == nil) {
        vars = [[FPVerifyVars alloc] init];
    }
    return vars;
}

-(id) init{
    self = [super init];
    if(self) {
        // Start up the CBCentralManager
        //_centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        //_discoveredPeripheral = nil;
        kPublicLeftMenuWidth = 150.0f;
        strNormalText = @"Swipe your finger repeatedly until the fingerprint fill up with orange colour.";
    }
    return self;
}
@end

@interface FPEnrollVars:NSObject  {
    NSString* pStrKeyList;
    CGFloat kPublicLeftMenuWidth;
    NSString* strNormalText;
}

@end

@implementation FPEnrollVars {
}

+(FPEnrollVars *) sharedInstance {
    static FPEnrollVars * vars = nil;
    if(vars == nil) {
        vars = [[FPEnrollVars alloc] init];
    }
    return vars;
}

-(id) init {
    self = [super init];
    if(self){
        kPublicLeftMenuWidth = 150.0f;
        strNormalText = @"Swipe your finger repeatedly until the fingerprint fill up with orange colour.";
    }
    return self;
}
@end


@interface AutologinWebSiteInfo:NSObject
@property (nonatomic,strong) NSString* mPassword;
@property (nonatomic,strong) NSString* mAccount;
@property (nonatomic,strong) NSString* mKeyInFlash;
@property (nonatomic,strong) NSString* mGUID;
@end

@implementation AutologinWebSiteInfo


-(id) init {
    self = [super init];
    if(self){
    }
    return self;
}

@end


@interface AutologinWebSiteInfos:NSObject

-(void) addAutologinWebSiteInfo:(AutologinWebSiteInfo*)info ;
-(NSUInteger) count;
-(AutologinWebSiteInfo*) objectAtIndex:(NSUInteger)idx;
-(void) removeAllObjects;
-(AutologinWebSiteInfo*) getCurrentAddInfo;



@end

@interface AutologinWebSiteInfos()
@property (nonatomic,strong) NSMutableArray* mInfos;
@property (nonatomic,strong) AutologinWebSiteInfo * mCurrentAddInfo;
@end

@implementation AutologinWebSiteInfos
@synthesize mInfos;
@synthesize mCurrentAddInfo;
-(void) addAutologinWebSiteInfo:(AutologinWebSiteInfo*)info {
    if(info==nil) return;
    mCurrentAddInfo = info;
    [mInfos addObject:info];
}

-(NSUInteger) count{
    return [mInfos count];
}

-(AutologinWebSiteInfo*) objectAtIndex:(NSUInteger)idx {
    return [mInfos objectAtIndex:idx];
}

-(void) removeAllObjects{
    mCurrentAddInfo = nil;
    [mInfos removeAllObjects];
}
-(AutologinWebSiteInfo*) getCurrentAddInfo {
    return mCurrentAddInfo;
}

+(AutologinWebSiteInfos *) sharedInstance {
    static AutologinWebSiteInfos * vars = nil;
    if(vars == nil) {
        vars = [[AutologinWebSiteInfos alloc] init];
    }
    return vars;
}

-(id) init {
    self = [super init];
    if(self){
        mInfos = [NSMutableArray arrayWithCapacity:0];
    }
    return self;
}
@end




@interface BtPairAndConnectWindowController ()<VersionDelegate,ErrorDelegate,CaptureVerifyDelegate,StatusDelegate,CaptureEnrollDelegate,DeleteFeatureDelegate,FlashDelegate>
{
    YuKeyBT * mBtMgr;
}
@property (strong) IBOutlet NSTextField *mConnStatusLbl;
@property (strong) IBOutlet NSTextField *mEnrollListStrLbl;
@property (strong) IBOutlet NSTextField *mVerifyOrEnrollStrLbl;
@property (strong) IBOutlet NSTextField *mFlashDelegateInfoLbl;
@property (strong) IBOutlet NSTextField *mAccountPasswdIdxField;
@property (strong) IBOutlet NSTextField *mAccountPasswdLbl;
@property (strong) IBOutlet NSTextField *mLoadingLogLbl;

@property (nonatomic,copy) void (^mFlashReadListener)(BOOL success, NSString* accountStr, NSString* passwdStr, NSString* errorLog);


@end

@implementation BtPairAndConnectWindowController
@synthesize mConnStatusLbl;
@synthesize mEnrollListStrLbl;
@synthesize mVerifyOrEnrollStrLbl;
@synthesize mFlashDelegateInfoLbl;
@synthesize mAccountPasswdIdxField;
@synthesize mAccountPasswdLbl;
@synthesize mLoadingLogLbl;

@synthesize mFlashReadListener;


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navi_bar_nologo"] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
    
//    NSString *pStrXMLFile = [[NSBundle mainBundle]pathForResource:@"sample" ofType:@"xml"];
//    NSData *pDataXML = [[NSData alloc] initWithContentsOfFile:pStrXMLFile];
    
//    pYankeesWebsInfo = [EgisYankeesXMLParser getUserWebInfo:pDataXML];
    
    //[self.m_pCollectionView setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0f]];
    
    
    
    dispatch_async(dispatch_get_main_queue(),^{
        mBtMgr = [YuKeyBT getInstance];
        [mBtMgr setShowBleStateInfoListener:^(NSString* bleStateStr) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [mConnStatusLbl setStringValue:bleStateStr];
            });
        }];
        
        [mBtMgr setDelegate:self];
        [mBtMgr requestFlashKeyList];
    });
}

- (IBAction)clickToBtPairAndConnect:(id)sender {
    NSLog(@"clickToBtPairAndConnect");
    [mBtMgr scanAndConnect];
    
}
- (IBAction)clickToBtGetEnrollList:(id)sender {
    NSLog(@"clickToBtGetEnrollList");
    [mBtMgr getEnrollList:@"YK"];
}
- (IBAction)clickToGoVerify:(id)sender {
    NSLog(@"clickToGoVerify");
    [mBtMgr identify];
}

- (IBAction)clickToGoEnroll:(id)sender {
    NSLog(@"clicktoGoEnroll  TODO");
}

- (IBAction)clickToRequestFlashKeyList:(id)sender {
    NSLog(@"clickToRequestFlashKeyList");
    [mBtMgr requestFlashKeyList];
}

- (IBAction)clickToNsLogAllWebsiteInfos:(id)sender {
    AutologinWebSiteInfos *infos = [AutologinWebSiteInfos sharedInstance];

    int idx;
    for (idx =0; idx < [infos count];idx++) {
        AutologinWebSiteInfo * info = [infos objectAtIndex:idx];
        NSLog(@"(flash[key]=%@, GUID=%@, account=%@, password=%@", info.mKeyInFlash, info.mGUID, info.mAccount, info.mPassword);
        int scriptIdx = [info.mKeyInFlash intValue];
        FPBookmarkVars *fpbm = [FPBookmarkVars sharedInstance];
        NSLog(@"title=%@", [fpbm getTitleWithIdx:scriptIdx]);
        NSLog(@"url=%@", [fpbm getUrlStrWithIdx:scriptIdx]);
    }
}


- (IBAction)clickToGetAllAutologinWebsiteInfo:(id)sender {
    [[AutologinWebSiteInfos sharedInstance] removeAllObjects];
    [self getAllAutologinWebsiteInfo:^(NSString *loadingLog) {
        dispatch_async(dispatch_get_main_queue(),^{
            [mLoadingLogLbl setStringValue:loadingLog];
        });
    }];
    //[self getAllAutologinWebsiteInfo];
    //After call this function you can findout all infromation on [AutologinWebSiteInfos sharedInstance]
}


- (void) getAllAutologinWebsiteInfo:(void(^)(NSString *loadingLog))loadingLogListener {
    static int idxNum =0 ;
    [mBtMgr setFlashKeyListListener:^(BOOL success, NSString *keyList, NSString * errorLog) {
        if(!success) {
            NSLog(@"errorLog = %@", errorLog);
        }
        else if (keyList == nil ) {
            NSLog(@"keyList is nil");
        }
        else {
            NSLog(@"call showBookmarksInfoByKeyList:%@", keyList);
            //[self showBookmakrsInfoByKeyList:keyList];
            NSMutableArray * keyArray = [self getBookmarksIdxStrArrayByKeyList:keyList];

            static int keyArrayIdx = 0;
            
            [mBtMgr setFlashReadListener:^(BOOL success, BlobData *blobData, NSString* errorLog) {
                if(success == NO) {
                    NSLog(@"failed for flash read with errorLog = %@", errorLog);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [mAccountPasswdLbl setStringValue:errorLog];
                    });
                    return;
                }
                int nDatalength = blobData->length;
                NSData *pNSBlobData = [[NSData alloc] initWithBytes:blobData->data length:nDatalength];
                NSString *pstrBlobInfo = [[NSString alloc] initWithData:pNSBlobData encoding:NSUTF8StringEncoding];
                NSString* strWebName = [[FPBookmarkVars sharedInstance] getAccountName:pstrBlobInfo];
                NSString* strWebpswd = [[FPBookmarkVars sharedInstance] getPassword:pstrBlobInfo];
                NSString * accountStr = @"";
                NSString * passwdStr = @"";
                if (strWebName.length > 0) {
                    accountStr = strWebName;
                }
                
                if (strWebpswd.length > 0) {
                    passwdStr = strWebpswd;
                }
                loadingLogListener([NSString stringWithFormat:@"[running idx=%d] got flash data (account=%@, passwd=%@)", keyArrayIdx, accountStr, passwdStr]);
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSString * logStr = [NSString stringWithFormat:@"account = \"%@\" passwd = \"%@\"", accountStr, passwdStr];
                    NSLog(@"%@",logStr);
                 //   [mAccountPasswdLbl setStringValue:logStr];
                });
                
                [[AutologinWebSiteInfos sharedInstance] getCurrentAddInfo].mAccount = accountStr;
                [[AutologinWebSiteInfos sharedInstance] getCurrentAddInfo].mPassword = passwdStr;
                
                keyArrayIdx = keyArrayIdx + 1;
                if(keyArrayIdx < [keyArray count]) {

                    NSString * keyStr = [keyArray objectAtIndex:keyArrayIdx];
                    NSString * strGUID = [[FPBookmarkVars sharedInstance] getWebDataStrGUIDWithIdx:[keyStr intValue]];
                    
                    AutologinWebSiteInfo * info =[[AutologinWebSiteInfo alloc]init];
                    info.mKeyInFlash = keyStr;
                    info.mGUID = strGUID;
                    [[AutologinWebSiteInfos sharedInstance] addAutologinWebSiteInfo:info];
                    
                    [mBtMgr requestFlashData:strGUID password:@"egistec"];
                    NSLog(@"keyArrayIdx = %d", keyArrayIdx);
                    loadingLogListener([NSString stringWithFormat:@"[running idx=%d] request flash data (keyStr=%@, strGUID=%@)", keyArrayIdx, keyStr, strGUID]);
                }
                else {
                    loadingLogListener([NSString stringWithFormat:@"running idx = %d is end, all autologin website info loading ok", keyArrayIdx-1]);
                }
            }];
            
            keyArrayIdx = 0;
            NSString * keyStr = [keyArray objectAtIndex:keyArrayIdx];
            NSString * strGUID = [[FPBookmarkVars sharedInstance] getWebDataStrGUIDWithIdx:[keyStr intValue]];
            
            AutologinWebSiteInfo * info =[[AutologinWebSiteInfo alloc]init];
            info.mKeyInFlash = keyStr;
            info.mGUID = strGUID;
            [[AutologinWebSiteInfos sharedInstance] addAutologinWebSiteInfo:info];
            
            [mBtMgr requestFlashData:strGUID password:@"egistec"];
            loadingLogListener([NSString stringWithFormat:@"[running idx=%d] request flash data (keyStr=%@, strGUID=%@)", keyArrayIdx, keyStr, strGUID]);
            //    [opQueue addOperation:op];

            
            
        }
        //[mBtMgr setFlashKeyListListener:nil];
        
    }];
    [mBtMgr requestFlashKeyList];
    

     
}

- (BOOL)isInteger:(NSString *)toCheck {
    if([toCheck intValue] != 0) {
        return true;
    } else if([toCheck isEqualToString:@"0"]) {
        return true;
    } else {
        return false;
    }
}

-(void) showBookmakrsInfoByKeyList:(NSString*) keyList {
    NSLog(@"onFlashKeyList %@", keyList);
    NSMutableArray * bookmarksArray = [self getBookmarksIdxStrArrayByKeyList:keyList];
    int idx;
    for (idx = 0; idx < [bookmarksArray count]; idx++) {
        NSString * str = [bookmarksArray objectAtIndex:idx];
        NSLog(@"idx= %@", str );
    }
    return ;
    /*
    NSArray *pArryKey = [keyList componentsSeparatedByString:@";"];
    NSMutableArray * bookmarksArray = [NSMutableArray arrayWithCapacity:0];
    
    int idx;
    for (idx = 0; idx < [pArryKey count]; idx++) {
        NSObject * obj = [pArryKey objectAtIndex:idx];
        if(obj==nil || ![obj isKindOfClass:[NSString class]]) {
            break;
        }
        NSString * keyStr = (NSString*) obj;
        if([keyStr intValue] > 0 || ([keyStr intValue] == 0 && [keyStr isNotEqualTo:@"0"])) {
            NSUInteger nIndex = [keyStr intValue];
            NSLog(@"nIndex = %d", (int)nIndex);
            [bookmarksArray addObject:keyStr];
        }
    }
     */
}



-(NSMutableArray *) getBookmarksIdxStrArrayByKeyList :(NSString*) keyList{
//    NSLog(@"onFlashKeyList %@", keyList);
    NSArray *pArryKey = [keyList componentsSeparatedByString:@";"];
    NSMutableArray * bookmarksArray = [NSMutableArray arrayWithCapacity:0];
    
    int idx;
    for (idx = 0; idx < [pArryKey count]; idx++) {
        NSObject * obj = [pArryKey objectAtIndex:idx];
        if(obj==nil || ![obj isKindOfClass:[NSString class]]) {
            break;
        }
        NSString * keyStr = (NSString*) obj;
        if([keyStr intValue] > 0 || ([keyStr intValue] == 0 && [keyStr isEqualTo:@"0"])) {
            NSUInteger nIndex = [keyStr intValue];
            NSLog(@"nIndex = %d", (int)nIndex);
            [bookmarksArray addObject:keyStr];
        }
    }
    return bookmarksArray;
}


- (IBAction)clickToGetAccountPasswordWithIdx:(id)sender {
    
    int idx = [[mAccountPasswdIdxField stringValue ] intValue];
    NSString * strGUID = [[FPBookmarkVars sharedInstance] getWebDataStrGUIDWithIdx:idx];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * logStr = [NSString stringWithFormat:@"strGUID[idx=%d] = %@", idx, strGUID];
        NSLog(@"%@", logStr);
        [mAccountPasswdLbl setStringValue:logStr];
    });
    [mBtMgr setFlashReadListener:^(BOOL success, BlobData * blobData, NSString* errorLog) {
        if(success == NO) {
            NSLog(@"failed for flash read with errorLog = %@", errorLog);
            dispatch_async(dispatch_get_main_queue(), ^{
                [mAccountPasswdLbl setStringValue:errorLog];
            });
            return;
        }
        int nDatalength = blobData->length;
        NSData *pNSBlobData = [[NSData alloc] initWithBytes:blobData->data length:nDatalength];
        NSString *pstrBlobInfo = [[NSString alloc] initWithData:pNSBlobData encoding:NSUTF8StringEncoding];
        NSString* strWebName = [[FPBookmarkVars sharedInstance] getAccountName:pstrBlobInfo];
        NSString* strWebpswd = [[FPBookmarkVars sharedInstance] getPassword:pstrBlobInfo];
        NSString * accountStr = @"";
        NSString * passwdStr = @"";
        if (strWebName.length > 0) {
            accountStr = strWebName;
        }
        
        if (strWebpswd.length > 0) {
            passwdStr = strWebpswd;
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * logStr = [NSString stringWithFormat:@"account = \"%@\" passwd = \"%@\"", accountStr, passwdStr];
            NSLog(@"%@",logStr);
            [mAccountPasswdLbl setStringValue:logStr];
        });
    }];
    [mBtMgr requestFlashData:strGUID password:@"egistec"];
}



#pragma mark - statusDelegate

-(void) onDeviceConnected{
    NSLog(@"onDeviceConnected");
    [mConnStatusLbl setStringValue:@"onDeviceConnected"];
}

-(void) onDeviceDisConnected{
    NSLog(@"onDeviceDisConnected");
    [mConnStatusLbl setStringValue:@"onDeviceDisconnected"];
}

-(void) onBadImage:(int) status{
//    NSLog(@"onBadImage with status = %d", status);
    NSString * onBadImageLog =[NSString stringWithFormat:@"FPVerify -> onBadImage with status = %@", [BleBTRes BleToString:status]];
    NSLog(@"%@", onBadImageLog);
    [mVerifyOrEnrollStrLbl setStringValue:onBadImageLog];

    
}

-(void) onEnrollListString:(NSString*)uidList{
    NSLog(@"onEnrollListString with uidList = %@", uidList);
    [mEnrollListStrLbl setStringValue:uidList];
    
    if(uidList == nil ) {
        [mEnrollListStrLbl setStringValue:[NSString stringWithFormat:@"uidList = nil, (suggest go  enroll"]];
    }
    else {
        [mEnrollListStrLbl setStringValue:[NSString stringWithFormat:@"uidList = %@, (suggest go verify",uidList]];
    }
}


-(void) onStatus:(int) status{
    NSLog(@"onStatus with status = %@", [BleBTRes BleToString:status ]);
    if (status == BT_RES_NEED_AUTHORIZED) {
        //[mBtMgr identify];
        NSLog(@"Please use [mBtMgr identify]") ;
    }
}

-(void) onFingerFetch{
//    NSLog(@"onFingerFetch");
    
    NSString * onFingerFetchLog =[NSString stringWithFormat:@"FPVerify -> onFingerFetch"];
    NSLog(@"%@", onFingerFetchLog);
    
    [mVerifyOrEnrollStrLbl setStringValue:onFingerFetchLog];
    
    //BT_RES_GETTING_IMAGE
    [NSThread sleepForTimeInterval:2];
//    _imageVerifyResult.hidden = YES;
//    [_imageVerifySwipe setImage:[UIImage imageNamed:@"finger_no"]];
//    _m_textVerifyText.text = strNormalText;
    
}

-(void) onUserAbort:(BOOL)status{
    
    NSLog(@"onUserAbort %hhd", status);
}


#pragma mark - FlashDelegate

-(void) onFlashKeyList:(NSString *) keyList
{
    
    
    NSLog(@"onFlashKeyList with keyList = %@", keyList);
    [mFlashDelegateInfoLbl setStringValue:[NSString stringWithFormat:@"onFlashKeyList with keyList = %@", keyList ]];
    
    int idx;
    for (idx = 0; idx < [[FPBookmarkVars sharedInstance] numberOfItems]; idx++) {
        NSLog(@"title[%d] = %@", idx, [[FPBookmarkVars sharedInstance] getTitleWithIdx:idx]);
    }
    
    
    /*
    //BT_RES_KEY_LIST
    NSLog(@"onFlashKeyList %@", keyList);
    
    NSArray *pVerifyKeyList = [keyList componentsSeparatedByString:@";"];
    BOOL bBooksNull = NO;
    if (pVerifyKeyList.count > 0)
    {
        if ([pVerifyKeyList containsObject:@"FingerName"] && pVerifyKeyList.count == 1) {
            bBooksNull = YES;
        }
    }
    else
    {
        bBooksNull = YES;
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
    UINavigationController *navLeft = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"nav_left"];
    UINavigationController *navMain = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"nav_main"];
    UINavigationController *navBooks = (UINavigationController*)[storyboard instantiateViewControllerWithIdentifier:@"nav_books"];
    
    //[lefVC initNavigation];
    EgisBaseViewController * startVC = nil;
    
    if (!bBooksNull)
    {
        startVC= [[EgisBaseViewController alloc]
                  initWithCenterViewController:navMain
                  leftDrawerViewController:navLeft
                  rightDrawerViewController:nil];
    }
    else
    {
        startVC= [[EgisBaseViewController alloc]
                  initWithCenterViewController:navBooks
                  leftDrawerViewController:navLeft
                  rightDrawerViewController:nil];
    }
    if (nil != startVC) {
        [startVC setMaximumLeftDrawerWidth:kPublicLeftMenuWidth];
        //[startVC setNeedsStatusBarAppearanceUpdate];
        [startVC showsStatusBarBackgroundView];
        [startVC setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
        [startVC setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
        [startVC setDrawerVisualStateBlock:^(MMDrawerController *drawerController,
                                             MMDrawerSide drawerSide, CGFloat percentVisible) {
            MMDrawerControllerDrawerVisualStateBlock block;
            block = [MMDrawerVisualState parallaxVisualStateBlockWithParallaxFactor:2.0];
            block(drawerController, drawerSide, percentVisible);
        }];
        
        startVC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:startVC animated:YES completion:nil];
    }
     */
    
    /*
    NSLog(@"onFlashKeyList %@", keyList);
    NSArray *pArryKey = [keyList componentsSeparatedByString:@";"];
    [pArrayOwnerBookmarkList removeAllObjects];
    
    BOOL bBooksNull = NO;
    NSUInteger nIndex = NSUIntegerMax;
    if (pArryKey.count > 0)
    {
        if ([pArryKey containsObject:@"FingerName"] && pArryKey.count == 1) {
            bBooksNull = YES;
        }else{
            nIndex = [pArryKey indexOfObject:@"FingerName"];
        }
        
    }
    else
    {
        bBooksNull = YES;
    }
    
    if (!bBooksNull) {//Have BookMark
        pArrayOwnerBookmarkList = [pArryKey mutableCopy];
        if (nIndex != NSIntegerMax) {
            [pArrayOwnerBookmarkList removeObjectAtIndex:nIndex];
        }
        
    }
    [self.m_pCollectionView reloadData];
     */
}

-(void) onFlashWriteStatus:(BOOL) status
{
    NSLog(@"onFlashWriteStatus with status= %d", status );
    
}

-(void) onFlashReadStatus:(NSInteger) status
{
    NSLog(@"onFlashReadStatus with status = %@", [BleBTRes BleToString:status ]);
    //NSLog(@"onFlashReadStatus with status = %d", status );
}


-(void) onFlashData:(BlobData*)blobData
{
    NSLog(@"onFlashData with blogData");
    /*
    int nDatalength = blobData->length;
    NSLog(@"EgisBrowerViewController::onFlashData data Lenth: %d", nDatalength);
    
    NSData *pNSBlobData = [[NSData alloc] initWithBytes:blobData->data length:nDatalength];
    
    NSString *pstrBlobInfo = [[NSString alloc] initWithData:pNSBlobData encoding:NSUTF8StringEncoding];
    NSLog(@"EgisBrowerViewController::onFlashData data value: %@", pstrBlobInfo);
    
    NSString* strWebName = [[FPBookmarkVars sharedInstance] getAccountName:pstrBlobInfo];
    NSString* strWebpswd = [[FPBookmarkVars sharedInstance] getPassword:pstrBlobInfo];
    
    NSString * accountStr = @"";
    NSString * passwdStr = @"";
    if (strWebName.length > 0) {
        accountStr = strWebName;
        //_m_pTextFieldAccout.text = strWebName;
    }
    
    if (strWebpswd.length > 0) {
        passwdStr = strWebpswd;
        //_m_pTextFieldPassword.text = strWebpswd;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString * logStr = [NSString stringWithFormat:@"account = \"%@\" passwd = \"%@\"", accountStr, passwdStr];
        NSLog(@"%@",logStr);
        [mAccountPasswdLbl setStringValue:logStr];
    });
    
    */
}

-(void) onFlashDelStatus:(NSInteger) status
{
    
    //NSLog(@"onFlashDelStatus");
    NSLog(@"onFlashDelStatus with status = %@", [BleBTRes BleToString:status ]);
    //[self.m_pCollectionView reloadData];
}


#pragma mark - VersionDelegate
-(void) getVersion:(NSString*)version{
    NSLog(@"UI getVersion is %@", version);
}


#pragma mark - CaptureEnrollDelegate

-(void) onSuccess{
    NSLog(@"enroll success");
}

-(void) onFail:(int)errorCode{
    NSLog(@"enroll failed");
}

-(void) onProgress{
    
}

-(void) onGetFeature:(BYTE []) feature withSize:(int) size{
    
}

#pragma mark - ErrorDelegate

-(void) Error:(NSString *)error{
    NSLog(@"error: %@", error);
    
}


#pragma mark - CaptureVerifyDelegate

-(void) onMatchedUser:(NSString *)uid{
    
    NSLog(@"onMatched user: %@", uid);
    
    if(uid == nil ) {
        [mVerifyOrEnrollStrLbl setStringValue:@"Verify failed, please try again"];
    }
    else {
        [mVerifyOrEnrollStrLbl setStringValue:[NSString stringWithFormat:@"Verify OK for uid = %@ request", uid]];
    }
    
    [NSThread sleepForTimeInterval:1];
    
    
}


#pragma mark - DeleteFeatureDelegate

-(void) onDeleteFeatureStatus:(BOOL) status{

    NSLog(@"Delete Feature result is %d", status);
}


@end
