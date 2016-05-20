//
//  VOProcessHelper.m
//  testProcess
//
//  Created by 李锦波 on 15/4/1.
//  Copyright (c) 2015年 Valo. All rights reserved.
//

#import "VOProcessHelper.h"
#include<objc/runtime.h>
#include <sys/sysctl.h>

#include <stdbool.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/sysctl.h>
#import "ELLIOKitDumper.h"
#import "VOIOKitUtils.h"

@implementation VOProcessHelper
#if 0
//You can determine if your app is being run under the debugger with the following code from
static bool AmIBeingDebugged(void)
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
    
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
    
    info.kp_proc.p_flag = 0;
    
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
    
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
    
    // Call sysctl.
    
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
    
    // We're being debugged if the P_TRACED flag is set.
    
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}
#endif
//返回所有正在运行的进程的 id，name，占用cpu，运行时间
//使用函数int   sysctl(int *, u_int, void *, size_t *, void *, size_t)
+ (NSArray *)runningProcesses
{
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        return [self runningProcessesInIOS9];
    }
    
    //指定名字参数，按照顺序第一个元素指定本请求定向到内核的哪个子系统，第二个及其后元素依次细化指定该系统的某个部分。
    //CTL_KERN，KERN_PROC,KERN_PROC_ALL 正在运行的所有进程
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL ,0};
    
    
    size_t miblen = 4;
    //值-结果参数：函数被调用时，size指向的值指定该缓冲区的大小；函数返回时，该值给出内核存放在该缓冲区中的数据量
    //如果这个缓冲不够大，函数就返回ENOMEM错误
    size_t size;
    //返回0，成功；返回-1，失败
    int st = sysctl(mib, (u_int)miblen, NULL, &size, NULL, 0);
    if (st == -1) {
        return nil;
    }
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    do
    {
        size += size / 10;
        newprocess = realloc(process, size);
        if (!newprocess)
        {
            if (process)
            {
                free(process);
                process = NULL;
            }
            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, (u_int)miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0)
    {
        if (size % sizeof(struct kinfo_proc) == 0)
        {
            int nprocess = (int)(size / sizeof(struct kinfo_proc));
            if (nprocess)
            {
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = nprocess - 1; i >= 0; i--)
                {
                    VOProcess *proc = [[VOProcess alloc] init];
                    
                    proc.identifier = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    proc.name = [[NSString alloc] initWithFormat:@"%s", process[i].kp_proc.p_comm];
                    proc.cpu = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_estcpu];
                    double t = [[NSDate date] timeIntervalSince1970] - process[i].kp_proc.p_un.__p_starttime.tv_sec;
                    proc.useTime = [[NSString alloc] initWithFormat:@"%f",t];
                    proc.startTime = [NSDate dateWithTimeIntervalSince1970:process[i].kp_proc.p_un.__p_starttime.tv_sec];
                    proc.status = [[NSString alloc] initWithFormat:@"%d",(int)process[i].kp_proc.p_priority];
                    proc.info       = @{@"p_stat":@(process[i].kp_proc.p_stat),
                                        @"p_estcpu":@(process[i].kp_proc.p_estcpu),
                                        @"p_cpticks":@(process[i].kp_proc.p_cpticks),
                                        @"p_pctcpu":@(process[i].kp_proc.p_pctcpu),
                                        @"p_swtime":@(process[i].kp_proc.p_swtime),
                                        @"p_slptime":@(process[i].kp_proc.p_slptime),
                                        @"p_realtimer.it_interval.tv_sec":@(process[i].kp_proc.p_realtimer.it_interval.tv_sec),
                                        @"p_realtimer.it_interval.tv_usec":@(process[i].kp_proc.p_realtimer.it_interval.tv_usec),
                                        @"p_realtimer.it_value.tv_sec":@(process[i].kp_proc.p_realtimer.it_value.tv_sec),
                                        @"p_realtimer.it_value.tv_usec":@(process[i].kp_proc.p_realtimer.it_value.tv_usec),
                                        @"p_rtime.tv_sec":@(process[i].kp_proc.p_rtime.tv_sec),
                                        @"p_rtime.tv_usec":@(process[i].kp_proc.p_rtime.tv_usec),
                                        @"p_priority":@(process[i].kp_proc.p_priority),
                                        @"p_usrpri":@(process[i].kp_proc.p_usrpri),
                                        @"p_nice":@(process[i].kp_proc.p_nice),
                                        @"p_comm":[NSString stringWithFormat:@"%s", process[i].kp_proc.p_comm],
                                        @"p_xstat":@(process[i].kp_proc.p_xstat),
                                        @"p_acflag":@(process[i].kp_proc.p_acflag),
                                        };
                    [array addObject:proc];
                }
                
                free(process);
                process = NULL;                
                return array;
            }
        }
    }
    free(process);
    return nil;
}
+ (NSArray *)runningProcessesInIOS9{
    ELLIOKitDumper *dumper   = [[ELLIOKitDumper alloc] init];
    ELLIOKitNodeInfo *root   = [dumper dumpIOKitTree];
    NSArray *termes       = [VOIOKitUtils searchPropertiesForTerm:@"pid " inSubTree:root];
    NSMutableSet *procSet = [NSMutableSet set];
    for (NSString *term in termes) {
        NSArray *array = [term componentsSeparatedByString:@", "];
        if (array.count == 2) {
            [procSet addObject:array[1]];
        }
    }
    
    NSMutableArray *retArray = @[].mutableCopy;
    for (NSString *proc in procSet.allObjects) {
            VOProcess *process = [[VOProcess alloc] init];
            process.name = proc;
            [retArray addObject:process];
    }

    return retArray;
}

+ (VOProcess *)getProcessWithName:(NSString *)processName{
    NSArray *processes = [VOProcessHelper runningProcesses];
    for (VOProcess *process in processes) {
        if ([process.name isEqualToString:processName]) {
            return process;
        }
    }
    return nil;
}

+ (BOOL)isProcessRunning:(NSString *)processName{
    NSArray *processes = [VOProcessHelper runningProcesses];
    BOOL found = NO;
    for (VOProcess *process in processes) {
        if ([process.name isEqualToString:processName]) {
            found = YES;
            break;
        }
    }
    return found;
}


+ (NSArray *)systemProcesses{
    return [NSArray arrayWithObjects:
             @"kernel_task",
             @"launchd",
             @"UserEventAgent",
             @"wifid",
             @"syslogd",
             @"powerd",
             @"lockdownd",
             @"mediaserverd",
             @"mediaremoted",
             @"mDNSResponder",
             @"locationd",
             @"imagent",
             @"iapd",
             @"fseventsd",
             @"fairplayd.N81",
             @"configd",
             @"apsd",
             @"aggregated",
             @"SpringBoard",
             @"CommCenterClassi",
             @"BTServer",
             @"notifyd",
             @"MobilePhone",
             @"ptpd",
             @"afcd",
             @"notification_pro",
             @"notification_pro",
             @"syslog_relay",
             @"notification_pro",
             @"springboardservi",
             @"atc",
             @"sandboxd",
             @"networkd",
             @"lsd",
             @"securityd",
             @"lockbot",
             @"installd",
             @"debugserver",
             @"amfid",
             @"AppleIDAuthAgent",
             @"BootLaunch",
             @"MobileMail",
             @"BlueTool",
             nil];
}

@end
