//
//  ECUIView.m
//  EventCalendar
//
//  Created by maqj on 15/9/10.
//  Copyright (c) 2015年 msxt. All rights reserved.
//

#import "ECUIView.h"
#import "ECFlowLayout.h"
#import "UIButtonAdd.h"
#import "ECCollectionViewCell.h"

#define VIEW_W (self.frame.size.width)
#define VIEW_H (self.frame.size.height)
#define TAG_TIME_LABEL (0X1010)
#define TAG_ALL_DAY (0X1011)

#define ALL_DAY_SEC (24*60*60)

@interface EventEntity : NSObject

@property (nonatomic, retain) id<ECEventDelegate> event;
@property (nonatomic, assign) int order;
@property (nonatomic, assign) int minW;
@end

@implementation EventEntity

@end

@interface ECUIView ()<JTCalendarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, retain) UIButtonAdd *addEventButton;
@end

NSString *const kECCollectionViewCellIdentifier = @"kECCollectionViewCellIdentifier";

@interface ECUIView ()
@property (nonatomic, retain) JTHorizontalCalendarView *cldContentView;
@property (nonatomic, retain) JTCalendarMenuView *cldMenuView;
@property (nonatomic, strong) JTCalendarManager *cldManager;
@property (nonatomic, retain) UILabel *cldWeekView;
@property (nonatomic, retain) UICollectionView *collectionView;
@property (nonatomic, retain) UIView *allDayView;
@property (nonatomic, strong) NSMutableArray *eventButtons;
@property (nonatomic, strong) NSMutableDictionary *events;
@end

@implementation ECUIView
{
    NSDate *_todayDate;
    NSDate *_dateSelected;
    NSCalendar *_calendar;
    
    int _alldayCts[7];
    
    CGFloat _cellW;
    CGFloat _cellH;
    
    CGFloat _collectionH;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initComponents];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponents];
    }
    
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self initComponents];
    }
    
    return self;
}

- (void)initComponents{
    memset(&_alldayCts, 0, sizeof(int)*7);
    
    _todayDate = [NSDate date];
    _calendar = [NSCalendar currentCalendar];

    _cldWeekView = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 31.0f, 40.0f, 20.0f)];
    _cldWeekView.textAlignment = NSTextAlignmentCenter;
    _cldWeekView.font = [UIFont systemFontOfSize:12.0f];
    
    _cldContentView = [[JTHorizontalCalendarView alloc] initWithFrame:CGRectMake(40.0f, 0.0f, VIEW_W-40.0F, 55.0f)];
    
    _cldMenuView = [[JTCalendarMenuView alloc] initWithFrame:CGRectMake(40.0f, 0.0f, VIEW_W-40.0f, 40.0f)];
    
    _cldManager = [JTCalendarManager new];
    _cldManager.delegate = self;
    _cldManager.settings.weekModeEnabled = YES;
    
    [_cldManager setContentView:_cldContentView];
    [_cldManager setMenuView:_cldMenuView];
    [_cldManager setDate:_todayDate];
    
    [self addSubview:_cldWeekView];
    [self addSubview:_cldContentView];
//    [self addSubview:_cldMenuView];
    
    [self initCollectionView];
    
//    [self initAlldayView];
}

//- (void)initAlldayView{
//    _allDayView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, SCREEN_W, 40.0f)];
//    
//}

- (void)layoutSubviews{
    _collectionH = _collectionView.contentSize.height;
    
    if(_collectionH > 0.f){
        [self reloadData];
    }
}

- (void)initCollectionView{
    
    _cellW = VIEW_W/8.f-0.24;
    _cellH = VIEW_W/8.f * 2/3;
    
    UICollectionViewFlowLayout *flowLayout = [[ECFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0.0f;
    flowLayout.minimumLineSpacing = 0.0f;
    flowLayout.itemSize = CGSizeMake(_cellW, _cellH);
//    flowLayout.estimatedItemSize = CGSizeMake(VIEW_W/8-1, VIEW_W/8-1);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//    flowLayout.
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0.0f, 60.0f, VIEW_W, VIEW_H-60.0f) collectionViewLayout:flowLayout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    [_collectionView registerClass:[ECCollectionViewCell class] forCellWithReuseIdentifier:kECCollectionViewCellIdentifier];
    
//    [_collectionView reloadData];
    
    [self addSubview:_collectionView];
}

#pragma mark == UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row % 8 == 0) {
        return;
    }
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    if (_addEventButton == nil) {
        _addEventButton = [UIButtonAdd buttonWithType:UIButtonTypeSystem];
        _addEventButton.backgroundColor = [UIColor colorWithRed:53.0/255 green:157.0f/255 blue:209.0f/255 alpha:1.0f];
//        _addEventButton.frame = CGRectMake(0.0f, 0.0f, cell.frame.size.width, cell.frame.size.height);
        [_addEventButton addTarget:self action:@selector(handleAddEvent:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        [_addEventButton removeFromSuperview];
    }
    
    _addEventButton.frame = cell.frame;
    
    [collectionView addSubview:_addEventButton];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_addEventButton != nil) {
        [_addEventButton removeFromSuperview];
    }
}

