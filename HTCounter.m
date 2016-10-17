//
//  HTCounter.m
//  Test
//
//  Created by HengtaoDai on 16/10/10.
//  Copyright © 2016年 HYcompany. All rights reserved.
//

#import "HTCounter.h"

static const NSUInteger kMaxValue = NSUIntegerMax;  //最大无符号整数
static const NSUInteger kMinValue = 1;

@interface HTCounter () <UITextFieldDelegate>
{
    UIButton        *_btnCut;
    UIButton        *_btnAdd;
    UITextField     *_txtNum;
    NSUInteger       _iPreValidValue;  //记录上一次有效的值  last valid value
}
@end

@implementation HTCounter

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        CGFloat btnWidth = 0.31*frame.size.width;
        CGFloat txtWidth = 0.38*frame.size.width;
        //减 cut
        _btnCut = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, btnWidth, frame.size.height)];
        [_btnCut setImage:[UIImage imageNamed:@"icon_cut_yes"] forState:UIControlStateNormal];
        [_btnCut setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [_btnCut addTarget:self action:@selector(btnCut) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnCut];
        
        //加 add
        _btnAdd = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-btnWidth, 0, btnWidth, frame.size.height)];
        [_btnAdd setImage:[UIImage imageNamed:@"icon_add_yes"] forState:UIControlStateNormal];
        [_btnAdd setBackgroundColor:RGBCOLOR(235, 235, 235)];
        [_btnAdd addTarget:self action:@selector(btnAdd) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_btnAdd];
        
        //数字框 
        _txtNum = [[UITextField alloc] initWithFrame:CGRectMake(btnWidth, 0, txtWidth, frame.size.height)];
        _txtNum.textColor = [UIColor blackColor];
        _txtNum.font = [UIFont systemFontOfSize:15];
        _txtNum.text = @"1";
        _txtNum.delegate = self;
        _txtNum.adjustsFontSizeToFitWidth = YES;
        _txtNum.textAlignment = NSTextAlignmentCenter;
        _txtNum.backgroundColor = RGBCOLOR(235, 235, 235);
        _txtNum.keyboardType = UIKeyboardTypeNumberPad;
        [self addSubview:_txtNum];
        
        //two btns
        for (int i = 0; i < 2; i++)
        {
            CGFloat left = i == 0? btnWidth-1: btnWidth+txtWidth-1;
            UIView *sxLine = [[UIView alloc]initWithFrame:CGRectMake(left, 0, 2, frame.size.height)];
            sxLine.backgroundColor = RGBCOLOR(255, 255, 255);
            [self addSubview:sxLine];
        }
        
        _iMinValue = kMinValue;   //默认下限 default max
        _iMaxValue = kMaxValue;   //默认上限 default min
        
        [self uselessOnBtn:_btnCut];    //使减按钮无效 let btnCut useless
    }
    
    return self;
}


#pragma mark - setter方法
- (void)setIMinValue:(NSUInteger)iMinValue
{
    _iMinValue = iMinValue;
    
    _txtNum.text = [NSString stringWithFormat:@"%lu",iMinValue];
    _iPreValidValue = _iMinValue;
    [self uselessOnBtn:_btnCut];
}


- (void)setIMaxValue:(NSUInteger)iMaxValue
{
    _iMaxValue = iMaxValue;
}


- (void)setEditable:(BOOL)editable
{
    _txtNum.enabled = editable;
}


- (void)setICurrentValue:(NSUInteger)iCurrentValue
{
    if (iCurrentValue >_iMinValue && iCurrentValue < _iMaxValue)
    {
        [self usefulOnBtn:_btnCut];
        [self usefulOnBtn:_btnAdd];
    }
    else
    {
        if (iCurrentValue >= _iMaxValue)
        {
            iCurrentValue = _iMaxValue;
            
            [self uselessOnBtn:_btnAdd];
            
            if (iCurrentValue > _iMinValue)
            {
                [self usefulOnBtn:_btnCut];
            }
        }
        
        if (iCurrentValue <= _iMinValue)
        {
            iCurrentValue = _iMinValue;
            
            [self uselessOnBtn:_btnCut];
            
            if (iCurrentValue < _iMaxValue)
            {
                [self usefulOnBtn:_btnAdd];
            }
        }
    }
    
    _txtNum.text = [NSString stringWithFormat:@"%lu",iCurrentValue];
    _iPreValidValue = iCurrentValue;
}


#pragma mark - getter方法
- (NSUInteger)iCurrentValue
{
    return [_txtNum.text integerValue];
}



#pragma mark - 按钮事件
- (void)btnCut
{
    if (self.iCurrentValue == _iMinValue+1)
    {
        [self uselessOnBtn:_btnCut];
    }
    else if (self.iCurrentValue == _iMinValue)
    {
        return ;
    }
    
    [self usefulOnBtn:_btnAdd];
    
    _txtNum.text = [NSString stringWithFormat:@"%lu",self.iCurrentValue-1];
    _iPreValidValue = self.iCurrentValue;
    
    if ([self.delegate respondsToSelector:@selector(counter:isAdd:value:)])
    {
        [self.delegate counter:self isAdd:NO value:self.iCurrentValue];
    }
}


- (void)btnAdd
{
    if (self.iCurrentValue == _iMaxValue-1)
    {
        [self uselessOnBtn:_btnAdd];
    }
    else if (self.iCurrentValue == _iMaxValue)
    {
        return ;
    }

    [self usefulOnBtn:_btnCut];
    
    _txtNum.text = [NSString stringWithFormat:@"%lu",self.iCurrentValue+1];
    _iPreValidValue = self.iCurrentValue;
    
    if ([self.delegate respondsToSelector:@selector(counter:isAdd:value:)])
    {
        [self.delegate counter:self isAdd:YES value:self.iCurrentValue];
    }
}


- (void)uselessOnBtn:(UIButton *)btn
{
    [btn setBackgroundColor:RGBCOLOR(250, 250, 250)];
    
    NSString *strIcon = btn == _btnAdd? @"icon_add_no": @"icon_cut_no";
    [btn setImage:[UIImage imageNamed:strIcon] forState:UIControlStateNormal];
}


- (void)usefulOnBtn:(UIButton *)btn
{
    [btn setBackgroundColor:RGBCOLOR(235, 235, 235)];
    
    NSString *strIcon = btn == _btnAdd? @"icon_add_yes": @"icon_cut_yes";
    [btn setImage:[UIImage imageNamed:strIcon] forState:UIControlStateNormal];
}


#pragma mark - UITextField Delegate
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (self.iCurrentValue > _iMaxValue || self.iCurrentValue < _iMinValue)
    {
        [SVProgressHUD showErrorWithStatus:@"输入无效值"];
        [textField resignFirstResponder];
        self.iCurrentValue = _iPreValidValue;
        
        return ;
    }
    
    if (self.iCurrentValue == _iMaxValue)
    {
        [self uselessOnBtn:_btnAdd];
        [self usefulOnBtn:_btnCut];
    }
    else if (self.iCurrentValue == _iMinValue)
    {
        [self uselessOnBtn:_btnCut];
        [self usefulOnBtn:_btnAdd];
    }
    else
    {
        [self usefulOnBtn:_btnCut];
        [self usefulOnBtn:_btnAdd];
    }
    
    if ([self.delegate respondsToSelector:@selector(counter:isAdd:value:)])
    {
        [self.delegate counter:self isAdd:YES value:self.iCurrentValue];
    }
}

@end
