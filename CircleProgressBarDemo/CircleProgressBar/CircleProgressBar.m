//
//  CircleProgressBar.m
//  CircleProgressBar
//
//  Created by Andrew Cherkashin on 3/16/15.
//  Copyright (c) 2015 Eclair. All rights reserved.
//

#import "CircleProgressBar.h"

// Common
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)
const CGFloat StartAngle = -90.0f;

// Progress Bar Defaults
#define DefaultProgressBarProgressColor [UIColor colorWithRed:0.71 green:0.099 blue:0.099 alpha:0.7]
#define DefaultProgressBarTrackColor [UIColor colorWithRed:1 green:1 blue:1 alpha:0.7]
const CGFloat DefaultProgressBarWidth = 33.0f;

// Hint View Defaults
#define DefaultHintBackgroundColor [UIColor colorWithWhite:0 alpha:0.7]
#define DefaultHintTextFont [UIFont fontWithName:@"HelveticaNeue-CondensedBlack" size:30.0f]
#define DefaultHintTextColor [UIColor whiteColor]
const CGFloat DefaultHintSpacing = 20.0f;
const AttributedStringGenerationBlock DefaultHintTextGenerationBlock = ^NSAttributedString *(CGFloat progress) {
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%.0f%%", progress * 100]
                                                                             attributes:@{NSFontAttributeName:DefaultHintTextFont, NSForegroundColorAttributeName:DefaultHintTextColor}];
    
    return attr;
};

// Animation Constants
const CGFloat AnimationChangeTimeDuration = 0.2f;
const CGFloat AnimationChangeTimeStep = 0.01f;

@interface CircleProgressBar (Private)

// Common
- (CGFloat)progressAccordingToBounds:(CGFloat)progress;

// ProgressBar Drawing
- (UIColor*)progressBarProgressColorForDrawing;
- (UIColor*)progressBarTrackColorForDrawing;
- (CGFloat)progressBarWidthForDrawing;
- (void)drawProgressBar:(CGContextRef)context progressAngle:(CGFloat)progressAngle center:(CGPoint)center radius:(CGFloat)radius;

// Hint Drawing
- (CGFloat)hintViewSpacingForDrawing;
- (UIColor*)hintViewBackgroundColorForDrawing;
- (UIFont*)hintTextFontForDrawing;
- (UIColor*)hintTextColorForDrawing;
- (NSAttributedString*)stringRepresentationOfProgress:(CGFloat)progress;
- (void)drawHint:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius;

// Animation
- (void)animateProgressBarChangeFrom:(CGFloat)startProgress to:(CGFloat)endProgress;
- (void)updateProgressBarForAnimation;

@end

@implementation CircleProgressBar {
    NSTimer *_animationTimer;
    CGFloat _currentAnimationProgress, _startProgress, _endProgress, _animationProgressStep;
    AttributedStringGenerationBlock _hintTextGenerationBlock;
}

- (void)setProgress:(CGFloat)progress animated:(BOOL)animated {
    progress = [self progressAccordingToBounds:progress];
    if (_progress == progress) {
        return;
    }
    
    [_animationTimer invalidate];
    _animationTimer = nil;
    
    if (animated) {
        [self animateProgressBarChangeFrom:_progress to:progress];
    } else {
        _progress = progress;
        [self setNeedsDisplay];
    }
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    CGPoint innerCenter = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    CGFloat radius = MIN(innerCenter.x, innerCenter.y);
    CGFloat currentProgressAngle = (_progress * 360) - 90;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    [self drawProgressBar:context progressAngle:currentProgressAngle center:innerCenter radius:radius];
    if (!_hintHidden) {
        [self drawHint:context center:innerCenter radius:radius];
    }
}

#pragma mark - Setters with View Update

- (void)setProgressBarWidth:(CGFloat)progressBarWidth {
    _progressBarWidth = progressBarWidth;
    [self setNeedsDisplay];
}

- (void)setProgressBarProgressColor:(UIColor *)progressBarProgressColor {
    _progressBarProgressColor = progressBarProgressColor;
    [self setNeedsDisplay];
}

- (void)setProgressBarTrackColor:(UIColor *)progressBarTrackColor {
    _progressBarTrackColor = progressBarTrackColor;
    [self setNeedsDisplay];
}

- (void)setHintHidden:(BOOL)isHintHidden {
    _hintHidden = isHintHidden;
    [self setNeedsDisplay];
}

- (void)setHintViewSpacing:(CGFloat)hintViewSpacing {
    _hintViewSpacing = hintViewSpacing;
    [self setNeedsDisplay];
}

- (void)setHintViewBackgroundColor:(UIColor *)hintViewBackgroundColor {
    _hintViewBackgroundColor = hintViewBackgroundColor;
    [self setNeedsDisplay];
}

- (void)setHintTextFont:(UIFont *)hintTextFont {
    _hintTextFont = hintTextFont;
    [self setNeedsDisplay];
}

- (void)setHintTextColor:(UIColor *)hintTextColor {
    _hintTextColor = hintTextColor;
    [self setNeedsDisplay];
}