- (void)handleAddEvent:(id)sender{
    [_addEventButton removeFromSuperview];
    
    NSLog(@"%s handle add event.", __FUNCTION__);
}

#pragma mark -- UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 24*8;
}

- (UILabel*)createTimeLabel:(NSInteger)tag frame:(CGRect)frame{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.font = [UIFont systemFontOfSize:12.0f];
    label.textAlignment = NSTextAlignmentCenter;
    //            label.backgroundColor = [UIColor lightGrayColor];
    label.textColor = [UIColor lightGrayColor];
    label.tag = tag;
    return label;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ECCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kECCollectionViewCellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    
    NSInteger row = indexPath.row;
    
    UILabel *label = (UILabel*)[cell viewWithTag:TAG_TIME_LABEL];
    UILabel *lastLabel = (UILabel*)[cell viewWithTag:TAG_TIME_LABEL + 1];
    
    if (row % 16 == 0) {
        if (label == nil) {
            label = [self createTimeLabel:TAG_TIME_LABEL frame:CGRectMake(0.0f, 0.0f, cell.frame.size.width, 10.0f)];
            [cell addSubview:label];
        }
        label.text = [NSString stringWithFormat:@"%2.2d:00", (int)(row/16*2)];
        label.layer.hidden = NO;
    }else{
        if (label != nil) {
            label.layer.hidden = YES;
        }
    }
    
    if (row % 8 == 0) {
        cell.isBgBorderShow = NO;
        
        if (row / 8 == 23) {
            if (lastLabel == nil ) {
                lastLabel = [self createTimeLabel:TAG_TIME_LABEL + 1 frame:CGRectMake(0.0f, cell.frame.size.height-10, cell.frame.size.width, 10.0f)];
                [cell addSubview:lastLabel];
            }
            lastLabel.text = @"24:00";
            lastLabel.layer.hidden = NO;
        }
        
    }else{
        cell.isBgBorderShow = YES;
        
        if (lastLabel != nil) {
            lastLabel.layer.hidden = YES;
        }
    }
    
    [cell setNeedsDisplay];
    
    return cell;
}

- (UIColor*)dotColorWithDate:(NSDate*)date{
    if (_eventButtons == nil || _eventButtons.count == 0) {
        return nil;
    }
    
    if (_eventButtons.count > 0 && _eventButtons.count <= 3) {
        return [UIColor greenColor];
    }else if (_eventButtons.count > 3 && _eventButtons.count <= 8){
        return [UIColor orangeColor];
    }else{
        return [UIColor redColor];
    }
}

#pragma mark - CalendarManager delegate

// Exemple of implementation of prepareDayView method
// Used to customize the appearance of dayView
- (void)calendar:(JTCalendarManager *)calendar prepareDayView:(JTCalendarDayView *)dayView
{
    // Today
    if([_cldManager.dateHelper date:[NSDate date] isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor blueColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Selected date
    else if(_dateSelected && [_cldManager.dateHelper date:_dateSelected isTheSameDayThan:dayView.date]){
        dayView.circleView.hidden = NO;
        dayView.circleView.backgroundColor = [UIColor redColor];
        dayView.dotView.backgroundColor = [UIColor whiteColor];
        dayView.textLabel.textColor = [UIColor whiteColor];
    }
    // Other month
    else if(![_cldManager.dateHelper date:_cldContentView.date isTheSameMonthThan:dayView.date]){
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor lightGrayColor];
    }
    // Another day of the current month
    else{
        dayView.circleView.hidden = YES;
        dayView.dotView.backgroundColor = [UIColor redColor];
        dayView.textLabel.textColor = [UIColor blackColor];
    }
    
    dayView.dotView.layer.hidden = NO;
    dayView.dotView.backgroundColor = [self dotColorWithDate:dayView.date];
    
    _cldWeekView.text = [NSString stringWithFormat:@"%d周", (int)[_calendar component:NSCalendarUnitWeekOfYear fromDate:_cldContentView.date]];
}

- (void)calendar:(JTCalendarManager *)calendar didTouchDayView:(JTCalendarDayView *)dayView
{
    _dateSelected = dayView.date;
    
    // Animation for the circleView
    dayView.circleView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.1, 0.1);
    [UIView transitionWithView:dayView
                      duration:.3
                       options:0
                    animations:^{
                        dayView.circleView.transform = CGAffineTransformIdentity;
                        [_cldManager reload];
                    } completion:nil];
    
    
    // Load the previous or next page if touch a day from another month
    
    if(![_cldManager.dateHelper date:_cldContentView.date isTheSameMonthThan:dayView.date]){
        if([_cldContentView.date compare:dayView.date] == NSOrderedAscending){
            [_cldContentView loadNextPageWithAnimation];
        }
        else{
            [_cldContentView loadPreviousPageWithAnimation];
        }
    }
}

