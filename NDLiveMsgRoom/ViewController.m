//
//  ViewController.m
//  NDLiveMsgRoom
//
//  Created by ljq on 2019/3/22.
//  Copyright © 2019年 ljq. All rights reserved.
//

#import "ViewController.h"
#import "NDMsgModel.h"
#import "NDUserModel.h"
#import "NDGiftModel.h"
#import "NDMsgListTableView.h"
#import "WHDebugToolManager.h"

// 每一秒发送多少条消息
#define MAXCOUNT  40

@interface ViewController ()<UITextFieldDelegate, RoomMsgListDelegate>
{
    NSArray<NSString *> *_conmentAry;
    NSArray<NSString *> *_nameAry;
}
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (nonatomic) dispatch_source_t timer;
@property (nonatomic, strong) NDMsgListTableView *msgTableView;
@end



@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //self.view.backgroundColor = RGBAOF(0xffa321, 0.3);
    
    // DebugToolTypeMemory | DebugToolTypeCPU | DebugToolTypeFPS
    [[WHDebugToolManager sharedInstance] toggleWith:DebugToolTypeAll];
    
    _conmentAry = @[@"继承🔥之意志，成为海贼王的男人☠️☠️☠️💋❤️💘💇~~~",
                    @"欢迎进入直播间，喜欢就点击加关注！🎤🎤🎤🎤",
                    @"海贼王哥尔·D·罗杰⛵️在临死前曾留下了关于其毕生的财富“One Piece”的消息😻✊❤️🙇",
                    @"《海贼王剧场版》⛵️是根据漫画家尾田荣一郎创作的漫画《航海王》☠️改编的系列动画电影，影片讲述的是主人公“蒙奇·D·路飞”所带领的海贼团的故事。"];
    
    _nameAry = @[@"罗罗诺亚・索隆", @"蒙奇·D·路飞", @"特拉法尔加·罗", @"波特卡斯·D·艾斯"];
    
    self.textField.delegate = self;
    
    [self.view addSubview:self.msgTableView];
    self.msgTableView.frame = CGRectMake(8, 100, MsgTableViewWidth, MsgTableViewHeight);
    //self.msgTableView.backgroundColor = [UIColor whiteColor];
    
    
    [self creatTestIMMsg:NDSubMsgType_Announcement];
}

- (IBAction)clear:(id)sender {
    [self.msgTableView reset];
    
    if (self.msgTableView.reloadType == NDReloadLiveMsgRoom_Time) {
        [self.msgTableView startTimer];
    }
}

// 开始模拟发送消息
- (IBAction)start:(id)sender {
    if (_timer == nil) {
        EWWeakSelf
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC/MAXCOUNT, 0);
        dispatch_source_set_event_handler(_timer, ^{
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf creatTestIMMsg:arc4random() % 7];
            });
        });
        dispatch_resume(_timer);
    }
}

// 停止发送消息
- (IBAction)stop:(id)sender {
    if (_timer) {
        dispatch_source_cancel(_timer);
        _timer = nil;
    }
}


// 随机生成不同类型消息
- (void)creatTestIMMsg:(NDSubMsgType)subType {
    NDMsgModel *msgModel = [NDMsgModel new];
    if (subType == 0) {
        msgModel.subType = arc4random() % 7;
    } else {
        msgModel.subType = subType;
    }
    msgModel.msgID = [NSString stringWithFormat:@"msgID_%u", arc4random() % 10000];
    
    NDUserModel *user = [NDUserModel new];
    user.nickName = _nameAry[arc4random() % _nameAry.count];
    user.userID = [NSString stringWithFormat:@"userID_%ld", msgModel.subType];
    user.level = arc4random() % 100;
    user.gender = arc4random() % 1;
    
    msgModel.user = user;
    
    switch (msgModel.subType) {
        case NDSubMsgType_Unknown:
            return;
            break;
        case NDSubMsgType_Share:
        {
            
        }
            break;
        case NDSubMsgType_Comment:
        {
            msgModel.content = _conmentAry[arc4random() % _conmentAry.count];
        }
            break;
        case NDSubMsgType_At:
        {
            msgModel.atUser = [NDUserModel new];
            msgModel.atUser.nickName = @"这是一个被@的用户";
            msgModel.atUser.userID = @"10086";
            msgModel.atUser.gender = arc4random() % 1;
            msgModel.atUser.level = arc4random() % 100;
            
            msgModel.content = _conmentAry[arc4random() % _conmentAry.count];
        }
            break;
        case NDSubMsgType_MemberEnter:
            
            break;
        case NDSubMsgType_Announcement:
            msgModel.content = @"系统消息：继承🔥之意志的海贼王☠️⛵️";
            break;
        case NDSubMsgType_Gift_Text:
        {
            msgModel.quantity = @"1";
            msgModel.giftModel = [NDGiftModel new];
            msgModel.giftModel.giftID = [NSString stringWithFormat:@"giftID_%u", arc4random() % 10];
            msgModel.giftModel.thumbnailUrl = @"https://showme-livecdn.9yiwums.com/gift/gift/20190225/b9a2dc3f1bef436598dfa470eada6a60.png";
            msgModel.giftModel.name = @"烟花🎆";
        }
            break;
            
        default:
            break;
    }
    // 生成富文本模型
    [msgModel initMsgAttribute];
    
    
    [self.msgTableView addNewMsg:msgModel];
}


// 点击return手动发送文本类型消息
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [self creatTestIMMsg:NDSubMsgType_Comment];
    
    return YES;
}

- (NDMsgListTableView *)msgTableView {
    if(!_msgTableView){
        _msgTableView = [[NDMsgListTableView alloc] init];
        _msgTableView.delegate = self;
        _msgTableView.reloadType = NDReloadLiveMsgRoom_Time;
    }
    return _msgTableView;
}



@end
