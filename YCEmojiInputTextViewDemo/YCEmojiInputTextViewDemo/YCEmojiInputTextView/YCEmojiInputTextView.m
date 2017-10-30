
#import "YCEmojiInputTextView.h"

@implementation YCEmojiInputTextView
{
    BOOL _isInitialize;
    UILabel *_placeHolderLabel;
}
#pragma mark- 释放
- (void)dealloc
{
    //[self removeObserver:self forKeyPath:@"contentSize" context:NULL];
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
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initialize];
}
- (void)initialize
{
    if (_isInitialize) {
        return;
    }else{
        _isInitialize = YES;
    }
    
    _isDisableEmoji = NO;                          //是否禁用表情(默认为不禁用)
    _isFitHeight = NO;                             //是否自适应高度(默认不)
    
    _inputTextFont = [UIFont systemFontOfSize:14]; //文字字体(默认为系统字体大小14)
    _inputTextColor = [UIColor blackColor];        //文字颜色(默认为黑色)
    _placeHolderColor = [UIColor lightGrayColor];  //占位符颜色(默认为灰色)
    _placeHolder = @"";                            //占位符

    _minHeight = 33;                               //最小高度值(默认为33)
    _maxHeight = 100;                              //最大高度值(默认为100)
    _maxLimitNum = 0;                              //字数限制(默认为不限制)

    _emojiDic = [self getDefaultEmojiDic];         //表情字典
    self.delegate = (id<UITextViewDelegate>)self;  //设置代理
    self.returnKeyType = UIReturnKeySend;          //设置为发送键

    //监听内容居中
    self.textAlignment = NSTextAlignmentLeft;
    //self.textContainerInset = UIEdgeInsetsZero;
    //[self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:NULL];
    
    //占位符标签
    _placeHolderLabel = [[UILabel alloc] init];
    _placeHolderLabel.backgroundColor = [UIColor clearColor];
    _placeHolderLabel.font = _inputTextFont;
    _placeHolderLabel.textColor = _placeHolderColor;
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:_placeHolderLabel];
}
#pragma mark- 设置文字
- (void)setText:(NSString *)text
{
    [super setText:text];
    
    //转化为富文本
    self.attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    //刷新富文本
    [self refreshAttributedText];
}
#pragma mark- 设置字体
- (void)setInputTextFont:(UIFont *)inputTextFont
{
    _inputTextFont = inputTextFont;
    self.font = _inputTextFont;
    _placeHolderLabel.font = _inputTextFont;
}
#pragma mark- 设置文字颜色
- (void)setInputTextColor:(UIColor *)inputTextColor
{
    _inputTextColor = inputTextColor;
    self.textColor = _inputTextColor;
}
#pragma mark- 设置占位符颜色
- (void)setPlaceHolderColor:(UIColor *)placeHolderColor
{
    _placeHolderColor = placeHolderColor;
    _placeHolderLabel.textColor = _placeHolderColor;
}
#pragma mark- 设置占位符
- (void)setPlaceHolder:(NSString *)placeHolder
{
    _placeHolder = placeHolder;
    _placeHolderLabel.text = placeHolder;
    [_placeHolderLabel sizeToFit];
}
#pragma mark- 设置frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    CGRect rect = CGRectMake(5, 7.5, frame.size.width - 10, 0);
    _placeHolderLabel.frame = rect;
    [_placeHolderLabel sizeToFit];
    
