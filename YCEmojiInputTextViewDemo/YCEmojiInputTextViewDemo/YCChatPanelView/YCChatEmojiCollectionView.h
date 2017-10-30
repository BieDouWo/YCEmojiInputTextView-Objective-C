
#import <UIKit/UIKit.h>
#import "YCChatEmojiPanelView.h"

@interface YCChatEmojiModel : NSObject
@property (nonatomic, copy) NSString *emojiName;
@property (nonatomic, copy) NSString *emojiImageName;
@property (nonatomic, strong) UIImage *emojiImage;

@end

@interface YCChatEmojiCell : UICollectionViewCell

@end

@interface YCChatEmojiCollectionView : UIView
@property (nonatomic, weak) YCChatEmojiPanelView *emojiPanelView;

//刷新表情数据
- (void)refreshChatEmojiArr:(NSMutableArray *)emojiArr;

@end
