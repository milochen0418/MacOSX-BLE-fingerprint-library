
//
//  ParseHelper.m
//  cambridge
//
//  Created by milochen on 13/7/19.
//  Copyright (c) 2013 milochen. All rights reserved.
//


#import "ParseHelper.h"

@implementation ParseHelper



-(NSString *)stringByRemovingNewLinesAndWhitespace:(NSString*)str {
	NSScanner *scanner = [[NSScanner alloc] initWithString:str];
	[scanner setCharactersToBeSkipped:nil];
	NSMutableString *result = [[NSMutableString alloc] init];
	NSString *temp;
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:
                                                      [NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	// Scan
	while (![scanner isAtEnd]) {
        
		// Get non new line or whitespace characters
		temp = nil;
		[scanner scanUpToCharactersFromSet:newLineAndWhitespaceCharacters intoString:&temp];
		if (temp) [result appendString:temp];
        
		// Replace with a space
		if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
			if (result.length > 0 && ![scanner isAtEnd]) // Dont append space to beginning or end of result
				[result appendString:@" "];
		}
        
	}
    
	// Cleanup
    scanner = nil;
    
	// Return
	NSString *retString = [NSString stringWithString:result];
    result = nil;
	//[result release];
    
    return retString;
}






-(NSString *)stringByConvertingHTMLToPlainText:(NSString*)txt {
    
	// Pool
    //	NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
	// Character sets
	NSCharacterSet *stopCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@"< \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *newLineAndWhitespaceCharacters = [NSCharacterSet characterSetWithCharactersInString:[NSString stringWithFormat:@" \t\n\r%C%C%C%C", 0x0085, 0x000C, 0x2028, 0x2029]];
	NSCharacterSet *tagNameCharacters = [NSCharacterSet characterSetWithCharactersInString:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"];
    
	// Scan and find all tags
    //	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:self.length];
	NSMutableString *result = [[NSMutableString alloc] initWithCapacity:txt.length];
    //	NSScanner *scanner = [[NSScanner alloc] initWithString:self];
	NSScanner *scanner = [[NSScanner alloc] initWithString:txt];    
	[scanner setCharactersToBeSkipped:nil];
	[scanner setCaseSensitive:YES];
	NSString *str = nil, *tagName = nil;
	BOOL dontReplaceTagWithSpace = NO;
	do {
        
		// Scan up to the start of a tag or whitespace
		if ([scanner scanUpToCharactersFromSet:stopCharacters intoString:&str]) {
			[result appendString:str];
			str = nil; // reset
		}
        
		// Check if we've stopped at a tag/comment or whitespace
		if ([scanner scanString:@"<" intoString:NULL]) {
            
			// Stopped at a comment or tag
			if ([scanner scanString:@"!--" intoString:NULL]) {
                
				// Comment
				[scanner scanUpToString:@"-->" intoString:NULL]; 
				[scanner scanString:@"-->" intoString:NULL];
                
			} else {
                
				// Tag - remove and replace with space unless it's
				// a closing inline tag then dont replace with a space
				if ([scanner scanString:@"/" intoString:NULL]) {
                    
					// Closing tag - replace with space unless it's inline
					tagName = nil; dontReplaceTagWithSpace = NO;
					if ([scanner scanCharactersFromSet:tagNameCharacters intoString:&tagName]) {
						tagName = [tagName lowercaseString];
						dontReplaceTagWithSpace = ([tagName isEqualToString:@"a"] ||
												   [tagName isEqualToString:@"b"] ||
												   [tagName isEqualToString:@"i"] ||
												   [tagName isEqualToString:@"q"] ||
												   [tagName isEqualToString:@"span"] ||
												   [tagName isEqualToString:@"em"] ||
												   [tagName isEqualToString:@"strong"] ||
												   [tagName isEqualToString:@"cite"] ||
												   [tagName isEqualToString:@"abbr"] ||
												   [tagName isEqualToString:@"acronym"] ||
												   [tagName isEqualToString:@"label"]);
					}
                    
					// Replace tag with string unless it was an inline
					if (!dontReplaceTagWithSpace && result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "];
                    
				}
                
				// Scan past tag
				[scanner scanUpToString:@">" intoString:NULL];
				[scanner scanString:@">" intoString:NULL];
                
			}
            
		} else {
            
			// Stopped at whitespace - replace all whitespace and newlines with a space
			if ([scanner scanCharactersFromSet:newLineAndWhitespaceCharacters intoString:NULL]) {
				if (result.length > 0 && ![scanner isAtEnd]) [result appendString:@" "]; // Dont append space to beginning or end of result
			}
            
		}
        
	} while (![scanner isAtEnd]);
    
	// Cleanup
    //	[scanner release];
    scanner = nil;
    
	// Decode HTML entities and return
    //	NSString *retString = [[result stringByDecodingHTMLEntities] retain];
    

 	//NSString *retString = [result stringByDecodingHTMLEntities];
    NSString *retString = result;
    
    //	[result release];
    result = nil;
    
	// Drain
    //	[pool drain];
    
	// Return
    //	return [retString autorelease];
    return retString;
    
}



-(NSMutableArray*) extractStrArrayBySameTwoTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    NSString *loadData = xmlStr;
    NSString *pattern = [NSString stringWithFormat:@"<%@>(.+?)</%@>", tagName,tagName];      
    NSError * err;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionSearch
                                  error:&err];
    
    if(err!=nil) 
    {
        //        NSLog(@"err:%@",[err localizedDescription]);
        return nil;
    }
    
    
    NSArray * matches = [regex matchesInString:loadData options:0 range:NSMakeRange(0, loadData.length)];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
    
    
    for( NSTextCheckingResult * ntcr in matches) 
    {
        int captureIndex;
        for(captureIndex = 1; captureIndex < ntcr.numberOfRanges; captureIndex++) 
        {
            NSRange matchRange = [ntcr rangeAtIndex:captureIndex];
            NSString *match = [loadData substringWithRange:matchRange];
            [arr addObject:match];
        }
    }
    return arr;
}




