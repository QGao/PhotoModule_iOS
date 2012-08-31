#import "PTVideoThumbnailImageView.h"

@implementation PTVideoThumbnailImageView

@synthesize orientation = _orientation;

+ (UIImage *)applyMask:(UIImage *)image forOrientation:(PTItemOrientation)orientation
{
    CGImageRef maskImageRef = [[UIImage imageNamed:@"PTShowcase.bundle/video-mask.png"] CGImage];
    CGImageRef maskRef = CGImageMaskCreate(CGImageGetWidth(maskImageRef),
                                           CGImageGetHeight(maskImageRef),
                                           CGImageGetBitsPerComponent(maskImageRef),
                                           CGImageGetBitsPerPixel(maskImageRef),
                                           CGImageGetBytesPerRow(maskImageRef),
                                           CGImageGetDataProvider(maskImageRef),
                                           NULL,
                                           NO);
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], maskRef);
    CGImageRelease(maskRef);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    CGImageRelease(maskedImageRef);
    
    return maskedImage;
}

- (void)networkImageViewDidLoadImage:(UIImage *)image {
    self.image = [PTVideoThumbnailImageView applyMask:image forOrientation:self.orientation];
}

@end
