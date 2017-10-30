
#import <UIKit/UIKit.h>

@class YCChatEmojiCollectionView;
@protocol YCChatEmojiPanelViewDelegate <NSObject>
@optional
//点击的表情
- (void)clickEmojiName:(NSString *)emojiName;

@end

@interface YCChatEmojiPanelCell : UICollectionViewCell
@property (nonatomic, strong) YCChatEmojiCollectionView *emojiView;;

@end

@interface YCChatEmojiPanelView : UIView
@property (nonatomic, weak) id <YCChatEmojiPanelViewDelegate> delegate;

@end

