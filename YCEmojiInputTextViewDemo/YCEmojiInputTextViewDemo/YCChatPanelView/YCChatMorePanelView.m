
#import "YCChatMorePanelView.h"

#define MORE_ROWNUM  4  //一行个数

@implementation YCChatMoreCell
{
    BOOL _isInitialize;
    UIImageView *_imageView;
    UILabel *_label;
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
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    
    //图片视图
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(10, 10, self.bounds.size.width - 20, self.bounds.size.height - 20);
    [self addSubview:_imageView];
    
    //标签视图
    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(4, 4, self.bounds.size.width - 8, self.bounds.size.height - 8);
    _label.font = [UIFont systemFontOfSize:25];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.textColor = [UIColor whiteColor];
    [self addSubview:_label];
}

@end

@implementation YCChatMorePanelView
{
    BOOL _isInitialize;
    NSString *_chatMoreCellID;
    NSMutableArray *_moreArr;
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
    //纵向滚动
    _layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    //设置整个collectionView的内边距
    CGFloat paddingY = 0.0;
    CGFloat paddingX = 0.0;
    _layout.sectionInset = UIEdgeInsetsMake(paddingY, paddingX, paddingY, paddingX);
    
    //设置每一列之间的间距
    _layout.minimumInteritemSpacing = paddingX;
    //设置每一行之间的间距
    _layout.minimumLineSpacing = paddingY;
    
    //设置每个格子的尺寸
    CGFloat w = self.bounds.size.width / MORE_ROWNUM;
    _layout.itemSize = CGSizeMake(w, w);
    
    //设置集合视图
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self addSubview:_collectionView];
    
    //注册cell
    _chatMoreCellID = @"YCChatMoreCell";
    [_collectionView registerClass:[YCChatMoreCell class] forCellWithReuseIdentifier:_chatMoreCellID];
    
    //设置代理
    _collectionView.delegate = (id<UICollectionViewDelegate>)self;
    _collectionView.dataSource = (id<UICollectionViewDataSource>)self;
}
#pragma mark- 刷新更多数据
- (void)refreshChatMoreArr:(NSMutableArray *)moreArr
{
    _moreArr = moreArr;
    
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
    return _moreArr.count;
}
//每行cell
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    YCChatMoreCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_chatMoreCellID forIndexPath:indexPath];
    
    return cell;
}
//选中cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}

@end