#pragma mark - CalendarManager delegate - Page mangement

// Used to limit the date for the calendar, optional
//- (BOOL)calendar:(JTCalendarManager *)calendar canDisplayPageWithDate:(NSDate *)date
//{
//    return [_cldManager.dateHelper date:date isEqualOrAfter:_minDate andEqualOrBefore:_maxDate];
//}

- (void)calendarDidLoadNextPage:(JTCalendarManager *)calendar
{
    NSLog(@"Next page loaded");
    
    [self reloadData];
    
    if ([_delegate respondsToSelector:@selector(calendarDidLoadNextPage:)]) {
        [_delegate performSelector:@selector(calendarDidLoadNextPage:) withObject:calendar];
    }
}

- (void)calendarDidLoadPreviousPage:(JTCalendarManager *)calendar
{
    NSLog(@"Previous page loaded");
 
    [self reloadData];
    
    if ([_delegate respondsToSelector:@selector(calendarDidLoadPreviousPage:)]) {
        [_delegate performSelector:@selector(calendarDidLoadPreviousPage:) withObject:calendar];
    }
}

- (NSArray*)currentPageDates{
    NSMutableArray *dates = [NSMutableArray array];
    
    NSDate *contentDate = _cldContentView.date;
    NSInteger curWeekDay = [_calendar component:NSCalendarUnitWeekday fromDate:contentDate];
    for (int i = 1; i < 8; i++) {
        NSInteger interval = i - curWeekDay;
        
        NSDate *curDate = [contentDate dateByAddingTimeInterval:interval*24*60*60];
        [dates addObject:curDate];
    }
    
    return dates;
}

- (void)addAllday:(id<ECEventDelegate>) entity colume:(int)colume{
    
    _alldayCts[colume-1] +=1;
    
    if (_allDayView == nil) {
        _allDayView = [[UIView alloc] initWithFrame:CGRectMake(0.f, 60.0f, SCREEN_W, 20)];
        _allDayView.backgroundColor = [UIColor whiteColor];
    }
    
    for (int i = 0; i < 8; i++) {
        CGFloat w = SCREEN_W/8;
        UILabel *label = (UILabel*)[_allDayView viewWithTag:TAG_ALL_DAY + i];
        if (label == nil) {
            label = [[UILabel alloc] initWithFrame:CGRectMake(i*w, 0.f, w, 20)];
            label.tag = TAG_ALL_DAY + i;
            label.font = [UIFont systemFontOfSize:12.0f];
            label.textColor = [UIColor lightGrayColor];
            label.textAlignment = NSTextAlignmentCenter;
        }
        if (i == 0) {
            label.text = @"全天";
        }else {
            if (_alldayCts[i-1] > 0) {
                label.text = [NSString stringWithFormat:@"+%d", _alldayCts[i-1]];
            }else{
                label.text = @"";
            }
        }
        
        [_allDayView addSubview:label];
    }

    [self addSubview:_allDayView];

    CGRect collectionFrame = _collectionView.frame;
    collectionFrame.origin.y = 85.0f;
    collectionFrame.size.height = VIEW_H-60.0f-25;

    [self reloadCollectionFrame:collectionFrame];
}

- (BOOL)isAllday:(id<ECEventDelegate>)entity{
    
    NSLog(@"%s %f",__FUNCTION__, (([self getDateHour:entity.endDate] - [self getDateHour:entity.startDate]) - ALL_DAY_SEC + 1));
    
    return (([self getDateHour:entity.endDate] - [self getDateHour:entity.startDate]) - ALL_DAY_SEC + 1) >= 0;
}

- (void)reloadCollectionFrame:(CGRect)frame{
    [UIView animateWithDuration:0.5 animations:^{
        _collectionView.frame = frame;
    }];
}

