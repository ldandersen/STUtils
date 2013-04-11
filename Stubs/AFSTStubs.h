#import <CommonCrypto/CommonCrypto.h>

@interface NSData(STStubs)
- (NSString*)base64EncodedString;
@end

@interface NSString(STStubs)
- (BOOL)isEmailAddress;
@end

#if TARGET_OS_IPHONE
@interface UIColor(STStubs)
+(UIColor*)tableCellEditableTextColor;
@end

@interface UIView(STStubs)
- (CGRect)centeredSubRectOfSize:(CGSize)size insideRect:(CGRect)rect;
@end
#endif

#define STLocalizedString(key) NSLocalizedString(key, @"")
#define STDefaultNavBarHeight 44.0f