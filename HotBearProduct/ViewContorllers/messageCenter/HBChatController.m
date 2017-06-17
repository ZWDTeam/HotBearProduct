//
//  HBChatController.m
//  HotBear
//
//  Created by Cody on 2017/6/5.
//  Copyright © 2017年 zhongweidi. All rights reserved.
//

#import "HBChatController.h"
#import "HBChatMessageModel.h"
#import "DGChatTableViewCell.h"
#import "HBMessageSendView.h"
#import "HBChatUserDetailViewController.h"
#import "HBUserDetailViewController.h"

@interface HBChatController ()<UITableViewDelegate,UITableViewDataSource,HBMessageSendViewDelegate,DGChatTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *returnBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

@property (strong , nonatomic)UIActivityIndicatorView * activityIndicator;

@property (strong , nonatomic)NSMutableArray <HBChatMessageModel *>*messages;

@property (strong , nonatomic)HBMessageSendView * sendView;

@property (assign , nonatomic)BOOL isLoadingMoreMsgs;

@property (assign , nonatomic)BOOL noMore;

@property (assign , nonatomic)NSInteger currentPage;

@end

@implementation HBChatController



- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.messages = @[].mutableCopy;
        _currentPage = 1;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];


    [self updateMsgWithPage:_currentPage];
    
    [self initUI];
}

- (void)updateMsgWithPage:(NSInteger )page{
    
    MBProgressHUD * hud;
    if (page == 1) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.label.font = [UIFont systemFontOfSize:14];
        hud.label.text = @"正在获取记录...";
        hud.mode = MBProgressHUDModeIndeterminate;
    }

    
    [SSHTTPSRequest fetchRecordUserID:[HBAccountInfo currentAccount].userID toUserID:self.msgLastModel.user.userID page:@(page) pageSize:@(10) withSuccesd:^(id respondsObject) {
        
        NSError *error;
        HBChatMessageArrayModel * model = [[HBChatMessageArrayModel alloc] initWithDictionary:respondsObject error:&error];
        if (model.code == 200) {
            
            NSArray * msgs = [self upsideDownArrayItem:model.PrivateMessages.mutableCopy];
            
            NSIndexSet * indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, msgs.count)];
            [self.messages insertObjects:msgs atIndexes:indexSet];
            
            [self.tableView reloadData];
            
            if (self.messages.count >0 && page == 1) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:msgs.count-1 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionBottom];
            }
            
            NSInteger maxIndex = msgs.count -1;
            
            
            if (page > 1 && maxIndex >= 0) {
                [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:maxIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
            }
            

        }
        
        [hud hideAnimated:YES];
        
        
 
        
        [self.activityIndicator stopAnimating];
        self.isLoadingMoreMsgs = NO;
        
        if (model.PrivateMessages.count < 10) {
            _noMore = YES;
        }
        
    } withFail:^(NSError *error) {
        [hud hideAnimated:YES];
        [self.activityIndicator stopAnimating];
        self.isLoadingMoreMsgs = NO;

    }];

}


#pragma mark - 数组首尾数据向交换依次类推
- (NSMutableArray * )upsideDownArrayItem:(NSMutableArray *)array{
    if (array.count <= 1) {
        return array;
    }
    
    for (NSInteger i = 0; i<array.count/2; i++) {
           [array exchangeObjectAtIndex:i withObjectAtIndex:array.count-1-i];
    }
    
    return array;
}

