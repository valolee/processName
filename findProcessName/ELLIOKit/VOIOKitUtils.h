//
//  VOIOKitUtils.h
//  earnWallet
//
//  Created by Valo on 15/7/14.
//  Copyright (c) 2015年 sicent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ELLIOKitNodeInfo.h"

FOUNDATION_EXTERN NSString *const VOIOPropertyKey;
FOUNDATION_EXTERN NSString *const VOIONodeKey;
FOUNDATION_EXTERN NSString *const VOIONameKey;

@interface VOIOKitUtils : NSObject

/**
 *  获取指定的属性值
 *
 *  @param property 属性名
 *  @param nodeName 所在的IOKit节点名
 *  @param subTree  IOKit节点树
 *
 *  @return 属性值,字符串
 */
+ (NSString *)valueForProperty:(NSString *)property andNode:(NSString *)nodeName inSubTree:(ELLIOKitNodeInfo *)subTree;

/**
 *  查找指定的属性
 *
 *  @param property 属性名
 *  @param nodeName 所在的IOKit节点名
 *  @param subTree  IOKit节点树
 *
 *  @return 符合条件的节点数组
 */
+ (NSArray *)searchForProperty:(NSString *)property andNode:(NSString *)nodeName inSubTree:(ELLIOKitNodeInfo *)subTree;

/**
 *  查找指定的属性值
 *
 *  @param infoArray 要查询的信息数组,结构为[{name:aName1,property:aProperty1,node:aNodeName1},{name:aName2,property:aProperty2,node:aNodeName2},...]
 *  @param subTree   IOKit节点树
 *  @param dumpError Dump IOKit节点树的错误信息
 *
 *  @return 符合条件的节点的值组成的字典,结构为{aName1:aValue1,aName2:aValue2,...}
 */
+ (NSDictionary *)searchPropertiesWithInfoArray:(NSArray *)infoArray inSubTree:(ELLIOKitNodeInfo *)subTree dumpError:(NSError *)dumpError;

/**
 *  查找指定的属性值
 *
 *  @param infoArray 要查询的信息数组,结构为[{name:aName1,property:aProperty1,node:aNodeName1},{name:aName2,property:aProperty2,node:aNodeName2},...]
 *  @param subTree   IOKit节点树
 *  @param dumpError Dump IOKit节点树的错误信息
 *
 *  @return 符合节点的属性值组成的字符串,以分号分隔,结构为 aValue1;aValue2;...
 */
+ (NSString *)stringForSearchPropertiesWithInfoArray:(NSArray *)infoArray inSubTree:(ELLIOKitNodeInfo *)subTree dumpError:(NSError *)dumpError;

+ (NSArray *)searchPropertiesForTerm:(NSString *)searchTerm inSubTree:(ELLIOKitNodeInfo *)subTree;

@end