-(NSMutableArray*) extractStrArrayByPattern : (NSString*)patternStr inXmlStr:(NSString*)xmlStr {
    //
    NSString *loadData = xmlStr;
    //NSString *pattern = [NSString stringWithFormat:@"<%@ (.+?)</%@>", tagName,tagName];
    NSString *pattern = patternStr;
    NSError * err;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionSearch
                                  error:&err];
    
    if(err!=nil) 
    {
        //        NSLog(@"err:%@",[err localizedDescription]);
        return nil;
    }
    
    
    NSArray * matches = [regex matchesInString:loadData options:0 range:NSMakeRange(0, loadData.length)];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
    
    
    for( NSTextCheckingResult * ntcr in matches) 
    {
        int captureIndex;
        for(captureIndex = 1; captureIndex < ntcr.numberOfRanges; captureIndex++) 
        {
            NSRange matchRange = [ntcr rangeAtIndex:captureIndex];
            NSString *match = [loadData substringWithRange:matchRange];
            [arr addObject:match];
        }
    }
    return arr;
}



-(NSMutableArray*) extractStrArrayBySameTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    NSString *loadData = xmlStr;
    NSString *pattern = [NSString stringWithFormat:@"<%@ (.+?)/>", tagName];      
    NSError * err;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:NSRegularExpressionCaseInsensitive | NSRegularExpressionSearch
                                  error:&err];
    
    if(err!=nil) 
    {
        //        NSLog(@"err:%@",[err localizedDescription]);
        return nil;
    }
    
    
    NSArray * matches = [regex matchesInString:loadData options:0 range:NSMakeRange(0, loadData.length)];
    NSMutableArray * arr = [NSMutableArray arrayWithCapacity:1];
    
    
    for( NSTextCheckingResult * ntcr in matches) 
    {
        int captureIndex;
        for(captureIndex = 1; captureIndex < ntcr.numberOfRanges; captureIndex++) 
        {
            NSRange matchRange = [ntcr rangeAtIndex:captureIndex];
            NSString *match = [loadData substringWithRange:matchRange];
            [arr addObject:match];
        }
    }
    return arr;
}




