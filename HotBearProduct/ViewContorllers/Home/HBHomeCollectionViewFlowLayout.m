//
//  HBHomeCollectionViewFlowLayout.m
//  HotBear
//
//  Created by APPLE on 2017/3/22.
//  Copyright © 2017年 网星传媒. All rights reserved.
//

#import "HBHomeCollectionViewFlowLayout.h"

@implementation HBHomeCollectionViewFlowLayout


- (id)init{
    self =[super init];
    
    if (self) {

    }
    return self;
}

- (void)prepareLayout{

    [super prepareLayout];
    
    UIScreen * screen = [UIScreen mainScreen];
    
    //比例
//    CGFloat ratio = screen.bounds.size.height/screen.bounds.size.width;
    
    //间隙
    CGFloat space =2.0f;
    
    //item 宽
    CGFloat itemWidth = (screen.bounds.size.width-space)/2;
    
    self.itemSize = CGSizeMake(itemWidth, itemWidth+41);
    
    self.minimumLineSpacing = 2;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    
    self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 49, 0);
    
}
@end
