//
//  CircleProgressBar.h
//  CircleProgressBar
//
//  Created by Andrew Cherkashin on 3/16/15.
//  Copyright (c) 2015 Eclair. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NSString*(^StringGenerationBlock)(CGFloat progress);
typedef NSAttributedString*(^AttributedStringGenerationBlock)(CGFloat progress);

/** Class that represents CircleProgressBar itself.
 
 CircleProgressBar can be initialized programmatically or using InterfaceBuilder.
 
 To change progress in CircleProgressBar just use:
 
 [ setProgress:(CGFloat) animated:(BOOL)animated];
 
 Interface provides ability to customize each element of CircleProgressBar independently;
 
 */
IB_DESIGNABLE
@interface CircleProgressBar : UIView

/// @brief Width of Progress Bar
@property (nonatomic) IBInspectable CGFloat progressBarWidth;
/// @brief Progress color in Progress Bar
@property (nonatomic) IBInspectable UIColor *progressBarProgressColor;
/// @brief Track color in Progress Bar
@property (nonatomic) IBInspectable UIColor *progressBarTrackColor;
/// @brief Start Angle
@property (nonatomic) IBInspectable CGFloat startAngle;

/// @brief Whether HintView should be shown or not
@property (nonatomic) IBInspectable BOOL hintHidden;
/// @brief Inner spacing between Progress Bar and Hint View
@property (nonatomic) IBInspectable CGFloat hintViewSpacing;
/// @brief Hint View Background Color
@property (nonatomic) IBInspectable UIColor *hintViewBackgroundColor;
/// @brief Hint View Text Font
@property (nonatomic) IBInspectable UIFont *hintTextFont;
/// @brief Hint View Text Color
@property (nonatomic) IBInspectable UIColor *hintTextColor;

/** Used to set block that generates NSString according to progress, to show it in Hint View
 
 @param StringGenerationBlock block with CGFloat progress parameter, that returns NSString*
 */
- (void)setHintTextGenerationBlock:(StringGenerationBlock)generationBlock;

/** Used to set block that generates NSAttributedString according to progress, to show it in Hint View
 
 @param AttributedStringGenerationBlock block with CGFloat progress parameter, that returns NSAttributedString*
 */
- (void)setHintAttributedGenerationBlock:(AttributedStringGenerationBlock)generationBlock;

/// @brief Current ProgressBar's progress (Read-Only)
/// To change ProgressBar's progress use setProgress:animated:
@property (nonatomic, readonly) IBInspectable CGFloat progress;

/// @brief Indicates of there is ongoing animation
@property (nonatomic, readonly) BOOL isAnimating;

/** Used to set progress with animation or without
 
 @param progress progress to be set
 @param animated should control animate progress change or not
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated;

/** Used to set progress with animation and custom duration
 
 @param progress progress to be set
 @param animated should control animate progress change or not
 @param duration animation duration (default is 0.2f)
 */
- (void)setProgress:(CGFloat)progress animated:(BOOL)animated duration:(CGFloat)duration;

/// Used to stop ongoing animation
- (void)stopAnimation;

@end
