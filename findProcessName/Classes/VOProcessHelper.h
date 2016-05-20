//
//  VOProcessHelper.h
//  testProcess
//
//  Created by 李锦波 on 15/4/1.
//  Copyright (c) 2015年 Valo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VOProcess.h"

@interface VOProcessHelper : NSObject

+ (NSArray *)runningProcesses;

+ (NSArray *)systemProcesses;

+ (VOProcess *)getProcessWithName:(NSString *)processName;

+ (BOOL)isProcessRunning:(NSString *)processName;

@end
