
#import "YCEmojiTextAttachment.h"

@implementation NSAttributedString (YCEmojiExtension)

- (NSString *)getPlainString
{
    NSMutableString *plainString = [NSMutableString stringWithString:self.string];
    __block NSUInteger base = 0;
    
    [self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(0, self.length) options:0 usingBlock:^(id value, NSRange range, BOOL *stop) {
        if (value && [value isKindOfClass:[YCEmojiTextAttachment class]])
        {
            [plainString replaceCharactersInRange:NSMakeRange(range.location + base, range.length) withString:((YCEmojiTextAttachment *)value).emojiTag];
            base += ((YCEmojiTextAttachment *)value).emojiTag.length - 1;
        }
    }];
    
    return plainString;
}

@end

@implementation YCEmojiTextAttachment

- (CGRect)attachmentBoundsForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(CGRect)lineFrag glyphPosition:(CGPoint)position characterIndex:(NSUInteger)charIndex
{
    return CGRectMake(0, -(_emojiSize.height/5.f), _emojiSize.width, _emojiSize.height);
}

@end
