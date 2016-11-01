//
//  LBTextFieldLimitManager.h
//  LBTextFieldLimitManager
//
//  Created by 凌斌 on 16/11/1.
//  Copyright © 2016年 ling. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^TextFieldDidChangeHandler)(UITextField *textField);

@interface LBTextFieldLimitManager : NSObject
+ (instancetype)sharedManager;
- (void)limitTextField:(UITextField *)textField bytesLength:(NSInteger)maxLength handler:(TextFieldDidChangeHandler)block;

@end
