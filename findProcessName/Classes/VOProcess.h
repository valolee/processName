//
//  VOProcess.h
//  testProcess
//
//  Created by 李锦波 on 15/4/1.
//  Copyright (c) 2015年 Valo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VOProcess : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *cpu;
@property (nonatomic, copy) NSString *useTime;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, copy) NSString *status;
/** 其他信息 */
@property (nonatomic, strong) NSDictionary   *info;

@end