- (NSArray*)eventFilter:(NSArray*)events colume:(int)colume{
    NSMutableArray *filtered = [NSMutableArray array];
    int i = 0;
    for (; i < events.count; i++) {
        id<ECEventDelegate> eventEntity = [events objectAtIndex:i];

        if (eventEntity.isAllday||
            [self isAllday:eventEntity]) {
            [self addAllday:eventEntity colume:colume];
        }else{
            [filtered addObject:eventEntity];
        }
    }
    
    return filtered;
}

- (void)reloadData{
    
    if (_eventButtons != nil) {
        for(id view in _eventButtons){
            [view removeFromSuperview];
        }
        [_eventButtons removeAllObjects];
        [_events removeAllObjects];
    }else{
        _eventButtons = [NSMutableArray array];
        _events = [NSMutableDictionary dictionary];
    }
    
    if (_allDayView != nil) {
        memset(&_alldayCts, 0, sizeof(int)*7);
        
        [_allDayView removeFromSuperview];
        CGRect collectionFrame = _collectionView.frame;
        collectionFrame.origin.y = 60.0f;
        collectionFrame.size.height = VIEW_H-60.0f;
        [self reloadCollectionFrame:collectionFrame];
    }
    
    if (_addEventButton != nil) {
        [_addEventButton removeFromSuperview];
    }
    
    NSArray *curDates = [self currentPageDates];
    
    for(int col = 0; col < curDates.count; col++){
        
//        NSLog(@"%@ co	l = %d", [NSThread currentThread], col);

        //生成每天的事件视图
        NSInteger evtCt = [_dataSource numbersOfEvent:[curDates objectAtIndex:col]];
        
        NSArray *eventsAll = [self getAllEvents:[curDates objectAtIndex:col] count:evtCt];
        
        NSArray *eventsFiltered = [self eventFilter:eventsAll colume:col+1];
        
        evtCt = eventsFiltered.count;
        
        if (evtCt <= 0) {
            continue;
        }
        
        int colume = col+1;
        
        //1. 根据事件是否有交集，分组
        NSMutableArray *eventGroups = [NSMutableArray array];
        NSMutableArray *group1 = [NSMutableArray array];
        [group1 addObject:[eventsFiltered objectAtIndex:0]];
        [eventGroups addObject:group1];
        
        for (int ei = 1; ei < eventsFiltered.count; ei++) {
            id<ECEventDelegate> curEvent = [eventsFiltered objectAtIndex:ei];
            
            BOOL isCrossed = NO;
            
            for (int gsi = 0; gsi < eventGroups.count; gsi++) {
                NSMutableArray *group = [eventGroups objectAtIndex:gsi];
                
                for (int gi = 0; gi < group.count; gi++) {
                    id<ECEventDelegate> event = [group objectAtIndex:gi];
                    
                    if ([self crossing:curEvent other:event]) {
                        [group addObject:curEvent];
                        gi = (int)group.count;
                        gsi = (int)eventGroups.count;
                        isCrossed = YES;
                    }
                }//end for
            }//end for
            
            if (!isCrossed) {
                NSMutableArray *newGroup = [NSMutableArray array];
                [newGroup addObject:curEvent];
                [eventGroups addObject:newGroup];
            }
        }//end for
        
     
        //2. 生成事件视图
        int eventNum = 0;
        for (int gsi = 0; gsi < eventGroups.count; gsi++) {
            NSMutableArray *group = [eventGroups objectAtIndex:gsi];
            int ct = (int)group.count;
            
            for (int gi = 0; gi < group.count; gi++, eventNum++ ) {
                id<ECEventDelegate> event = [group objectAtIndex:gi];
                CGFloat eventW = (_cellW - (ct+1)*2) / ct;
                UIButton *eventBt = [[UIButton alloc]
                                     initWithFrame:[self rectWith:colume eventIndex:gi eventEntity:event weight:eventW]];
                eventBt.backgroundColor = event.eventColor == nil ? [UIColor redColor]:event.eventColor;
                
                [eventBt addTarget:self action:@selector(handleEvent:) forControlEvents:UIControlEventTouchUpInside];
                NSString *key = [NSString stringWithFormat:@"%d%d", colume, eventNum];
                
                //            NSLog(@"%s %@", __FUNCTION__, key);
                eventBt.tag = [key integerValue];
                
                _events[key] = event;
                
                [_eventButtons addObject:eventBt];

                [_collectionView addSubview:eventBt];
            }
        }
    }
    
    [self setNeedsDisplay];
    
//    for(UIButton *b in _eventButtons){
//        [_collectionView addSubview:b];
//    }
    
}

