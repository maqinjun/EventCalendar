//
//  ECUIView.h
//  EventCalendar
//
//  Created by maqj on 15/9/10.
//  Copyright (c) 2015年 msxt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JTCalendar/JTCalendar.h>

#define SCREEN_W ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_H ([UIScreen mainScreen].bounds.size.height)

@class ECUIView;

@protocol ECEventDelegate <NSObject>

@property (nonatomic, assign) long startDate;
@property (nonatomic, assign) long endDate;
@property (nonatomic, strong) UIColor *eventColor;
@property (nonatomic, assign) BOOL isAllday;

@end

@protocol ECUIViewDelegate <NSObject>

@optional
- (void)ecEventDidSelected:(id<ECEventDelegate>)event;
- (void)handleAddEvent:(id)sender;
- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar;
- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar;
@end

@protocol ECUIViewDataSource <NSObject>

@required
- (NSInteger)numbersOfEvent:(NSDate*)date;
- (id<ECEventDelegate>) eventForItemAtIndex:(NSInteger)index date:(NSDate*)date;

@end

@interface ECUIView : UIView

@property (nonatomic, weak) id<ECUIViewDataSource> dataSource;
@property (nonatomic, weak) id<ECUIViewDelegate> delegate;

- (void)reloadData;
@end
