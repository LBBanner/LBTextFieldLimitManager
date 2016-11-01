//
//  LBTextFieldLimitManager.m
//  LBTextFieldLimitManager
//
//  Created by 凌斌 on 16/11/1.
//  Copyright © 2016年 ling. All rights reserved.
//

#import "LBTextFieldLimitManager.h"

@interface LBTextFieldLimitManager ()

@property (nonatomic, assign) NSInteger maxNumberOfDescriptionChars;    //最大限制字符个数
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) NSString *lastTextContent;
@property (nonatomic,copy) TextFieldDidChangeHandler block;

@end

@implementation LBTextFieldLimitManager

+ (instancetype)sharedManager
{
    static LBTextFieldLimitManager *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[self alloc] init];
        [[NSNotificationCenter defaultCenter] addObserver:_sharedManager selector:@selector(textFieldDidChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    });
    return _sharedManager;
}

- (void)limitTextField:(UITextField *)textField bytesLength:(NSInteger)maxLength handler:(TextFieldDidChangeHandler)block
{
    self.textField = textField;
    self.maxNumberOfDescriptionChars = maxLength;
    self.block =  block;
}

- (void)textFieldDidChanged:(NSNotification *)noti
{
    //下面是修改部分
    bool isChinese;//判断当前输入法是否是中文
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    //[[UITextInputMode currentInputMode] primaryLanguage]，废弃的方法
    if ([current.primaryLanguage isEqualToString: @"en-US"]) {
        isChinese = false;
    }
    else
    {
        isChinese = true;
    }
    
    int bytes = [self stringConvertToInt:_textField.text];
    // length是自己设置的位数
    NSString *str = [[_textField text] stringByReplacingOccurrencesOfString:@"?" withString:@""];
    
    if (isChinese) { //中文输入法下
        UITextRange *selectedRange = [_textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [_textField positionFromPosition:selectedRange.start offset:0];
        
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if ( bytes > self.maxNumberOfDescriptionChars/2) {
                _textField.text = _lastTextContent;
            }
            else
            {
                _lastTextContent = _textField.text;
            }
        }
        else
        {
            // NSLog(@"输入的");
            
        }
    }else{
        
        if (bytes > self.maxNumberOfDescriptionChars/2) {
            NSString *strNew = [NSString stringWithString:str];
            [_textField setText:[strNew substringToIndex:6]];
        }
    }
    
    if (bytes > self.maxNumberOfDescriptionChars/2) {
        [_textField setText:_lastTextContent];
    }
    
    //回调
    if (self.block) {
        self.block(_textField);
    }

}

//得到字节数函数
-  (int)stringConvertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++)
    {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _lastTextContent = textField.text;
    return YES;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
