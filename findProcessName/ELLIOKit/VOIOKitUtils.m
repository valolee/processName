//
//  VOIOKitUtils.m
//  earnWallet
//
//  Created by Valo on 15/7/14.
//  Copyright (c) 2015年 sicent. All rights reserved.
//

#import "VOIOKitUtils.h"
#import "ELLIOKitDumper.h"
#import "DeviceUtil.h"

NSString *const VOIOPropertyKey         = @"property";
NSString *const VOIONodeKey             = @"node";
NSString *const VOIONameKey             = @"name";


@implementation VOIOKitUtils

+ (NSString *)valueForProperty:(NSString *)property andNode:(NSString *)nodeName inSubTree:(ELLIOKitNodeInfo *)subTree{
    NSArray *matches = [[self class] searchForProperty:property andNode:nodeName inSubTree:subTree];
    if (matches.count == 1) {
        ELLIOKitNodeInfo *match = matches[0];
        if (match.matchingProperties.count == 1) {
            NSString *matchingProperty = match.matchingProperties[0];
            return [[self class] praseValueForString:matchingProperty];
        }
    }
    return @"unsearched";
}

+ (NSString *)praseValueForString:(NSString *)sourceString{
    NSString *resultString = nil;
    NSRange rangeFront = [sourceString rangeOfString:@"<" options:NSCaseInsensitiveSearch];
    NSRange rangeback = [sourceString rangeOfString:@">" options:NSCaseInsensitiveSearch];
    if (rangeFront.location != NSNotFound && rangeback.location != NSNotFound) {
        NSRange idRange = NSMakeRange(rangeFront.location + rangeFront.length,
                                      rangeback.location - (rangeFront.location + rangeFront.length));
        resultString = [sourceString substringWithRange:idRange];
    }
    else{
        NSRange range = [sourceString rangeOfString:@"="];
        if (range.location != NSNotFound) {
            resultString = [sourceString substringFromIndex:range.location + range.length];
        }
    }
    if (resultString) {
        resultString = [resultString stringByReplacingOccurrencesOfString:@" " withString:@""];
        resultString = [resultString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    }
    else{
        resultString = @"unsearched";
    }
    return resultString;
}

+ (NSArray *)searchForProperty:(NSString *)property andNode:(NSString *)nodeName inSubTree:(ELLIOKitNodeInfo *)subTree{
    NSMutableArray *searchArray = [NSMutableArray array];
    if ([subTree.name isEqualToString:nodeName]) {
        NSMutableArray *matchingProperties = [NSMutableArray array];
        [subTree.properties enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
            if ([obj rangeOfString:property options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [matchingProperties addObject:obj];
            }
        }];
        if (matchingProperties.count > 0) {
            subTree.matchingProperties = matchingProperties;
            [searchArray addObject:subTree];
        }
    }
    
    NSMutableArray *matchedChildren = [NSMutableArray array];
    
    for (ELLIOKitNodeInfo *child in subTree.children) {
        NSArray *array = [[self class] searchForProperty:property andNode:nodeName inSubTree:child];
        [searchArray addObjectsFromArray:array];
        if (array.count > 0) {
            [matchedChildren addObject:child];
        }
    }
    
    return searchArray;
}

+ (NSDictionary *)searchPropertiesWithInfoArray:(NSArray *)infoArray inSubTree:(ELLIOKitNodeInfo *)subTree dumpError:(NSError *)dumpError{
    NSMutableDictionary *resultDic = [NSMutableDictionary dictionary];
    if (dumpError){
        NSString *hwString = [DeviceUtil hardwareString];
        NSString *osVersion = [UIDevice currentDevice].systemVersion;
        NSString *phoneInfo = [NSString stringWithFormat:@"%@-%@", hwString, osVersion];
        [resultDic addEntriesFromDictionary:@{@"product":phoneInfo}];
        NSString *errorType = dumpError.userInfo[@"type"];
        [resultDic addEntriesFromDictionary:@{@"battery":errorType}];
        return resultDic;
    }
    
    for (NSDictionary *dic in infoArray) {
        NSString *property = dic[VOIOPropertyKey];
        NSString *node     = dic[VOIONodeKey];
        NSString *name     = dic[VOIONameKey];
        if (name && property && node) {
            NSString *value = [VOIOKitUtils valueForProperty:property andNode:node inSubTree:subTree];
            if (value && value.length > 0) {
                [resultDic addEntriesFromDictionary:@{name:value}];
            }
            else{
                [resultDic addEntriesFromDictionary:@{name:@"ErrorSearchProperty"}];
            }
        }
    }
    if (resultDic.count == 0) {
        [resultDic addEntriesFromDictionary:@{@"error":@"ErrorSearchInfo"}];
    }
    
    return resultDic;
}

+ (NSString *)stringForSearchPropertiesWithInfoArray:(NSArray *)infoArray inSubTree:(ELLIOKitNodeInfo *)subTree dumpError:(NSError *)dumpError{
    NSMutableString *resultString = [NSMutableString string];
    if (dumpError){
        NSString *hwString = [DeviceUtil hardwareString];
        NSString *osVersion = [UIDevice currentDevice].systemVersion;
        NSString *phoneInfo = [NSString stringWithFormat:@"%@-%@", hwString, osVersion];
        [resultString appendFormat:@"%@;",phoneInfo];
        NSString *errorType = dumpError.userInfo[@"type"];
        [resultString appendFormat:@"%@;",errorType];
        return resultString;
    }
    
    for (NSDictionary *dic in infoArray) {
        NSString *property = dic[VOIOPropertyKey];
        NSString *node     = dic[VOIONodeKey];
        NSString *name     = dic[VOIONameKey];
        if (name && property && node) {
            NSString *value = [VOIOKitUtils valueForProperty:property andNode:node inSubTree:subTree];
            if (value && value.length > 0) {
                [resultString appendFormat:@"%@;",value];
            }
            else{
                [resultString appendFormat:@"%@;",@"ErrorSearchProperty"];
            }
        }
    }
    if (resultString.length == 0){
        [resultString appendString:@"ErrorSearchInfo"];
    }
    return resultString;
}

+ (NSArray *)searchPropertiesForTerm:(NSString *)searchTerm inSubTree:(ELLIOKitNodeInfo *)subTree {
    NSMutableArray *matchingProperties = @[].mutableCopy;
    [subTree.properties enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        if ([obj rangeOfString:searchTerm options:NSCaseInsensitiveSearch].location != NSNotFound) {
            [matchingProperties addObject:obj];
        }
    }];
    
    for (ELLIOKitNodeInfo *child in subTree.children) {
        [matchingProperties addObjectsFromArray:[self searchPropertiesForTerm:searchTerm inSubTree:child]];
    }
    
    return matchingProperties;
}


@end