-(NSString*) extractValueBetweenBeginStr:(NSString*)beginStr andEndStr:(NSString*)endStr inTxtStr:(NSString*)txtStr;
{
    if(beginStr==nil || endStr ==nil || txtStr ==nil) return nil;
    
    NSString *pattern = [NSString stringWithFormat:@"%@(.*?)%@", beginStr, endStr];    
    NSError * err = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:
                                  NSRegularExpressionCaseInsensitive
                                  error:&err];
    if(err!=nil) {
        NSLog(@"extractValueBetweenBeginStr get err = %@", [err localizedDescription]);
        return nil;
    }
    
    //    return [[regex matchesInString:loadData options:NSCaseInsensitiveSearch range:NSMakeRange(0,[loadData length])] objectAtIndex:0];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:txtStr options:0 range:NSMakeRange(0, txtStr.length)];
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [txtStr substringWithRange:matchRange];
    if([match isEqualToString:@""]) 
    {
        return nil;
    }
    return match;
}



-(NSString*) getXmlStringFromUrlStr:(NSString*)urlStr {
    return [self getSyncXmlWithUrlStr:urlStr];
}


-(NSString*) extractValueBetweenTag : (NSString*)tagName inXmlStr:(NSString*)xmlStr {
    return [self 
            extractValueBetweenBeginStr:[NSString stringWithFormat:@"<%@>",tagName] 
            andEndStr:[NSString stringWithFormat:@"</%@>",tagName] 
            inTxtStr:xmlStr
            ];    
}


-(NSData*) getSyncDataWithUrlStr:(NSString*)urlStr {
    if(urlStr == nil) return nil;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
    [request setURL:[NSURL URLWithString:urlStr]];
    [request setHTTPMethod:@"GET"];
//    [request setTimeoutInterval:5];
    NSData *returnData  = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    request = nil;
    return returnData;
}

-(NSString*) getSyncXmlWithUrlStr:(NSString*)urlStr 
{
    NSData * data = [self getSyncDataWithUrlStr:urlStr];
    NSString * readXmlStr = [[NSMutableString alloc] initWithData:data encoding:NSISOLatin1StringEncoding];
    
//    NSLog(@"getSyncXmlWithUrlStr = %@",readXmlStr);
    return readXmlStr;
}


-(NSImage*) getSyncImageWithUrlStr:(NSString*)urlStr
{
    NSData * data = [self getSyncDataWithUrlStr:urlStr];
//    NSImage * img = [UIImage imageWithData:data];
    NSImage * img = [[NSImage alloc] initWithData:data];
    return img;
}

- (NSURL*)urlByAddingParameters:(NSDictionary*)paramDict inURL:(NSURL*)url
{
    NSLog(@"urlByAddingParameters [enter]");
	if (!paramDict || [paramDict count] == 0) 
    {
		return url;
        NSLog(@"urlByAddingParameters -> !paramDict || [paramDict count] == 0");
	}
    
  	NSString *absoluteString = [url absoluteString];  
	NSMutableArray *paramPairs = [NSMutableArray array];    
	for (NSString *key in [paramDict allKeys]) 
    {
        NSString * str = [paramDict objectForKey:key];
//        NSLog(@"urlByAddingParameters -> key = %@",str);
        NSString * encodedStr = [self URLEncodedString:NSUTF8StringEncoding inUrlStr:str];
//        NSLog(@"urlByAddingParameters -> encodedStr = %@",encodedStr);
  		NSString *pair = [NSString stringWithFormat:@"%@=%@", key,  encodedStr ];      
   		[paramPairs addObject:pair];
	}
    
	NSString *queryString = [paramPairs componentsJoinedByString:@"&"];
	NSRange parameterRange = [absoluteString rangeOfString:@"?"];
	if (parameterRange.location == NSNotFound) {
		absoluteString = [NSString stringWithFormat:@"%@?%@", absoluteString, queryString];
	} 
    else 
    {
		absoluteString = [NSString stringWithFormat:@"%@&%@", absoluteString, queryString];
	}
	return [NSURL URLWithString:absoluteString];
}



