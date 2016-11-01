//
//  DemoViewController.m
//  LBTextFieldLimitManager
//
//  Created by 凌斌 on 16/11/1.
//  Copyright © 2016年 ling. All rights reserved.
//

#import "DemoViewController.h"
#import "LBTextFieldLimitManager.h"

@interface DemoViewController ()
@property (nonatomic,strong) UITextField *textField;
@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.create UITextField
    [self createTextField];
    //2.limit textField character
    [[LBTextFieldLimitManager sharedManager] limitTextField:self.textField bytesLength:12 handler:^(UITextField *textField) {
        //code
        NSLog(@"current text length : %zd",textField.text.length);
    }];
}

- (void)createTextField {
    self.textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    self.textField.center = self.view.center;
    self.textField.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:self.textField];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
