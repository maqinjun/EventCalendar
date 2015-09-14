//
//  Event.h
//  EventCalendar
//
//  Created by maqj on 15/9/10.
//  Copyright (c) 2015年 msxt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECUIView.h"

@interface Event : NSObject<ECEventDelegate>

@property (nonatomic, assign) long startDate;
@property (nonatomic, assign) long endDate;
@property (nonatomic, strong) UIColor *eventColor;
@property (nonatomic, assign) BOOL isAllday;

@end
