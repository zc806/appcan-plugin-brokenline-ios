//
//  PCLineChartView.m
//  DrawLines
//
//  Created by sunzhengcuan on 13-2-21.
//  Copyright (c) 2013年 zhengzheng. All rights reserved.
//

#import "PCLineChartView.h"
#import "EUtility.h"

@implementation PCLineChartView

@synthesize points,numTransverseLine;
@synthesize xAxisNotes;
@synthesize rightNotesWidth;
@synthesize min;
@synthesize max;
@synthesize ActX;
@synthesize redLines;
-(void)dealloc {
    self.redLines = nil;
    self.points = nil;
    self.xAxisNotes = nil;
    [super dealloc];
}
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    //计算每条虚线间的间隔
    float interval = (self.bounds.size.height-20)/self.numTransverseLine;
    //计算竖线之间的间隔
    float intervalX = (self.bounds.size.width-self.rightNotesWidth-20) * 1.0/([self.xAxisNotes count]-1);
    //竖线
    for (int i = 0; i < 33; i ++)
    {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 1.5);//画笔粗细
        UIColor * c = [UIColor grayColor];
        CGContextSetStrokeColorWithColor(context, c.CGColor);//画笔颜色
        CGContextSetRGBStrokeColor(context, 132/255.0, 132/255.0, 132/255.0,0.5);//画笔颜色
        
        CGPoint cc = CGPointMake(self.rightNotesWidth+10+intervalX * i, 0);
        CGPoint dd = CGPointMake(self.rightNotesWidth+10+intervalX * i, interval * (self.numTransverseLine - 1) + 20);
        CGContextMoveToPoint(context, cc.x, cc.y);
        CGContextAddLineToPoint(context, dd.x, dd.y);
        CGContextStrokePath(context);
    }
    //x轴下面的注解标识
    for (int i = 0; i < [self.xAxisNotes count]; i ++) {
        UILabel * quantity= [[UILabel alloc]initWithFrame:CGRectMake(self.rightNotesWidth + 10 + intervalX * i - 40, interval * (self.numTransverseLine - 1) + 20, 60, 20)];
        quantity.text = [self.xAxisNotes objectAtIndex:i];
        [quantity setFont:[UIFont systemFontOfSize:14]];
        quantity.textAlignment = UITextAlignmentCenter;
        quantity.backgroundColor = [UIColor clearColor];
        [self addSubview:quantity];
        [quantity release];
        
        if (i == self.ActX) {
            quantity.textColor = [UIColor redColor];
        }
        
        CGAffineTransform transform = quantity.transform;
        transform = CGAffineTransformRotate(transform, -(M_PI/5));
        quantity.transform = transform;
        
    }
    
    //最低端的横线
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 3);//画笔粗细
    UIColor * c = [UIColor grayColor];
    CGContextSetStrokeColorWithColor(context, c.CGColor);
    CGContextSetRGBStrokeColor(context, 132/255.0, 132/255.0, 132/255.0,0.5);//画笔颜色
    
    CGPoint cc = CGPointMake(self.rightNotesWidth + 0, 10.0 + (self.numTransverseLine - 1) * interval);
    CGPoint dd = CGPointMake(self.bounds.size.width, 10.0 + (self.numTransverseLine - 1) * interval);
    CGContextMoveToPoint(context, cc.x, cc.y);
    CGContextAddLineToPoint(context, dd.x, dd.y);
    CGContextStrokePath(context);
   
    //七条横线虚线
    for (int  i = 0; i < self.numTransverseLine - 1; i ++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextBeginPath(context);
        CGContextSetLineWidth(context, 1.2);
        CGContextSetStrokeColorWithColor(context, c.CGColor);
        CGContextSetRGBStrokeColor(context, 132/255.0, 132/255.0, 132/255.0, 0.6);//画笔颜色
        float lengths[] = {1,2};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextMoveToPoint(context, self.rightNotesWidth+0, 10+i*interval);
        CGContextAddLineToPoint(context, self.bounds.size.width,10.0+i*interval);
        CGContextStrokePath(context);
    }
    //标准红线
   for (int i = 0; i < [self.redLines count]; i ++) {
        NSMutableDictionary * redInfo = [self.redLines objectAtIndex:i];
        int startIndex = [[redInfo objectForKey:@"s"]intValue];
        int endIndex = [[redInfo objectForKey:@"e"]intValue];
        
        float startPointX = self.rightNotesWidth + 10 + intervalX*startIndex;
        float endPointX = self.rightNotesWidth + 10 + intervalX*endIndex;
        
        float valueY = [[redInfo objectForKey:@"v"] floatValue];
        float valuePointY = (self.numTransverseLine*interval/( self.max-self.min+(self.max-self.min)/(self.numTransverseLine-1))) * (self.max-valueY) + 10;
        
        CGContextSetLineWidth(context, 6);//画笔粗细
        UIColor * ce = [UIColor redColor];
        CGContextSetStrokeColorWithColor(context, ce.CGColor);//画笔颜色
        
        CGPoint ccc = CGPointMake(startPointX, valuePointY);
        CGPoint ddd = CGPointMake(endPointX,valuePointY);
        float lengths[] = {3000,1};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextMoveToPoint(context, ccc.x, ccc.y);
        CGContextAddLineToPoint(context, ddd.x, ddd.y);
        CGContextStrokePath(context);
    }
   

    //开始画线
    for (int i = 0; i < [self.points count] - 1; i ++) {
        float value1 = [[self.points objectAtIndex:i] floatValue];
        float value2 = [[self.points objectAtIndex:i+1] floatValue];
        float y1 = (self.bounds.size.height-20-interval) - ((self.bounds.size.height - 20 - interval)/self.max) * value1 + 10;
        float y2 = (self.bounds.size.height - 20 - interval) - ((self.bounds.size.height - 20 - interval)/self.max) * value2 + 10;
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetLineWidth(context, 6);//画笔粗细
//        UIColor *c=[UIColor greenColor];
//        CGContextSetStrokeColorWithColor(context, c.CGColor);//画笔颜色
        CGContextSetRGBStrokeColor(context, 0, 1, 0, 0.4);
        
        CGPoint cc = CGPointMake(self.rightNotesWidth+10+intervalX * i, y1);
        CGPoint dd = CGPointMake(self.rightNotesWidth+10+intervalX * (i+1), y2);
        float lengths[] = {3000, 1};
        CGContextSetLineDash(context, 0, lengths,2);
        CGContextMoveToPoint(context, cc.x, cc.y);
        CGContextAddLineToPoint(context, dd.x, dd.y);
        CGContextStrokePath(context);
    }
    //添加结点
    for (int i = 0; i < [self.points count]; i ++) {
        float value = [[self.points objectAtIndex:i] floatValue];
        float y = (self.bounds.size.height - 20 - interval) - ((self.bounds.size.height - 20 - interval)/self.max) * value + 10;
        if (i > ActX - 1)  {
            CGRect circleRect = CGRectMake(self.rightNotesWidth + 10 + intervalX * i - 7.5,y - 10, 15, 15);
            UIImageView * rect = [[UIImageView alloc]initWithFrame:circleRect];
            NSString * impath = [[NSBundle mainBundle]pathForResource:@"uexBrokenLine/test1" ofType:@"png"];
            rect.image = [UIImage imageWithContentsOfFile:impath];
            [self addSubview:rect];
            [rect release];
        } else {
            CGRect circleRect = CGRectMake(self.rightNotesWidth + 10 + intervalX * i - 7.5,y - 10, 15, 15);
            UIImageView * rect = [[UIImageView alloc]initWithFrame:circleRect];
            NSString * impath = [[NSBundle mainBundle]pathForResource:@"uexBrokenLine/test" ofType:@"png"];
            rect.image = [UIImage imageWithContentsOfFile:impath];
            [self addSubview:rect];
            [rect release];
        }
    }
}
@end
