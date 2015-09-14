//
//  UIButton+Add.m
//  TheBackgrounder
//
//  Created by youxu on 15/9/7.
//  Copyright (c) 2015年 Gustavo Ambrozio. All rights reserved.
//

#import "UIButtonAdd.h"

@implementation UIButtonAdd


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGFloat w = 10.0f;
    CGFloat h = 10.0f;
    
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor whiteColor] CGColor]);
    
    CGContextSetLineWidth(contextRef, 2.0f);
    
    CGContextMoveToPoint(contextRef, rect.size.width/2 - w/2, rect.size.height/2);
    
    CGContextAddLineToPoint(contextRef, rect.size.width/2 + w/2, rect.size.height/2);
    
    CGContextMoveToPoint(contextRef, rect.size.width/2, rect.size.height/2 - h/2);
    
    CGContextAddLineToPoint(contextRef, rect.size.width/2, rect.size.height/2 + h/2);
    
    CGContextDrawPath(contextRef, kCGPathFillStroke);
}


@end