- (BOOL) crossing:(id<ECEventDelegate>)event1 other:(id<ECEventDelegate>)event2{
    CGFloat curEndT = [self getDateHour:event1.endDate];
    CGFloat curStartT = [self getDateHour:event1.startDate];
    CGFloat startT = [self getDateHour:event2.startDate];
    CGFloat endT = [self getDateHour:event2.endDate];
    
    if ((curStartT > startT && curStartT > endT)||
        (curEndT < startT && curStartT < startT)) {
        // 两个时间段不相交
        return NO;
    }else{
        // 两个时间段相交
        return YES;
    }

}


- (NSArray*)getAllEvents:(NSDate*)date count:(NSInteger)count{
    
    NSMutableArray *arrs = [NSMutableArray array];
    
    for (int i = 0; i < count; i++) {
        id<ECEventDelegate> eventEntity = [_dataSource eventForItemAtIndex:i date:date];
        [arrs addObject:eventEntity];
    }
    
    [arrs sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        id<ECEventDelegate> entity1 = (id<ECEventDelegate>)obj1;
        id<ECEventDelegate> entity2 = (id<ECEventDelegate>)obj2;
        
        CGFloat start1 = [self getDateHour:entity1.startDate];
        CGFloat start2 = [self getDateHour:entity2.startDate];
        if (start2 > start1) {
            return  NSOrderedAscending;
        }else if (start2 < start1){
            return  NSOrderedDescending;
        }else{
            return NSOrderedSame;
        }
    }];
    
    return arrs;
}

//(_cellW - (evtCt+1)*2) / evtCt

- (CGFloat)getEventW:(NSArray*)events entity:(id<ECEventDelegate>)curEvent eventIndex:(int*)preCt{
    
    NSMutableArray *thisEvents = [NSMutableArray arrayWithArray:events];
    
//    [thisEvents removeObject:curEvent];
    
    int ct = 1;
    
//    int preCt = 0;
    
    BOOL isLeft = YES;
    
    CGFloat curEndT = [self getDateHour:curEvent.endDate];
    CGFloat curStartT = [self getDateHour:curEvent.startDate];
    
    for(id<ECEventDelegate> event in thisEvents){
        if (![event isEqual:curEvent]) {
            CGFloat startT = [self getDateHour:event.startDate];
            CGFloat endT = [self getDateHour:event.endDate];
            
            if ((curStartT > startT && curStartT > endT)||
                (curEndT < startT && curStartT < startT)) {
                // 两个时间段不相交
                
            }else{
                // 两个时间段相交
                ct++;
                
                if (isLeft) {
                    *preCt++;
                }
            }
        }else{
            isLeft = NO;
        }
    }
    
    return (_cellW - (ct+1)*2) / ct;
}

- (CGFloat)getDateHour:(long)curMils{
    //get seconds since 1970
    NSTimeInterval interval = (curMils)/1000;
    int daySeconds = 24 * 60 * 60;
    //calculate integer type of days
    NSInteger allDays = interval / daySeconds;
    
    return  interval - (allDays * daySeconds);
    
//    NSDate *dateNoHour = [NSDate dateWithTimeIntervalSince1970:allDays * daySeconds];
//    
//    return [date timeIntervalSinceDate:dateNoHour];
}

- (CGRect) rectWith:(int)colume eventIndex:(int)index eventEntity:(id<ECEventDelegate>)event weight:(CGFloat)w{
    
    CGFloat totalT = ALL_DAY_SEC;
    CGFloat totalH = _collectionView.contentSize.height;
    
    CGFloat startT = [self getDateHour:event.startDate];
    CGFloat endT = [self getDateHour:event.endDate];
    
    CGFloat y = startT * _collectionH/totalT;

    CGFloat h = (endT-startT) * _collectionH/totalT - 2;
    CGFloat x = (float)colume * _cellW + (float)index * w + ((float)index+1)*2;
    CGRect frame = CGRectMake(x, y, w, h);
    
//    NSLog(@"%s x= %f, y = %f, w = %f, h = %f", __FUNCTION__, frame.origin.x , frame.origin.y, frame.size.width, frame.size.height);
    
    return frame;
}

- (void)handleEvent:(id)sender{
    if ([sender isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton*)sender;
        
        if ([_delegate respondsToSelector:@selector(ecEventDidSelected:)]) {
            [_delegate performSelector:@selector(ecEventDidSelected:)
                            withObject:_events[[NSString stringWithFormat:@"%ld", (long)button.tag]]];
        }

    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
