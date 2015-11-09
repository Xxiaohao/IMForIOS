//
//  main.m
//  IMForIOS
//
//  Created by LC on 15/9/11.
//  Copyright (c) 2015年 XH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
//        NSMutableArray *array1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
//        [array1 removeObject:@"4"];
//        XHLog(@" 1array1.count is %ld",array1.count);
//        NSMutableArray *array2 = array1;
//        [array2 removeObjectAtIndex:0];
//        XHLog(@" 2array1.count is %ld and array2.count is %ld",array1.count,array2.count);
//        NSMutableArray *array3 = [[NSMutableArray alloc]initWithArray:array1];
//        [array3 addObject:@"4"];
//        [array3 addObject:@"5"];
//        XHLog(@" 3array3.count is %ld and array1.count is %ld",array3.count,array1.count);
      
        //时间转换的时候将时区设置为utc，这样就不会有8小时的时差
//        NSDateFormatter *format = [[NSDateFormatter alloc]init];
////        NSDate *date = [NSDate date];
//        [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
//        format.dateFormat = @"yyyy-MM-dd HH:mm:ss";
//        NSString *time = @"2015-10-30 17:30:56";
//        
//        NSString *time1 = @"2015-10-30 17:28:56";
//        NSDate *date = [format dateFromString:[time substringToIndex:19]];
//        NSDate *date1 = [format dateFromString:[time1 substringToIndex:19]];
//        CGFloat period = [date timeIntervalSince1970] -[date1 timeIntervalSince1970];
//        XHLog(@"time is %@ ddd is %@ ",time,date);
//        
//        XHLog(@"time is %@ ddd is %@ and period is %f",time1,date1,period);
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