- (void)initUI{
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.activityIndicator.color = [UIColor blackColor];
    self.activityIndicator.center = CGPointMake(self.view.frame.size.width/2.0f, 30/2.0f);
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    [view addSubview:self.activityIndicator];
    self.tableView.tableHeaderView = view;
    self.tableView.separatorStyle = 0;
    
    self.titleLabel.text = self.msgLastModel.user.nickname;
    
    //添加消息发送视图
    _sendView = [[NSBundle mainBundle] loadNibNamed:@"HBMessageSendView" owner:self options:nil].lastObject;
    _sendView.frame = CGRectMake(0, self.view.bounds.size.height, self.view.bounds.size.width, _sendView.bounds.size.height);
    _sendView.tintColor = [UIColor grayColor];
    _sendView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    _sendView.delegate = self;
    _sendView.sendTextView.keyboardAppearance = UIKeyboardAppearanceDefault;
    [self.view addSubview:_sendView];
    
    UIImage * image = [self.returnBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.returnBtn.tintColor = self.navigationController.navigationBar.tintColor;
    [self.returnBtn setImage:image forState:UIControlStateNormal];
    
    UIImage * moreImage = [self.moreBtn.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.moreBtn.tintColor = self.navigationController.navigationBar.tintColor;
    [self.moreBtn setImage:moreImage forState:UIControlStateNormal];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - action
- (IBAction)returnAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sendViewAction:(id)sender {
    [self.sendView.sendTextView becomeFirstResponder];
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messages.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * identifier = @"MyCell";
    DGChatTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        cell = [[DGChatTableViewCell alloc] initWithDelegate:self reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    HBChatMessageModel * model = self.messages[indexPath.row];
    cell.message = model;
    NSURL * userUrl = [[SSHTTPUploadManager shareManager] imageURL:model.fromUser.smallImageObjectKey];
    [cell.headerImageView sd_setImageWithURL:userUrl placeholderImage:[UIImage imageNamed:@"默认头像"]];
    
    cell.headerImageView.hidden = model.type== DGMessageTypeDate ? YES:NO ;
    return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HBChatMessageModel * message = self.messages[indexPath.row];
    CGFloat  height = [DGChatTableViewCell heightForRowAtIndexPath:indexPath withMessageModel:message];
    return height;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //拉到顶部加载历史数据
    if (scrollView.contentOffset.y <=0 && !self.isLoadingMoreMsgs &&!_noMore && scrollView.contentSize.height>scrollView.frame.size.height) {
        self.isLoadingMoreMsgs = YES;
        [self.activityIndicator startAnimating];
        _currentPage ++;
        [self updateMsgWithPage:_currentPage];

    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [_sendView hiddenKeyboard];
}

#pragma mark - DGChatTableViewCellDelegate 消息发送失败 - 重新发生消息
- (void)dgTableView:(UITableView *)tableView selectFailWithIndexPath:(NSIndexPath *)indexPath{
    HBChatMessageModel * model = self.messages[indexPath.row];
    model.sendStatus = DGMessageSendStatusSending;
    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    [SSHTTPSRequest sendPrivacyMsgWithUserID:[HBAccountInfo currentAccount].userID toUserID:self.msgLastModel.user.userID content:model.content messageType:model.type withSuccesd:^(id respondsObject) {
        
        model.sendStatus = DGMessageSendStatusNone;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    } withFail:^(NSError *error) {
        model.sendStatus = DGMessageSendStatusFail;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
}

#pragma mark - HBMessageSendViewDelegate 发生消息
- (void)deSelectSendAction:(HBMessageSendView *)messageView withContent:(NSString *)content{
    
    
    HBChatMessageModel * model = [HBChatMessageModel new];
    model.content = content;
    model.fromUser = [HBAccountInfo currentAccount];
    model.type = DGMessageTypeText;
    model.time = @([[NSDate date] timeIntervalSince1970]);
    model.sendStatus = DGMessageSendStatusSending;
    [self.messages addObject:model];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:self.messages.count-1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionBottom];
    
    [SSHTTPSRequest sendPrivacyMsgWithUserID:[HBAccountInfo currentAccount].userID toUserID:self.msgLastModel.user.userID content:content messageType:DGMessageTypeText withSuccesd:^(id respondsObject) {
        
        model.sendStatus = DGMessageSendStatusNone;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    } withFail:^(NSError *error) {
        model.sendStatus = DGMessageSendStatusFail;
        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }];
    
    messageView.sendTextView.text = @"";
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"chatShowUserDetail"]){
        HBUserDetailViewController * vc = segue.destinationViewController;
        vc.userInfo = self.msgLastModel.user;
    }
}


@end
