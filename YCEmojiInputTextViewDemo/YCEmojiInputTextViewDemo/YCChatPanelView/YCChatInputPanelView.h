
#import <UIKit/UIKit.h>
#import "YCEmojiInputTextView.h"
#import "YCChatEmojiPanelView.h"
#import "YCChatMorePanelView.h"

@interface YCChatInputPanelView : UIView <YCChatEmojiPanelViewDelegate>
@property (nonatomic, strong) YCEmojiInputTextView *inputTextView;  //文本输入视图

@end
