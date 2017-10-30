
#import <UIKit/UIKit.h>
#import "YCEmojiTextAttachment.h"

//默认的表情正则
#define kEmojiRegular @"\\[[a-zA-Z0-9\\u4e00-\\u9fa5\\,]+\\]"

@class YCEmojiInputTextView;
@protocol YCEmojiInputTextViewDelegate <NSObject>
@optional
//文字发生变化
- (void)textChange:(YCEmojiInputTextView *)textView;
//视图frame发生变化
- (void)viewFrameChange:(YCEmojiInputTextView *)textView;
//点击键盘中的发送键
- (void)clickSend:(YCEmojiInputTextView *)textView;

@end

@interface YCEmojiInputTextView : UITextView
@property (nonatomic, assign) BOOL isDisableEmoji;       //是否禁用表情(默认为不禁用)
@property (nonatomic, assign) BOOL isFitHeight;          //是否自适应高度(默认不)

@property (nonatomic, strong) UIFont *inputTextFont;     //文字字体(默认为系统字体大小14)
@property (nonatomic, strong) UIColor *inputTextColor;   //文字颜色(默认为黑色)
@property (nonatomic, strong) UIColor *placeHolderColor; //占位符颜色(默认为灰色)
@property (nonatomic, copy) NSString *placeHolder;       //占位符

@property (nonatomic, assign) NSUInteger minHeight;      //最小高度值(默认为33,14号字体高度)
@property (nonatomic, assign) NSUInteger maxHeight;      //最大高度值(默认为100)
@property (nonatomic, assign) NSUInteger maxLimitNum;    //字数限制(默认为不限制)

@property (nonatomic, weak) id <YCEmojiInputTextViewDelegate> textViewDelegate;

//自定义表情字典(key:正则所对应的表情名称,value:表情图片名称,图片名必须传完整的,如:01.png 或 01@2x.png)
@property (nonatomic, strong) NSMutableDictionary *emojiDic;

//输入表情
- (void)enterEmojiName:(NSString *)emojiName;

@end
