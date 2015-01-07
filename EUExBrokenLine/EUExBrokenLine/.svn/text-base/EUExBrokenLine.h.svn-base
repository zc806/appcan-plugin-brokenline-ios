//
//  EUExBrokenLine.h
//  EUExBrokenLine
//
//  Created by AppCan on 13-2-25.
//  Copyright (c) 2013年 AppCan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "EUExBase.h"

@interface EUExBrokenLine : EUExBase

{
    NSMutableArray * redLineInfo;
    
    NSMutableArray * tempAryData;//折线values
    //
    NSMutableArray * xAxisDeclare;//x轴显示标注
    int xAxisVlues;//每屏幕显示纵轴个数
    
    float min;//y轴最小值
    float max;//y轴最大值
    float step;//y轴步幅
    int ActX;//x轴特别标注index
    
    
    NSMutableDictionary * allViews;
}
//打开折线界面(x,y,width,height)
-(void)open:(NSMutableArray *)inArguments;

//设置数据
-(void)setData:(NSMutableArray*)inArguments;

//关闭此插件
-(void)close:(NSMutableArray*)inArguments;

@property(nonatomic,retain)NSMutableArray * redLineInfo;

@property(nonatomic,retain)NSMutableArray * tempAryData;//折线values
//
@property(nonatomic,retain)NSMutableArray * xAxisDeclare;
@end
