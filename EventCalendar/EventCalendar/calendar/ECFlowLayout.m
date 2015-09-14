//
//  ECFlowLayout.m
//  EventCalendar
//
//  Created by maqj on 15/9/10.
//  Copyright (c) 2015年 msxt. All rights reserved.
//

#import "ECFlowLayout.h"

@implementation ECFlowLayout

- (NSArray*)layoutAttributesForElementsInRect:(CGRect)rect{
    NSArray *arr = [super layoutAttributesForElementsInRect:rect];
    NSMutableArray *attributes = [NSMutableArray arrayWithArray:arr];
    
    for (int i = 0; i < attributes.count; i++) {
        UICollectionViewLayoutAttributes *attribute = [attributes objectAtIndex:i];
        NSString *kind = attribute.representedElementKind;
        
        if (kind == nil&&
            i % 8 ==0) {
            CGRect frame = attribute.frame;
            
            if (i != attributes.count - 8) {
                frame.size.height += 1;
            }
            
            attribute.frame = frame;
            
        }
        
    }
    
    return attributes;
}

@end
