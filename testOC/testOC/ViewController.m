//
//  ViewController.m
//  testOC
//
//  Created by csh on 16/7/4.
//  Copyright © 2016年 csh. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getWeekTime];
    
    // Do any additional setup after loading the view, typically from a nib.
}



- (void)test {

    NSInteger year,month,day,hour,min,sec,week;
    
    NSString *weekStr=nil;
    
    
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDate *now = [NSDate date];;
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    
    
    comps = [calendar components:unitFlags fromDate:now];
    
    year = [comps year];
    
    week = [comps weekday];
    
    month = [comps month];
    
    day = [comps day];
    
    hour = [comps hour];
    
    min = [comps minute];
    
    sec = [comps second];
    
    
    
    if(week==1)
        
    {
        
        weekStr=@"星期天";
        
    }else if(week==2){
        
        weekStr=@"星期一";
        
        
        
    }else if(week==3){
        
        weekStr=@"星期二";
        
        
        
    }else if(week==4){
        
        weekStr=@"星期三";
        
        
        
    }else if(week==5){
        
        weekStr=@"星期四";
        
        
        
    }else if(week==6){
        
        weekStr=@"星期五";
        
        
        
    }else if(week==7){
        
        weekStr=@"星期六";
        
        
        
    }
    
    else {
        
        NSLog(@"error!");
        
    }
    
    
    
    NSLog(@"现在是:%ld年%ld月%ld日 %ld时%ld分%ld秒  %@",(long)year,(long)month,(long)day,(long)hour,(long)min,(long)sec,weekStr);
    
    
    
    NSInteger Monday = day - week+1+1;   //21 - 4 + 1 + 1
    
    for (int i=1; i<=7; i++) {
        
        
        
        NSLog(@"本周 星期%d :%ld年%ld月%ld日 ",i,(long)year,(long)month,(long)Monday);
        
        Monday=Monday+1;
        
    }

}

- (void)test2{

    NSDate *now = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit|NSWeekdayCalendarUnit|NSDayCalendarUnit
                                         fromDate:now];
    
    // 得到星期几
    // 1(星期天) 2(星期二) 3(星期三) 4(星期四) 5(星期五) 6(星期六) 7(星期天)
    NSInteger weekDay = [comp weekday];
    // 得到几号
    NSInteger day = [comp day];
    
    NSLog(@"weekDay:%ld   day:%ld",weekDay,day);
    
    // 计算当前日期和这周的星期一和星期天差的天数
    long firstDiff,lastDiff;
    if (weekDay == 1) {
        firstDiff = 1;
        lastDiff = 0;
    }else{
        firstDiff = [calendar firstWeekday] - weekDay;
        lastDiff = 9 - weekDay;
    }
    
    NSLog(@"firstDiff:%ld   lastDiff:%ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉了时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek= [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:now];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek= [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formater = [[NSDateFormatter alloc] init];
    [formater setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSLog(@"星期一开始 %@",[formater stringFromDate:firstDayOfWeek]);
    NSLog(@"当前 %@",[formater stringFromDate:now]);
    NSLog(@"星期天结束 %@",[formater stringFromDate:lastDayOfWeek]);
}

// 获取当前周的周一和周日的时间
- (NSString *)getWeekTime
{
    NSDate *nowDate = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSDayCalendarUnit fromDate:nowDate];
    // 获取今天是周几
    NSInteger weekDay = [comp weekday];
    // 获取几天是几号
    NSInteger day = [comp day];
    NSLog(@"%ld----%ld",(long)weekDay,(long)day);
    
    // 计算当前日期和本周的星期一和星期天相差天数
    long firstDiff,lastDiff;
    //    weekDay = 1;
    if (weekDay == 1)
    {
        firstDiff = -6;
        lastDiff = 0;
    }
    else
    {
        firstDiff = [calendar firstWeekday] - weekDay + 1;
        lastDiff = 8 - weekDay;
    }
    NSLog(@"firstDiff: %ld   lastDiff: %ld",firstDiff,lastDiff);
    
    // 在当前日期(去掉时分秒)基础上加上差的天数
    NSDateComponents *firstDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit  fromDate:nowDate];
    [firstDayComp setDay:day + firstDiff];
    NSDate *firstDayOfWeek = [calendar dateFromComponents:firstDayComp];
    
    NSDateComponents *lastDayComp = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit   fromDate:nowDate];
    [lastDayComp setDay:day + lastDiff];
    NSDate *lastDayOfWeek = [calendar dateFromComponents:lastDayComp];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM月dd日"];
    NSString *firstDay = [formatter stringFromDate:firstDayOfWeek];
    NSString *lastDay = [formatter stringFromDate:lastDayOfWeek];
    NSLog(@"%@=======%@",firstDay,lastDay);
    
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@",firstDay,lastDay];
    
    return dateStr;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
