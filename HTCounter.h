//
//  HTCounter.h
//  Test
//
//  Created by HengtaoDai on 16/10/10.
//  Copyright © 2016年 HYcompany. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HTCounter;

@protocol HTCounterDelegate <NSObject>

- (void)counter:(HTCounter *)counter isAdd:(BOOL)isAdd value:(NSUInteger)value;

@end


@interface HTCounter : UIView

@property (nonatomic, assign) NSUInteger iMinValue;    //最小的数，默认为1
@property (nonatomic, assign) NSUInteger iMaxValue;    //最大的数，默认为无限
@property (nonatomic, assign) NSUInteger iCurrentValue;   //当前数值
@property (nonatomic, assign) BOOL      editable;       //数字输入框是否可编辑，默认YES
@property (nonatomic, strong) UIColor   *txtColor;      //数字的颜色，默认为黑色
@property (nonatomic, weak) id<HTCounterDelegate> delegate;

@end