- (void)setHintAttributedTextGenerationBlock:(AttributedStringGenerationBlock)generationBlock {
    _hintTextGenerationBlock = generationBlock;
    [self setNeedsDisplay];
}

@end

@implementation CircleProgressBar (Private)

#pragma mark - Common

- (CGFloat)progressAccordingToBounds:(CGFloat)progress {
    progress = MIN(progress, 1);
    progress = MAX(progress, 0);
    return progress;
}

#pragma mark - ProgressBar Drawing

- (UIColor*)progressBarProgressColorForDrawing {
    return (_progressBarProgressColor != nil ? _progressBarProgressColor : DefaultProgressBarProgressColor);
}

- (UIColor*)progressBarTrackColorForDrawing {
    return (_progressBarTrackColor != nil ? _progressBarTrackColor : DefaultProgressBarTrackColor);
}

- (CGFloat)progressBarWidthForDrawing {
    return (_progressBarWidth > 0 ? _progressBarWidth : DefaultProgressBarWidth);
}

- (void)drawProgressBar:(CGContextRef)context progressAngle:(CGFloat)progressAngle center:(CGPoint)center radius:(CGFloat)radius {
    CGFloat barWidth = self.progressBarWidthForDrawing;
    if (barWidth > radius) {
        barWidth = radius;
    }
    
    CGContextSetFillColorWithColor(context, self.progressBarProgressColorForDrawing.CGColor);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(StartAngle), DEGREES_TO_RADIANS(progressAngle), 0);
    CGContextAddArc(context, center.x, center.y, radius - barWidth, DEGREES_TO_RADIANS(progressAngle), DEGREES_TO_RADIANS(StartAngle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    CGContextSetFillColorWithColor(context, self.progressBarTrackColorForDrawing.CGColor);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius, DEGREES_TO_RADIANS(progressAngle), DEGREES_TO_RADIANS(StartAngle + 360), 0);
    CGContextAddArc(context, center.x, center.y, radius - barWidth, DEGREES_TO_RADIANS(StartAngle + 360), DEGREES_TO_RADIANS(progressAngle), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
}

#pragma mark - Hint Drawing

- (CGFloat)hintViewSpacingForDrawing {
    return (_hintViewSpacing != 0 ? _hintViewSpacing : DefaultHintSpacing);
}

- (UIColor*)hintViewBackgroundColorForDrawing {
    return (_hintViewBackgroundColor != nil ? _hintViewBackgroundColor : DefaultHintBackgroundColor);
}

- (UIFont*)hintTextFontForDrawing {
    return (_hintTextFont != nil ? _hintTextFont : DefaultHintTextFont);
}

- (UIColor*)hintTextColorForDrawing {
    return (_hintTextColor != nil ? _hintTextColor : DefaultHintTextColor);
}

- (NSAttributedString*)stringRepresentationOfProgress:(CGFloat)progress {
    return (_hintTextGenerationBlock != nil ? _hintTextGenerationBlock(progress) : DefaultHintTextGenerationBlock(progress));
}

- (void)drawHint:(CGContextRef)context center:(CGPoint)center radius:(CGFloat)radius {
    CGFloat barWidth = self.progressBarWidthForDrawing;
    if (barWidth + self.hintViewSpacingForDrawing > radius) {
        return;
    }
    
    CGContextSetFillColorWithColor(context, self.hintViewBackgroundColorForDrawing.CGColor);
    CGContextBeginPath(context);
    CGContextAddArc(context, center.x, center.y, radius - barWidth - self.hintViewSpacingForDrawing, DEGREES_TO_RADIANS(0), DEGREES_TO_RADIANS(360), 1);
    CGContextClosePath(context);
    CGContextFillPath(context);
    
    NSAttributedString *progressString = [self stringRepresentationOfProgress:_progress];
    
    CGSize hintTextSize = [progressString boundingRectWithSize:CGSizeZero options:NSStringDrawingUsesFontLeading context:nil].size;
    [progressString drawAtPoint:CGPointMake(center.x - hintTextSize.width / 2, center.y - hintTextSize.height / 2)];
}

#pragma mark - Amination

- (void)animateProgressBarChangeFrom:(CGFloat)startProgress to:(CGFloat)endProgress {
    _currentAnimationProgress = _startProgress = startProgress;
    _endProgress = endProgress;
    
    _animationProgressStep = (_endProgress - _startProgress) * AnimationChangeTimeStep / AnimationChangeTimeDuration;
    
    _animationTimer = [NSTimer scheduledTimerWithTimeInterval:AnimationChangeTimeStep target:self selector:@selector(updateProgressBarForAnimation) userInfo:nil repeats:YES];
}

- (void)updateProgressBarForAnimation {
    _currentAnimationProgress += _animationProgressStep;
    _progress = _currentAnimationProgress;
    if ((_animationProgressStep > 0 && _currentAnimationProgress >= _endProgress) || (_animationProgressStep < 0 && _currentAnimationProgress <= _endProgress)) {
        [_animationTimer invalidate];
        _animationTimer = nil;
        _progress = _endProgress;
    }
    [self setNeedsDisplay];
}

@end