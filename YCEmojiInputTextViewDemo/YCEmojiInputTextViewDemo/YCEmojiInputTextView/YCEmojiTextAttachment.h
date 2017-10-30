
#import <UIKit/UIKit.h>

@interface NSAttributedString (YCEmojiExtension)
- (NSString *)getPlainString;

@end

@interface YCEmojiTextAttachment : NSTextAttachment
@property(strong, nonatomic) NSString *emojiTag; //表情标记
@property(assign, nonatomic) CGSize emojiSize;   //表情大小

@end