-(NSString *)URLEncodedString:(NSStringEncoding)encoding inUrlStr:(NSString*)urlStr{
    return 
        (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes
            ( NULL,
            (__bridge CFStringRef)urlStr,                                                                                 
            NULL,
             (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% -", 
            CFStringConvertNSStringEncodingToEncoding(encoding)
        );
    
    //refer http://en.wikipedia.org/wiki/Percent-encoding
    //refer http://tools.ietf.org/html/rfc3986
    
    
    //(CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ", because - need change to %2d and then the url will correct
    //(CFStringRef)@"-!*'\"();:@&=+$,/?%#[]% ", 
    
}

// Decode a percent escape encoded string.
//NSString* decodeFromPercentEscapeString(NSString *string) {
-(NSString*) decodeFromPercentEscapeString:(NSString*) string 
{    
    //refer http://cybersam.com/ios-dev/proper-url-percent-encoding-in-ios
    return (__bridge_transfer NSString *)
    CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                            (__bridge CFStringRef) string,
                                                            CFSTR(""),
                                                            kCFStringEncodingUTF8);
}

-(NSString*) extractValueByPattern:(NSString*)patternStr inTxtStr:(NSString*)txtStr {
    if(patternStr ==nil || txtStr ==nil) return nil;
    
    //    NSString *pattern = [NSString stringWithFormat:@"%@(.+?)%@", beginStr, endStr];    
    NSString *pattern = [NSString stringWithFormat:@"%@", patternStr];        
    NSError * err = nil;
    NSRegularExpression *regex = [NSRegularExpression
                                  regularExpressionWithPattern:pattern
                                  options:
                                  NSRegularExpressionCaseInsensitive
                                  error:&err];
    if(err!=nil) {
        NSLog(@"extractValueByPattern get err = %@", [err localizedDescription]);
        return nil;
    }
    
    //    return [[regex matchesInString:loadData options:NSCaseInsensitiveSearch range:NSMakeRange(0,[loadData length])] objectAtIndex:0];
    
    NSTextCheckingResult *textCheckingResult = [regex firstMatchInString:txtStr options:0 range:NSMakeRange(0, txtStr.length)];
    NSRange matchRange = [textCheckingResult rangeAtIndex:1];
    NSString *match = [txtStr substringWithRange:matchRange];
    if([match isEqualToString:@""]) 
    {
        return nil;
    }
    return match;
}


static unsigned char base64EncodeLookup[65] =
"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

//
// Definition for "masked-out" areas of the base64DecodeLookup mapping
//
#define xx 65

//
// Mapping from ASCII character to 6 bit pattern.
//
static unsigned char base64DecodeLookup[256] =
{
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63, 
    52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx, 
    xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14, 
    15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx, 
    xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 
    41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
    xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 
};


#define BINARY_UNIT_SIZE 3
#define BASE64_UNIT_SIZE 4

char *NewBase64Encode(
                      const void *buffer,
                      size_t length,
                      bool separateLines,
                      size_t *outputLength)
{
	const unsigned char *inputBuffer = (const unsigned char *)buffer;
	
#define MAX_NUM_PADDING_CHARS 2
#define OUTPUT_LINE_LENGTH 64
#define INPUT_LINE_LENGTH ((OUTPUT_LINE_LENGTH / BASE64_UNIT_SIZE) * BINARY_UNIT_SIZE)
#define CR_LF_SIZE 2
    
	//
	// Byte accurate calculation of final buffer size
	//
	size_t outputBufferSize =
    ((length / BINARY_UNIT_SIZE)
     + ((length % BINARY_UNIT_SIZE) ? 1 : 0))
    * BASE64_UNIT_SIZE;
	if (separateLines)
	{
		outputBufferSize +=
        (outputBufferSize / OUTPUT_LINE_LENGTH) * CR_LF_SIZE;
	}
    
	//
	// Include space for a terminating zero
	//
	outputBufferSize += 1;
    
	//
	// Allocate the output buffer
	//
	char *outputBuffer = (char *)malloc(outputBufferSize);
	if (!outputBuffer)
	{
		return NULL;
	}
    
	size_t i = 0;
	size_t j = 0;
	const size_t lineLength = separateLines ? INPUT_LINE_LENGTH : length;
	size_t lineEnd = lineLength;
    
	while (true)
	{
		if (lineEnd > length)
		{
			lineEnd = length;
		}
        
		for (; i + BINARY_UNIT_SIZE - 1 < lineEnd; i += BINARY_UNIT_SIZE)
		{
			//
			// Inner loop: turn 48 bytes into 64 base64 characters
			//
			outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                                   | ((inputBuffer[i + 1] & 0xF0) >> 4)];
			outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i + 1] & 0x0F) << 2)
                                                   | ((inputBuffer[i + 2] & 0xC0) >> 6)];
			outputBuffer[j++] = base64EncodeLookup[inputBuffer[i + 2] & 0x3F];
		}
        
		if (lineEnd == length)
		{
			break;
		}
        
		//
		// Add the newline
		//
		outputBuffer[j++] = '\r';
		outputBuffer[j++] = '\n';
		lineEnd += lineLength;
	}
    
	if (i + 1 < length)
	{
		//
		// Handle the single '=' case
		//
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[((inputBuffer[i] & 0x03) << 4)
                                               | ((inputBuffer[i + 1] & 0xF0) >> 4)];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i + 1] & 0x0F) << 2];
		outputBuffer[j++] =	'=';
	}
	else if (i < length)
	{
		//
		// Handle the double '=' case
		//
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0xFC) >> 2];
		outputBuffer[j++] = base64EncodeLookup[(inputBuffer[i] & 0x03) << 4];
		outputBuffer[j++] = '=';
		outputBuffer[j++] = '=';
	}
	outputBuffer[j] = 0;
    
	//
	// Set the output length and return the buffer
	//
	if (outputLength)
	{
		*outputLength = j;
	}
	return outputBuffer;
}



