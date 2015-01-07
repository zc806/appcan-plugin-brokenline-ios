//
//  EUExBrokenLine.m
//  EUExBrokenLine
//
//  Created by AppCan on 13-2-25.
//  Copyright (c) 2013年 AppCan. All rights reserved.
//

#import "EUExBrokenLine.h"
#import "PCLineChartView.h"
#import "EUtility.h"
#import "NSString+SBJSON.h"
@implementation EUExBrokenLine

@synthesize redLineInfo,tempAryData,xAxisDeclare;
-(void)dealloc
{
    self.redLineInfo = nil;
    self.tempAryData = nil;
    self.xAxisDeclare = nil;
    [allViews release];
    [super dealloc];
}
//打开界面(x,y,width,height，upforePic,donwforePic,backPic)
-(void)open:(NSMutableArray *)inArguments {
    int tag = [[inArguments objectAtIndex:4] intValue];
    if (!allViews) {
        allViews = [[NSMutableDictionary alloc]initWithCapacity:1];
    }
    NSArray * keys = [allViews allKeys];
    if (![keys containsObject:[NSString stringWithFormat:@"%d",tag]]) {
        float x = [[inArguments objectAtIndex:0]floatValue];
        float y = [[inArguments objectAtIndex:1]floatValue];
        float width = [[inArguments objectAtIndex:2]floatValue];
        float hight = [[inArguments objectAtIndex:3]floatValue];
        
        //画板
        UIView * backboard = [[UIView alloc]init];
        backboard.tag=tag;
        backboard.frame=CGRectMake(x, y,width, hight);
        [backboard setBackgroundColor:[UIColor whiteColor]];
        [EUtility brwView:meBrwView addSubview:backboard];
        [backboard release];
        
        //将画板添加到字典
        [allViews setObject:backboard forKey:[NSString stringWithFormat:@"%d",tag] ];
        
        //结算y轴数字大小
        float  quantitywidth;
        int temp = step;
        if ((step - temp) == 0) {
            NSString *  maxstring = [NSString stringWithFormat:@"%g",max];
            CGSize feelSize = [maxstring sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(190,200)];
            quantitywidth = feelSize.width;
        } else {
            NSString *  maxstring = [NSString stringWithFormat:@"%.1f",max];
            CGSize feelSize = [maxstring sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:CGSizeMake(190,200)];
            quantitywidth = feelSize.width;
        }
        
        //横轴条数
        int xAxis = (max-min)/step + 1;
        float linestep = (backboard.bounds.size.height-20)/xAxis;
        
        //绘画折线系统
        UIScrollView * testview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,backboard.bounds.size.width, backboard.bounds.size.height)];
        //计算每个格占的像素数
        float precell = (testview.bounds.size.width-20-quantitywidth)/(xAxisVlues-1);
        //计算折线在x轴上的长度
        float totalcell = precell * ([self.xAxisDeclare count] - 1) + 20;
        
        testview.backgroundColor = [UIColor clearColor];
        [testview setContentSize:CGSizeMake(totalcell, testview.bounds.size.height)];
        testview.showsVerticalScrollIndicator = NO;
        testview.showsHorizontalScrollIndicator = NO;
        [testview setContentOffset:CGPointMake(totalcell-testview.bounds.size.width,0)];
        [backboard addSubview:testview];
        [testview release];
        
        CGRect linesrect = CGRectMake(0,0,totalcell,[testview bounds].size.height);
        PCLineChartView * view = [[PCLineChartView alloc]initWithFrame:linesrect];
        view.points = self.tempAryData;
        view.numTransverseLine = xAxis;
        view.xAxisNotes = self.xAxisDeclare;
        view.rightNotesWidth = quantitywidth;
        view.max = max;
        view.min = min;
        view.ActX = ActX;
        view.redLines = self.redLineInfo;
        view.frame = CGRectMake(0,0,totalcell,[testview bounds].size.height);
        [testview addSubview:view];
        [view release];
        
        ////显示y轴数字
        UIView * ynumview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, quantitywidth, linestep*(xAxis-1)+20)];
        ynumview.backgroundColor = [UIColor whiteColor];
        [backboard addSubview:ynumview];
        [ynumview release];
        for (int i = 0; i < xAxis;i ++) {
            UILabel * quantity= [[UILabel alloc]initWithFrame:CGRectMake(0, linestep * i, quantitywidth, 20)];
            int temp = step;
            if ((step - temp) == 0) {
                quantity.text = [NSString stringWithFormat:@"%g",max - step * i];
            } else {
                quantity.text = [NSString stringWithFormat:@"%.1f",max - step * i];
            }

            quantity.textAlignment = UITextAlignmentRight;
            quantity.textColor = [UIColor redColor];
            [quantity setFont:[UIFont systemFontOfSize:16]];
            quantity.backgroundColor = [UIColor clearColor];
            [ynumview addSubview:quantity];
            [quantity release];
        }
    }
}
//设置数据
-(void)setData:(NSMutableArray*)inArguments
{
    NSString * tempData = [inArguments objectAtIndex:0];
    if ([tempData isKindOfClass:[NSString class]] && tempData.length>0)
    {
        NSMutableDictionary * dictData = [tempData JSONValue];
        if ([dictData isKindOfClass:[NSMutableDictionary class]] && [dictData count] > 0)
        {
            self.tempAryData = [dictData objectForKey:@"data"];
            NSMutableDictionary * yAxisValues = [dictData objectForKey:@"y"];
            if ([yAxisValues isKindOfClass:[NSMutableDictionary class]] && [yAxisValues count]>0)
            {
                min = [[yAxisValues objectForKey:@"min"]floatValue];
                max = [[yAxisValues objectForKey:@"max"]floatValue];
                step = [[yAxisValues objectForKey:@"step"]floatValue];
            }
            ActX = [[dictData objectForKey:@"actx"]intValue];
            
            self.redLineInfo = [dictData objectForKey:@"compareY"];
            //x轴           
            self.xAxisDeclare = [dictData objectForKey:@"x"];
            xAxisVlues = [[dictData objectForKey:@"xCount"]intValue];//每屏幕显示纵轴个数
        }
    }
    
}

//关闭此插件
-(void)close:(NSMutableArray*)inArguments {
    int tag = [[inArguments objectAtIndex:0]intValue];
    UIView * temptView = [allViews objectForKey:[NSString stringWithFormat:@"%d",tag]];
    [temptView removeFromSuperview];
    [allViews removeObjectForKey:[NSString stringWithFormat:@"%d",tag]];
}
@end
