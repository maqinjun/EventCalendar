//
//  ViewController.m
//  EventCalendar
//
//  Created by maqj on 15/9/10.
//  Copyright (c) 2015年 msxt. All rights reserved.
//

#import "ViewController.h"
#import "ECUIView.h"
#import "Event.h"

@interface ViewController ()<ECUIViewDataSource, ECUIViewDelegate>

@end

@implementation ViewController
{
    NSMutableDictionary *datas;
    NSDateFormatter *_formatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ECUIView *ecView = [[ECUIView alloc] initWithFrame:CGRectMake(0.0f, 20.0f, SCREEN_W, SCREEN_H-20.0f)];
    ecView.delegate = self;
    ecView.dataSource = self;
    
    [self.view addSubview:ecView];
    
    datas = [NSMutableDictionary dictionary];
    _formatter = [[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSArray *thisWeekDates = [self currentPageDates:[NSDate date]];
    
    for (int i = 0; i< thisWeekDates.count; i++) {
        NSDate *date = [thisWeekDates objectAtIndex:i];
        NSArray *randomEvents = [NSArray array];
        randomEvents = [self randomEvents:date count:i+1];
        
       
        datas[[_formatter stringFromDate:date]] = randomEvents;
    }
    
    
}

- (NSDate*)randomDate:(NSDate*)date{
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    int alldaySec = 24 * 60 * 60;
    
    NSInteger alldays = interval / alldaySec;
    
    long startT = alldays * alldaySec;
    
    long inter = interval - startT;
    
    int r = arc4random() % (alldaySec - inter);
    
    return [date dateByAddingTimeInterval:r];
    
}

- (NSArray*)randomEvents:(NSDate*)date  count:(int)ct{
    
    NSMutableArray *evets = [NSMutableArray array];
    
    int evtCt = ct;
    
    NSTimeInterval interval = [date timeIntervalSince1970];
    
    int alldaySec = 24* 60 * 60;
    
    NSInteger days = interval / alldaySec;
    
    NSDate *dateLeft = [NSDate dateWithTimeIntervalSince1970:days * alldaySec];
    for (int i = 0; i < evtCt; i++) {
        
        NSDate *startDate = [self randomDate:dateLeft];
        NSDate *endDate = [self randomDate:startDate];

        Event *event = [Event new];
        event.startDate = [startDate timeIntervalSince1970];
        event.endDate = [endDate timeIntervalSince1970];
        event.eventColor = [self colorWithI:i];
        event.isAllday = NO;
        [evets addObject:event];
    }
    
    return evets;
}
/*
 + (UIColor *)blackColor;      // 0.0 white
 + (UIColor *)darkGrayColor;   // 0.333 white
 + (UIColor *)lightGrayColor;  // 0.667 white
 + (UIColor *)whiteColor;      // 1.0 white
 + (UIColor *)grayColor;       // 0.5 white
 + (UIColor *)redColor;        // 1.0, 0.0, 0.0 RGB
 + (UIColor *)greenColor;      // 0.0, 1.0, 0.0 RGB
 + (UIColor *)blueColor;       // 0.0, 0.0, 1.0 RGB
 + (UIColor *)cyanColor;       // 0.0, 1.0, 1.0 RGB
 + (UIColor *)yellowColor;     // 1.0, 1.0, 0.0 RGB
 + (UIColor *)magentaColor;    // 1.0, 0.0, 1.0 RGB
 + (UIColor *)orangeColor;     // 1.0, 0.5, 0.0 RGB
 + (UIColor *)purpleColor;     // 0.5, 0.0, 0.5 RGB
 + (UIColor *)brownColor;      // 0.6, 0.4, 0.2 RGB
 + (UIColor *)clearColor;      // 0.0 white, 0.0 alpha

 */

- (UIColor*)colorWithI:(int)i{
    switch (i) {
        case 0:
            return [UIColor redColor];
        case 1:
            return [UIColor darkGrayColor];
        case 2:
            return [UIColor greenColor];
        case 3:
            return [UIColor blueColor];
        case 4:
            return [UIColor cyanColor];
        case 5:
            return [UIColor yellowColor];
        case 6:
            return [UIColor orangeColor];
        default:
            return [UIColor blackColor];
            break;
    }
}

- (NSArray*)currentPageDates:(NSDate*)curDate{
    NSMutableArray *dates = [NSMutableArray array];
    
    NSCalendar *_calendar = [NSCalendar currentCalendar];
    
    NSInteger curWeekDay = [_calendar component:NSCalendarUnitWeekday fromDate:curDate];
    for (int i = 1; i < 8; i++) {
        NSInteger interval = i - curWeekDay;
        
        NSDate *date = [curDate dateByAddingTimeInterval:interval*24*60*60];
        [dates addObject:date];
    }
    
    return dates;
}


#pragma mark -- ECUIViewDelegate
- (void)ecEventDidSelected:(id<ECEventDelegate>)event{
    NSLog(@"%s startDate:%@, endDate:%@", __FUNCTION__,
          [NSDate dateWithTimeIntervalSince1970:event.startDate],
          [NSDate dateWithTimeIntervalSince1970:event.endDate]);
}

#pragma mark -- ECUIViewDataSource

- (NSInteger)numbersOfEvent:(NSDate *)date{
    
    NSArray *events = datas[[_formatter stringFromDate:date]];
    
    return events.count;
}

- (id<ECEventDelegate>)eventForItemAtIndex:(NSInteger)index date:(NSDate *)date{
    Event *evet = datas[[_formatter stringFromDate:date]][index];
    return evet;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
