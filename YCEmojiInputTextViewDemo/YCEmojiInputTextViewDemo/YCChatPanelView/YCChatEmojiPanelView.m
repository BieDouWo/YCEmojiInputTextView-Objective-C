
#import "YCChatEmojiPanelView.h"
#import "YCChatEmojiCollectionView.h"

//将数字转为emoji
#define EMOJI_CODE_TO_SYMBOL(x) ((((0x808080F0 | (x & 0x3F000) >> 4) | (x & 0xFC0) << 10) | (x & 0x1C0000) << 18) | (x & 0x3F) << 24);

@implementation YCChatEmojiPanelCell
{
    BOOL _isInitialize;
}
#pragma mark- 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    
    _emojiView = [[YCChatEmojiCollectionView alloc] initWithFrame:self.bounds];
    [self addSubview:_emojiView];
}
#pragma mark- 刷新表情
- (void)refreshChatEmojiArr:(NSMutableArray *)emojiArr
{
    [_emojiView refreshChatEmojiArr:emojiArr];
}

@end

@implementation YCChatEmojiPanelView
{
    BOOL _isInitialize;
    NSString *_chatEmojiPanelCellID;
    NSMutableArray *_emojiArr;
    UICollectionView *_collectionView;
    UICollectionViewFlowLayout *_layout;
}
#pragma mark- 初始化
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    self.backgroundColor = [UIColor whiteColor];
    
    //创建流水布局
    _layout = [[UICollectionViewFlowLayout alloc] init];
    //横向滚动
    _layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    //设置整个collectionView的内边距
    CGFloat paddingY = 0.0;
    CGFloat paddingX = 0.0;
    _layout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    
    //设置每一列之间的间距
    _layout.minimumInteritemSpacing = paddingX;
    //设置每一行之间的间距
    _layout.minimumLineSpacing = paddingY;
    
    //设置每个格子的尺寸
    _layout.itemSize = self.bounds.size;
    
    //设置集合视图
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
    
    //设置为翻页模式
    _collectionView.pagingEnabled = YES;
    //隐藏水平滚动条
    _collectionView.showsHorizontalScrollIndicator = NO;
    
    //注册cell
    _chatEmojiPanelCellID = @"YCChatEmojiPanelCell";
    [_collectionView registerClass:[YCChatEmojiPanelCell class] forCellWithReuseIdentifier:_chatEmojiPanelCellID];
    
    //设置代理
    _collectionView.delegate = (id<UICollectionViewDelegate>)self;
    _collectionView.dataSource = (id<UICollectionViewDataSource>)self;
    
    //获取默认的表情数据
    _emojiArr = [YCChatEmojiPanelView getDefaultEmojiArr];
    
    //刷新数据
    [_collectionView reloadData];
}
#pragma mark- UICollectionView代理
//多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//这组多少行
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _emojiArr.count;
}
//每行cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCChatEmojiPanelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_chatEmojiPanelCellID forIndexPath:indexPath];
    
    cell.emojiView.emojiPanelView = self;
    
    NSMutableArray *emojiArr = _emojiArr[indexPath.row];
    [cell refreshChatEmojiArr:emojiArr];
    
    return cell;
}
//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}
#pragma mark- UIScrollView代理
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    NSInteger p = (NSInteger)(scrollView.contentOffset.x/scrollView.width);
//    if (p < _expressionNameArr.count && p >= 0) {
//        _expressionPageControl.currentPage = p;
//    }
}
#pragma mark- 获取默认的表情数据
+ (NSMutableArray *)getDefaultEmojiArr
{
    //自定义表情
    NSArray *emojiNameArr = @[@"[抠鼻]",@"[撇嘴]",@"[色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",@"[闭嘴]",@"[睡]",@"[大哭]",@"[尴尬]",@"[发怒]",@"[调皮]",@"[呲牙]",@"[微笑]",@"[难过]",@"[酷]",@"[冷汗]",@"[抓狂]",@"[吐]",@"[偷笑]",@"[可爱]",@"[白眼]",@"[傲慢]",@"[饥饿]",@"[困]",@"[惊恐]",@"[流汗]",@"[憨笑]",@"[装逼]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘]",@"[晕]",@"[折磨]",@"[衰]",@"[骷髅]",@"[敲打]",@"[再见]",@"[擦汗]",@"[吓]",@"[蛋糕]",@"[刀]"];
    
    NSMutableArray *emojiArr1 = [NSMutableArray array];
    for (NSInteger i = 0; i < emojiNameArr.count; ++i)
    {
        YCChatEmojiModel *model = [[YCChatEmojiModel alloc] init];
        model.emojiName = emojiNameArr[i];
        model.emojiImageName = [NSString stringWithFormat:@"%03zd.png", i + 1];
        model.emojiImage = [UIImage imageNamed:model.emojiImageName];
        [emojiArr1 addObject:model];
    }
    
    //emoji表情
    NSMutableArray *emojiArr2 = [NSMutableArray array];
    for (int i = 0x1F600; i <= 0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            int sym = EMOJI_CODE_TO_SYMBOL(i);
            NSString *emoT = [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
            
            YCChatEmojiModel *model = [[YCChatEmojiModel alloc] init];
            model.emojiName = emoT;
            model.emojiImageName = @"";
            model.emojiImage = nil;
            [emojiArr2 addObject:model];
        }
    }
    
    return [NSMutableArray arrayWithArray:@[emojiArr1, emojiArr2]];
}

@end


