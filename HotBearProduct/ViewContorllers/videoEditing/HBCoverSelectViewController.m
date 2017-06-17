//
//  HBCoverSelectViewController.m
//  HotBear
//
//  Created by Cody on 2017/4/1.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBCoverSelectViewController.h"
#import "HBVideoEditingViewController.h"
#import "HBVideoManager.h"

#define ITEM_SIZE_WIDTH 54

@interface HBCoverSelectViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong , nonatomic)NSArray * videoImages;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UICollectionView *collcectionView;
@property (strong , nonatomic)AVAssetImageGenerator * assetImageGenerator;


@end

@implementation HBCoverSelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [HBVideoManager fecthImagesForVideoURL:self.editingViewController.videoURL Finish:^(NSArray<UIImage *> *images) {
        
        self.videoImages = images;
        [self.collcectionView reloadData];
        self.collcectionView.contentOffset = CGPointMake(ITEM_SIZE_WIDTH, 0);
    }];
    
    self.selectedImageView.image = [HBVideoManager getThumbailImageRequestAtTimeSecond:1.0 withURL:_editingViewController.videoURL];
    
}

- (void)setEditingViewController:(HBVideoEditingViewController *)editingViewController{
    _editingViewController = editingViewController;
    
    //创建媒体信息对象AVURLAsset
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:_editingViewController.videoURL];
    //创建视频缩略图生成器对象AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    self.assetImageGenerator = imageGenerator;
}


- (IBAction)doneAction:(id)sender {
    self.editingViewController.tableViewHeaderView.centerImageView.image = self.selectedImageView.image;
    self.editingViewController.tableViewHeaderView.backImageView.image   = self.selectedImageView.image;
    [self.navigationController popViewControllerAnimated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return  self.videoImages.count+1;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    static NSString * identifier = @"ImageCell";
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    UIImageView * imageView = [cell viewWithTag:100];
    
    
    if (indexPath.row == 0) {
        imageView.image = [UIImage imageNamed:@"添加"];

    }else{
        imageView.image = self.videoImages[indexPath.row-1];
    }
    
    
    return cell;
    
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        UIImagePickerController * picker = [[UIImagePickerController alloc]init];
        picker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
        picker.delegate=self;
        [self presentViewController:picker animated:YES completion:^{
            
        }];
        
        
        return;
    }
    
    UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    UIImageView * imageView = [cell viewWithTag:100];
    self.selectedImageView.image = imageView.image;
    
    
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x < ITEM_SIZE_WIDTH) {
        scrollView.contentOffset = CGPointMake(ITEM_SIZE_WIDTH, 0);
        return;
    }
    
    float maxSize = scrollView.contentSize.width - ITEM_SIZE_WIDTH;
    float current = scrollView.contentOffset.x - ITEM_SIZE_WIDTH;
    
    float scale = current/(maxSize-scrollView.bounds.size.width);
    
    if (scale>0 && scale <1) {
        AVAsset * asset = self.assetImageGenerator.asset;
        float duration = CMTimeGetSeconds(asset.duration);
        
        
        CMTime outTime  = CMTimeMake(duration*scale*10, 10);//10表示每一秒的帧率
        
        self.selectedImageView.image = [HBVideoManager getThumbailImageRequestAtTime:outTime withAssetImageGenerator:self.assetImageGenerator];
        
    }
    

}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    UIImage * image = info[UIImagePickerControllerOriginalImage];
    self.selectedImageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
