//
//  ECCollectionViewCell.m
//  TheBackgrounder
//
//  Created by youxu on 15/9/13.
//  Copyright (c) 2015年 Gustavo Ambrozio. All rights reserved.
//

#import "ECCollectionViewCell.h"

@implementation ECCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _isBgBorderShow = NO;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(contextRef, 0.5);
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor whiteColor] CGColor]);
    CGContextSetFillColorWithColor(contextRef, [[UIColor whiteColor] CGColor]);
    CGContextFillRect(contextRef, rect);
    CGContextSetFillColorWithColor(contextRef, [[UIColor lightGrayColor] CGColor]);
    CGContextSetStrokeColorWithColor(contextRef, [[UIColor lightGrayColor] CGColor]);
    CGContextMoveToPoint(contextRef, rect.size.width, 0.0f);
    CGContextAddLineToPoint(contextRef, rect.size.width, rect.size.height);

    if (_isBgBorderShow) {
                
        CGContextMoveToPoint(contextRef, 0.0f, rect.size.height);
        CGContextAddLineToPoint(contextRef, rect.size.width, rect.size.height);
        
        CGContextDrawPath(contextRef, kCGPathFillStroke);

    }
    CGContextDrawPath(contextRef, kCGPathFillStroke);

}
@end
