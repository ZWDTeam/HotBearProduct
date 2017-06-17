//
//  HBPublishTypeFlowLayout.m
//  HotBear
//
//  Created by Cody on 2017/6/15.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBPublishTypeFlowLayout.h"

@implementation HBPublishTypeFlowLayout



- (void)prepareLayout{
    
    [super prepareLayout];
    
    UIScreen * screen = [UIScreen mainScreen];
    
    //比例
    //    CGFloat ratio = screen.bounds.size.height/screen.bounds.size.width;
    
    self.minimumLineSpacing = 2;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 20, 0, 20);
    
    //间隙
    CGFloat space =20.0f;
    
    //item 宽
    CGFloat itemWidth = (screen.bounds.size.width- self.sectionInset.left - self.sectionInset.right -space)/2;
    
    self.itemSize = CGSizeMake(itemWidth, itemWidth+20);
    

    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
}

@end
