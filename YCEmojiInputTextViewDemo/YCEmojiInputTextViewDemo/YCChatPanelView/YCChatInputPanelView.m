
#import "YCChatInputPanelView.h"

#define INPUT_HEIGHT   36
#define SCREEN_WIDTH   ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT  ([[UIScreen mainScreen] bounds].size.height)

@implementation YCChatInputPanelView
{
    BOOL _isInitialize;                        //是否已经初始化
    BOOL _isKeyboardShow;                      //是否是键盘弹出
    CGRect _keyboardFrame;                     //记录键盘大小
    
    UIView *_inputBaseView;                    //输入区域底视图
    UIButton *_voiceButton;                    //语音按钮
    UIButton *_emojiButton;                    //表情按钮
    UIButton *_moreButton;                     //更多按钮

    YCChatEmojiPanelView *_chatEmojiPanelView; //表情视图
    YCChatMorePanelView *_chatMorePanelView;   //更多视图
}
#pragma mark- 初始化
- (id)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)initialize
{
    if (_isInitialize) {
        return;
    }else{
        _isInitialize = YES;
    }
    self.backgroundColor = [UIColor clearColor];
    
    //初始化各视图
    [self initView];
    
    //键盘将要显示
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangePosition:) name:UIKeyboardWillShowNotification object:nil];
    
    //键盘将要隐藏
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardChangePosition:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark- 初始化各视图
- (void)initView
{
    //输入区域底视图
    _inputBaseView = [[UIView alloc] init];
    _inputBaseView.backgroundColor = [UIColor darkGrayColor];
    [self addSubview:_inputBaseView];
    
    //语音按钮
    _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_voiceButton setTitle:@"语音" forState:UIControlStateNormal];
    [_voiceButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_emojiButton addTarget:self action:@selector(tapVoiceButton:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBaseView addSubview:_voiceButton];
    
    //表情按钮
    _emojiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_emojiButton setTitle:@"表情" forState:UIControlStateNormal];
    [_emojiButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [_emojiButton addTarget:self action:@selector(tapEmojiButton:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBaseView addSubview:_emojiButton];
    
    //更多按钮
    _moreButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_moreButton setTitle:@"更多" forState:UIControlStateNormal];
    [_moreButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    //[_moreButton addTarget:self action:@selector(tapMoreButton:) forControlEvents:UIControlEventTouchUpInside];
    [_inputBaseView addSubview:_moreButton];

    //文本输入视图
    _inputTextView = [[YCEmojiInputTextView alloc] init];
    _inputTextView.textViewDelegate = (id<YCEmojiInputTextViewDelegate>)self;
    _inputTextView.isFitHeight = YES;
    _inputTextView.inputTextFont = [UIFont systemFontOfSize:16];
    _inputTextView.inputTextColor = [UIColor blackColor];
    _inputTextView.placeHolderColor = [UIColor redColor];
    _inputTextView.placeHolder = @"请输入文字";
    _inputTextView.minHeight = INPUT_HEIGHT;
    _inputTextView.layer.masksToBounds = YES;
    _inputTextView.layer.cornerRadius = 4;
    [_inputBaseView addSubview:_inputTextView];
    
    //布局视图
    [self layoutView];
    
    //表情视图
    _chatEmojiPanelView = [[YCChatEmojiPanelView alloc] initWithFrame:CGRectMake(0, _inputBaseView.frame.size.height, self.bounds.size.width, 205)];
    _chatEmojiPanelView.delegate = self;
    _chatEmojiPanelView.hidden = YES;
    [self addSubview:_chatEmojiPanelView];
    
    //更多视图
    _chatMorePanelView = [[YCChatMorePanelView alloc] initWithFrame:CGRectMake(0, _inputBaseView.frame.size.height, self.bounds.size.width, 205)];
    _chatMorePanelView.hidden = YES;
    _chatMorePanelView.backgroundColor = [UIColor blueColor];
    [self addSubview:_chatMorePanelView];
    
    //_inputTextView.text = @"所有的表情:[抠鼻][撇嘴][色][发呆][得意]";
}
#pragma mark- 布局视图
- (void)layoutView
{
    CGFloat w = 44;
    CGFloat h = INPUT_HEIGHT + (2 * 6);
    _inputBaseView.frame = CGRectMake(0, 0, SCREEN_WIDTH, h);
    
    _voiceButton.frame = CGRectMake(0, 0, w, h);
    _inputTextView.frame = CGRectMake(w, 6, SCREEN_WIDTH - (3 * w), INPUT_HEIGHT);
    _emojiButton.frame = CGRectMake(SCREEN_WIDTH - (w * 2), 0, w, h);
    _moreButton.frame = CGRectMake(SCREEN_WIDTH - w, 0, w, h);
    
    self.frame = CGRectMake(0, SCREEN_HEIGHT - h, SCREEN_WIDTH, h);
}
#pragma mark- YCEmojiInputTextViewDelegate
//视图frame发生变化
- (void)viewFrameChange:(YCEmojiInputTextView *)textView
{
    CGRect rect1 = _inputBaseView.frame;
    rect1.size.height = _inputTextView.frame.size.height + 12;
    _inputBaseView.frame = rect1;
    
    //当前视图
    CGRect rect2 = self.frame;
    CGFloat h = 0;
    if (_isKeyboardShow) {
        h = _inputBaseView.frame.size.height + _keyboardFrame.size.height;
    }
    else if (!_chatEmojiPanelView.isHidden){
        h = _inputBaseView.frame.size.height + _chatEmojiPanelView.frame.size.height;
        
        CGRect rect = _chatEmojiPanelView.frame;
        rect.origin.y = _inputBaseView.frame.size.height;
        _chatEmojiPanelView.frame = rect;
    }
    else if (!_chatMorePanelView.isHidden){
        h = _inputBaseView.frame.size.height + _chatMorePanelView.frame.size.height;
        
        CGRect rect = _chatMorePanelView.frame;
        rect.origin.y = _inputBaseView.frame.size.height;
        _chatMorePanelView.frame = rect;
    }
    else{
        h = _inputBaseView.frame.size.height;
    }
    rect2.size.height = h;
    rect2.origin.y = SCREEN_HEIGHT - h;
    self.frame = rect2;
}
//点击键盘中的发送键
- (void)clickSend:(YCEmojiInputTextView *)textView
{

}
#pragma mark- 点击语音按钮
- (void)tapVoiceButton:(UIButton *)voiceButton
{

}
#pragma mark- 点击表情按钮
- (void)tapEmojiButton:(UIButton *)emojiButton
{
    _chatMorePanelView.hidden = YES;
    _moreButton.selected = NO;
    
    if (_emojiButton.isSelected){
        //是键盘弹出
        _isKeyboardShow = YES;
        _chatEmojiPanelView.hidden = YES;
        
        //显示键盘
        [_inputTextView becomeFirstResponder];
    }
    else{
        //不是键盘弹出
        _isKeyboardShow = NO;
        _chatEmojiPanelView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
             //当前视图
             CGRect rect1 = self.frame;
             CGFloat h = _inputBaseView.frame.size.height + _chatEmojiPanelView.frame.size.height;
             rect1.size.height = h;
             rect1.origin.y = SCREEN_HEIGHT - h;
             self.frame = rect1;
             
             //表情视图
             CGRect rect2 = _chatEmojiPanelView.frame;
             rect2.origin.y = _inputBaseView.frame.size.height;
             _chatEmojiPanelView.frame = rect2;
        }
        completion:^(BOOL finished) {
        }];
        
        //隐藏键盘
        [_inputTextView resignFirstResponder];
    }
    
    _emojiButton.selected = !_emojiButton.isSelected;
}
#pragma mark- 点击更多按钮
- (void)tapMoreButton:(UIButton *)moreButton
{
    _chatEmojiPanelView.hidden = YES;
    _emojiButton.selected = NO;
    
    if (_moreButton.isSelected){
        //是键盘弹出
        _isKeyboardShow = YES;
        _chatMorePanelView.hidden = YES;
        
        //显示键盘
        [_inputTextView becomeFirstResponder];
    }
    else{
        //不是键盘弹出
        _isKeyboardShow = NO;
        _chatMorePanelView.hidden = NO;
        
        [UIView animateWithDuration:0.25 animations:^{
            //当前视图
            CGRect rect1 = self.frame;
            CGFloat h = _inputBaseView.frame.size.height + _chatMorePanelView.frame.size.height;
            rect1.size.height = h;
            rect1.origin.y = SCREEN_HEIGHT - h;
            self.frame = rect1;
            
            //表情视图
            CGRect rect2 = _chatMorePanelView.frame;
            rect2.origin.y = _inputBaseView.frame.size.height;
            _chatMorePanelView.frame = rect2;
        }
        completion:^(BOOL finished) {
        }];
        
        //隐藏键盘
        [_inputTextView resignFirstResponder];
    }
    
    _moreButton.selected = !_moreButton.isSelected;
}
#pragma mark- 键盘变化的通知
- (void)keyboardChangePosition:(NSNotification *)notification
{
    NSString *name = [notification name];
    NSDictionary *info = [notification userInfo];
    CGRect keyboardFrame = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    _keyboardFrame = keyboardFrame;
    
    //键盘将要显示
    if ([name isEqualToString:UIKeyboardWillShowNotification]){
        CGFloat height = keyboardFrame.size.height + _inputBaseView.frame.size.height;
        self.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
        
        //是键盘弹出
        _isKeyboardShow = YES;
        _chatEmojiPanelView.hidden = YES;
        _chatMorePanelView.hidden = YES;
        _emojiButton.selected = NO;
        _moreButton.selected = NO;
    }
    //键盘将要隐藏
    else if ([name isEqualToString:UIKeyboardWillHideNotification]){
        //判断是不是键盘弹出隐藏的
        if (_isKeyboardShow) {
            CGFloat height = _inputBaseView.frame.size.height;
            self.frame = CGRectMake(0, SCREEN_HEIGHT - height, SCREEN_WIDTH, height);
        }
        
        //不是键盘弹出
        _isKeyboardShow = NO;
    }
}
#pragma mark- 点击表情的代理
//点击的表情
- (void)clickEmojiName:(NSString *)emojiName
{
    [_inputTextView enterEmojiName:emojiName];;
}

@end