//    if (_placeHolderLabel.frame.size.height > frame.size.height) {
//        rect.origin.y = 0;
//        rect.size.height = frame.size.height;
//        _placeHolderLabel.frame = rect;
//    }
//    else{
//        rect.origin.y = (frame.size.height - _placeHolderLabel.frame.size.height) / 2.0 ;
//        rect.size.height = _placeHolderLabel.frame.size.height;
//        _placeHolderLabel.frame = rect;
//    }

    //通知代理视图frame发生变化
    if (_textViewDelegate && [_textViewDelegate respondsToSelector:@selector(viewFrameChange:)]) {
        [_textViewDelegate viewFrameChange:self];
    }
}
#pragma mark- 输入表情
- (void)enterEmojiName:(NSString *)emojiName
{
    //判断是自定义表情
    if (![self stringContainsEmoji:emojiName]) {
        //判断没有配置这个表情
        if (_emojiDic[emojiName] == nil) {
            return;
        }
    }

    //判断输入一个表情后,是否超过字数限制
    NSUInteger textNum = self.attributedText.length + 1;
    if (_maxLimitNum != 0 && textNum > _maxLimitNum) {
        return;
    }
    
    //设置表情
    NSAttributedString *attachString = nil;
    if (![self stringContainsEmoji:emojiName]) {
        YCEmojiTextAttachment *attach = [[YCEmojiTextAttachment alloc] init];
        attach.emojiTag = emojiName;
        attach.image = [UIImage imageNamed:_emojiDic[emojiName]];
        attach.emojiSize = CGSizeMake(_inputTextFont.lineHeight, _inputTextFont.lineHeight);
        attachString = [NSAttributedString attributedStringWithAttachment:attach];
    }else{
        attachString = [[NSAttributedString alloc] initWithString:emojiName];
    }

    //删除选中的文字
    NSRange selectedRange = self.selectedRange;
    if (selectedRange.length > 0) {
        [self.textStorage deleteCharactersInRange:selectedRange];
    }
    
    //插入表情
    [self.textStorage insertAttributedString:attachString atIndex:self.selectedRange.location];
    
    //重新设置光标位置
    self.selectedRange = NSMakeRange(selectedRange.location + attachString.length, 0);
}
//判断是否有emoji
- (BOOL)stringContainsEmoji:(NSString *)string
{
    __block BOOL returnValue = NO;
    
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length])
                               options:NSStringEnumerationByComposedCharacterSequences
                            usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop)
    {
        const unichar high = [substring characterAtIndex: 0];
        
        // Surrogate pair (U+1D000-1F9FF)
        if (0xD800 <= high && high <= 0xDBFF) {
            const unichar low = [substring characterAtIndex: 1];
            const int codepoint = ((high - 0xD800) * 0x400) + (low - 0xDC00) + 0x10000;
            
            if (0x1D000 <= codepoint && codepoint <= 0x1F9FF){
                returnValue = YES;
            }
            
            // Not surrogate pair (U+2100-27BF)
        } else {
            if (0x2100 <= high && high <= 0x27BF){
                returnValue = YES;
            }
        }
    }];
    
    return returnValue;
}
#pragma mark- 刷新富文本
- (void)refreshAttributedText
{
    NSString *text = [self.attributedText getPlainString];
    if (text.length == 0) {
        return;
    }
    
    //转化为富文本
    NSRange selectedRange = self.selectedRange;
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
    
    //字体和颜色
    [attributedText addAttribute:NSFontAttributeName value:_inputTextFont range:NSMakeRange(0, attributedText.length)];
    [attributedText addAttribute:NSForegroundColorAttributeName value:_inputTextColor range:NSMakeRange(0, attributedText.length)];
    
    //遍历出所有表情
    NSMutableArray *emojiRangeArr = [self findEmojiWithPattern:kEmojiRegular string:text emojiDic:_emojiDic];
    for (NSInteger i = 0; i < emojiRangeArr.count; ++i) {
        //取出表情的位置
        NSRange emojiRange = [emojiRangeArr[i] rangeValue];
        NSString *emojiName = [text substringWithRange:emojiRange];
        
        //设置表情
        YCEmojiTextAttachment *attach = [[YCEmojiTextAttachment alloc] init];
        attach.emojiTag = emojiName;
        attach.image = [UIImage imageNamed:_emojiDic[emojiName]];
        attach.emojiSize = CGSizeMake(_inputTextFont.lineHeight, _inputTextFont.lineHeight);
        NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
        
        //替换为表情
        [attributedText replaceCharactersInRange:emojiRange withAttributedString:attachString];
    }
    
    //判断加上输入的字符和减去选中的字符,是否超过字数限制
    if (_maxLimitNum != 0 && attributedText.length > _maxLimitNum) {
        NSAttributedString *attString = [attributedText attributedSubstringFromRange:NSMakeRange(0, _maxLimitNum)];
        //重新设置富文本
        self.attributedText = attString;
    }else{
        //重新设置富文本
        self.attributedText = attributedText;
    }
    
    //还原光标位置
    self.selectedRange = selectedRange;
}
#pragma mark- 输入富文本
- (void)enterAttributedText:(NSString *)text
{
    if (text.length > 0) {
        //获取粘贴的文字
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
        
        //字体和颜色
        [attributedText addAttribute:NSFontAttributeName value:_inputTextFont range:NSMakeRange(0, attributedText.length)];
        [attributedText addAttribute:NSForegroundColorAttributeName value:_inputTextColor range:NSMakeRange(0, attributedText.length)];
        
        //遍历出所有表情
        NSMutableArray *emojiRangeArr = [self findEmojiWithPattern:kEmojiRegular string:text emojiDic:_emojiDic];
        for (NSInteger i = 0; i < emojiRangeArr.count; ++i) {
            //取出表情的位置
            NSRange emojiRange = [emojiRangeArr[i] rangeValue];
            NSString *emojiName = [text substringWithRange:emojiRange];
            
            //设置表情
            YCEmojiTextAttachment *attach = [[YCEmojiTextAttachment alloc] init];
            attach.emojiTag = emojiName;
            attach.image = [UIImage imageNamed:_emojiDic[emojiName]];
            attach.emojiSize = CGSizeMake(_inputTextFont.lineHeight, _inputTextFont.lineHeight);
            NSAttributedString *attachString = [NSAttributedString attributedStringWithAttachment:attach];
            
            //替换为表情
            [attributedText replaceCharactersInRange:emojiRange withAttributedString:attachString];
        }

        //计算出这次输入后总的字数
        NSRange selectedRange = self.selectedRange;
        NSUInteger textNum = self.attributedText.length + attributedText.length - selectedRange.length;
        
        //删除选中的文字
        if (selectedRange.length > 0) {
            [self.textStorage deleteCharactersInRange:selectedRange];
        }
        
        //判断加上输入的字符和减去选中的字符,是否超过字数限制
        if (_maxLimitNum != 0 && textNum > _maxLimitNum) {
            NSAttributedString *attString = [attributedText attributedSubstringFromRange:NSMakeRange(0, _maxLimitNum - self.attributedText.length)];
            //插入文字
            [self.textStorage insertAttributedString:attString atIndex:selectedRange.location];
            
            //重新设置光标位置
            self.selectedRange = NSMakeRange(selectedRange.location + attString.length, 0);
        }
        else{
            //插入文字
            [self.textStorage insertAttributedString:attributedText atIndex:selectedRange.location];
            
            //重新设置光标位置
            self.selectedRange = NSMakeRange(selectedRange.location + attributedText.length, 0);
        }
    }
}
#pragma mark- 查找自定义表情
- (NSMutableArray *)findEmojiWithPattern:(NSString *)pattern string:(NSString *)string emojiDic:(NSDictionary *)emojiDic
{
    //是否禁用表情
    if (_isDisableEmoji) {
        return nil;
    }
    if (pattern.length == 0 || string.length == 0){
        return nil;
    }
    NSError *error = nil;
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
    if (error) {
        NSLog(@"查找自定义表情位置失败:%@", error);
        return nil;
    }
    NSArray *resultArr = [regExp matchesInString:string options:NSMatchingReportCompletion range:NSMakeRange(0, string.length)];
    NSMutableArray *emojiRangeArr = [NSMutableArray array];
    for(NSInteger i = 0; i < resultArr.count; ++i){
        @autoreleasepool {
            NSRange emojiRange = [resultArr[i] range];
            NSString *emojiName = [string substringWithRange:emojiRange];
            //判断表情字典中是否存在这个表情
            if (emojiDic[emojiName] != nil) {
                [emojiRangeArr addObject:[NSValue valueWithRange:emojiRange]];
            }
        }
    }
    //从大到小排序
    [emojiRangeArr sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSRange range1 = [obj1 rangeValue];
        NSRange range2 = [obj2 rangeValue];
        if (range1.location > range2.location){
            return NSOrderedAscending;
        }
        return NSOrderedDescending;
    }];

    return emojiRangeArr;
}
#pragma mark- 获取默认的表情字典
- (NSMutableDictionary *)getDefaultEmojiDic
{
    NSArray *emojiNameArr = @[@"[抠鼻]",@"[撇嘴]",@"[色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",@"[闭嘴]",@"[睡]",@"[大哭]",@"[尴尬]",@"[发怒]",@"[调皮]",@"[呲牙]",@"[微笑]",@"[难过]",@"[酷]",@"[冷汗]",@"[抓狂]",@"[吐]",@"[偷笑]",@"[可爱]",@"[白眼]",@"[傲慢]",@"[饥饿]",@"[困]",@"[惊恐]",@"[流汗]",@"[憨笑]",@"[装逼]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘]",@"[晕]",@"[折磨]",@"[衰]",@"[骷髅]",@"[敲打]",@"[再见]",@"[擦汗]",@"[吓]",@"[蛋糕]",@"[刀]"];
    NSMutableDictionary *emojiDic = [NSMutableDictionary dictionary];
    for (NSInteger i = 0; i < emojiNameArr.count; ++i) {
        NSString *emojiImageName = [NSString stringWithFormat:@"%03zd.png", i + 1];
        [emojiDic setObject:emojiImageName forKey:emojiNameArr[i]];
    }
    return emojiDic;
}
#pragma mark- UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //判断点击的是return
    if ([text isEqualToString:@"\n"]) {
        //通知代理点击了发送键
        if (_textViewDelegate && [_textViewDelegate respondsToSelector:@selector(clickSend:)]) {
            [_textViewDelegate clickSend:self];
        }
        return NO;
    }
    
    //判断点击的是删除键
    if (text.length == 0) {
        return YES;
    }
    
    //输入富文本
    [self enterAttributedText:text];
    
    return NO;
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
    //通知代理文字发生变化
    if (_textViewDelegate && [_textViewDelegate respondsToSelector:@selector(textChange:)]) {
        [_textViewDelegate textChange:self];
    }
    
    //判断是否开启自适应高度
    if (!_isFitHeight) {
        return;
    }
    
    //计算输入框高度
    CGRect rect = self.frame;
    rect.size.height = [self getTextHeight];
    self.frame = rect;
    
    //判断是否显示占位符
    if (textView.attributedText.length == 0) {
        _placeHolderLabel.hidden = NO;
    }else{
        _placeHolderLabel.hidden = YES;
    }
}
#pragma mark- 获取文字的高度
- (CGFloat)getTextHeight
{
    CGFloat h = 0;
    if ([self respondsToSelector:@selector(snapshotViewAfterScreenUpdates:)]){
        h = ceilf([self sizeThatFits:self.frame.size].height);
    }else {
        h = self.contentSize.height;
    }
    if (h < _minHeight) {
        h = _minHeight;
    }
    return h > _maxHeight ? _maxHeight : h;
}
#pragma mark- KVO监听内容居中
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"])
    {
        UITextView *textView = object;
        CGFloat deadSpace = ([textView bounds].size.height - [textView contentSize].height);
        CGFloat inset = MAX(0, deadSpace/2.0);
        textView.contentInset = UIEdgeInsetsMake(inset, textView.contentInset.left, inset, textView.contentInset.right);
    }
}
#pragma mark- 截取复制事件
- (void)copy:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    NSAttributedString *copyAttString = [self.attributedText attributedSubstringFromRange:self.selectedRange];
    pasteboard.string = [copyAttString getPlainString];
}
#pragma mark- 截取粘贴事件
- (void)paste:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    [self enterAttributedText:pasteboard.string];
}

@end




