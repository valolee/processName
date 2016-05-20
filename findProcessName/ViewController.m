//
//  ViewController.m
//  findProcessName
//
//  Created by Valo on 15/7/3.
//  Copyright (c) 2015年 Valo. All rights reserved.
//

#import "ViewController.h"
#import "UIView+Border.h"
#import "VOProcessHelper.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *beforeButton;
@property (weak, nonatomic) IBOutlet UIButton *afterButton;
@property (weak, nonatomic) IBOutlet UITextView *beforeTextView;
@property (weak, nonatomic) IBOutlet UITextView *afterTextView;
@property (weak, nonatomic) IBOutlet UITextView *maybeTextView;
@property (nonatomic, strong) NSArray *beforeArray;
@property (nonatomic, strong) NSArray *afterArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self redrawSubviews];
}

- (void)redrawSubviews{
    [UIView defaultRoundCornerForViews:@[self.beforeButton, self.afterButton] WithBorder:NO];
    [UIView defaultRoundCornerForViews:@[self.beforeTextView,self.afterTextView,self.maybeTextView] WithBorder:YES];
}

- (NSString *)stringWithProcessArray:(NSArray *)processArray{
    NSMutableString *string = [NSMutableString string];
    for (VOProcess *process in processArray) {
        [string appendFormat:@"%@\n", process.name];
    }
    return string;
}
- (IBAction)beforeProcesses {
    self.beforeTextView.text = @"";
    self.afterTextView.text = @"";
    self.maybeTextView.text = @"";
    self.beforeArray = [VOProcessHelper runningProcesses];
    self.beforeTextView.text = [self stringWithProcessArray:self.beforeArray];
}
- (IBAction)afterProcess {
    self.afterArray = [VOProcessHelper runningProcesses];
    self.afterTextView.text = @"";
    self.afterTextView.text = [self stringWithProcessArray:self.afterArray];
    NSMutableArray *maybeArray = [NSMutableArray array];
    for (VOProcess *after in self.afterArray) {
        BOOL found = NO;
        for (VOProcess *before in self.beforeArray) {
            if ([before.name isEqualToString:after.name]) {
                found = YES;
                break;
            }
        }
        if (!found) {
            [maybeArray addObject:after];
        }
    }
    self.maybeTextView.text = [self stringWithProcessArray:maybeArray];
}

@end