- (NSString *)getBase64EncodedString:(NSData*)data
{
	size_t outputLength;
	char *outputBuffer =
    //    NewBase64Encode([self bytes], [self length], true, &outputLength);
//    NewBase64Encode([data bytes], [data length], true, &outputLength);    
      NewBase64Encode([data bytes], [data length],false, &outputLength);
    //the E-mail cannot accpet base64 encoding with seperate line
    //so we change the default value from true to false;
    
    
	NSString *result =
    [[NSString alloc]
     initWithBytes:outputBuffer
     length:outputLength
     encoding:NSASCIIStringEncoding];
    //     autorelease];
    
    
	free(outputBuffer);
	return result;
}


- (NSString *)getBase64EncodedStringWithSeparateLines:(BOOL)separateLines withData:(NSData*)data
{
	size_t outputLength;
	char *outputBuffer =
    //NewBase64Encode([self bytes], [self length], separateLines, &outputLength);
    NewBase64Encode([data bytes], [data length], separateLines, &outputLength);
	NSString *result =
    [[NSString alloc] initWithBytes:outputBuffer length:outputLength
     encoding:NSASCIIStringEncoding];
    //     autorelease];
	free(outputBuffer);
	return result;
}


- (NSString*) getSyncBase64HtmlImgSrcWithUrl:(NSString*)urlStr andCompressionQuality:(CGFloat)quality {
    NSLog(@"getSyncBase64HtmlImgSrcWithUrl is TODO for Mac OS X");
    return nil;
    NSData * data;
   NSImage * image = [self getSyncImageWithUrlStr:urlStr];
   //data = UIImageJPEGRepresentation(image, quality);
    NSString *base64Header = @"data:image/jpeg;base64,";    
    NSString * base64Content = [self getBase64EncodedString:data];
    // need to replace the last character = as %3D?    
    NSString * base64Full = [NSString stringWithFormat:@"%@%@", base64Header, base64Content];
    return base64Full;
}


@end
