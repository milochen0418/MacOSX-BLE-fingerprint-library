//
//  ParseHelper.h
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//


#import <Foundation/Foundation.h>

void *NewBase64Decode(const char *inputBuffer,size_t length,size_t *outputLength);
char *NewBase64Encode(const void *inputBuffer,size_t length,bool separateLines,size_t *outputLength);


@interface ParseHelper : NSObject {
    
}


//+ (NSData *)dataFromBase64String:(NSString *)aString;
- (NSString *)getBase64EncodedString:(NSData*)data;
- (NSString *)getBase64EncodedStringWithSeparateLines:(BOOL)separateLines withData:(NSData*)data;




- (NSString *)stringByRemovingNewLinesAndWhitespace:(NSString*)str;
- (NSString *)stringByConvertingHTMLToPlainText:(NSString*)txt ;
- (NSMutableArray*) extractStrArrayBySameTwoTag: (NSString*)tagName inXmlStr:(NSString*)xmlStr;
- (NSMutableArray*) extractStrArrayByPattern: (NSString*)patternStr inXmlStr:(NSString*)xmlStr;
- (NSMutableArray*) extractStrArrayBySameTag: (NSString*)tagName inXmlStr:(NSString*)xmlStr;
- (NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr inTxtStr:(NSString*)txtStr;
- (NSString*) extractValueByPattern:(NSString*)patternStr inTxtStr:(NSString*)txtStr;

- (NSString*) getXmlStringFromUrlStr:(NSString*)urlStr ;
- (NSString*) extractValueBetweenTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr;
- (NSData*) getSyncDataWithUrlStr:(NSString*)urlStr;
- (NSString*) getSyncXmlWithUrlStr:(NSString*)urlStr;
- (NSImage*) getSyncImageWithUrlStr:(NSString*)urlStr;
- (NSString*) getSyncBase64HtmlImgSrcWithUrl:(NSString*)urlStr andCompressionQuality:(CGFloat)quality;


- (NSURL *)urlByAddingParameters:(NSDictionary *)paramDict inURL:(NSURL*)url;
- (NSString *)URLEncodedString:(NSStringEncoding)encoding inUrlStr:(NSString*)urlStr;
- (NSString*) decodeFromPercentEscapeString:(NSString*)string;

@end
