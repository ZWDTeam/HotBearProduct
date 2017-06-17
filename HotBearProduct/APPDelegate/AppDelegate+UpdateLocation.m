//
//  AppDelegate+UpdateLocation.m
//  HotBear
//
//  Created by Cody on 2017/6/7.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "AppDelegate+UpdateLocation.h"

#import <objc/runtime.h>

NSString * const HBlocationMangerKey;

@implementation AppDelegate (UpdateLocation)

- (void)updateLocationInfo{
    
    
    
    if ( ![CLLocationManager locationServicesEnabled]  //APP 不能拒绝了位置访问
        || [CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied)//位置服务是在设置中禁用
        
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"打开定位开关" message:@"请在设置中打开定位服务" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"设置", nil];
        [alertView show];
        
        self.locationOn = NO;
    }else{
        [self.locationManger startUpdatingLocation];
        
        self.locationOn = YES;
    }

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
    }
}
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    NSLog(@"%@",locations);
    CLGeocoder *myGeocoder = [[CLGeocoder alloc] init];
    
    [myGeocoder reverseGeocodeLocation:locations.lastObject completionHandler:^(NSArray *placemarks, NSError *error)
     {
         
             if(error == nil && [placemarks count]>0)
             {
                 CLPlacemark *placemark = [placemarks objectAtIndex:0];
                 self.currentPlacemark = placemark;
                
                 NSLog(@"name = %@",placemark.name);
                 NSLog(@"locality = %@", placemark.locality);
                 
             }
             else if(error==nil && [placemarks count]==0){
                 NSLog(@"No results were returned.");
             }
             else if(error != nil) {
                 NSLog(@"An error occurred = %@", error);
             }
         
         [[NSNotificationCenter defaultCenter] postNotificationName:HBLocationUpdateNotificationKey object:error];
         
     }];

}

@end
