//
//  ViewController.m
//  CircleProgressBar
//
//  Created by Andrew Cherkashin on 3/15/15.
//  Copyright (c) 2015 Eclair. All rights reserved.
//

#import "DemoViewController.h"
#import "CircleProgressBar.h"

@interface DemoViewController (Private)

- (CustomizationState)nextCustomizationState:(CustomizationState)state;
- (NSString*)buttonTextForState:(CustomizationState)state;
- (void)customizeAccordingToState:(CustomizationState)state;

@end

@implementation DemoViewController {
    CustomizationState _state;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)increaseProgress:(id)sender {
    [_circleProgressBar setProgress:(_circleProgressBar.progress + 0.06f) animated:YES];
}

- (IBAction)decreaseProgress:(id)sender {
    [_circleProgressBar setProgress:(_circleProgressBar.progress - 0.06f) animated:YES];
}

- (IBAction)customizeNext:(id)sender {
    _state = [self nextCustomizationState:_state];
    
    [self customizeAccordingToState:_state];
    
    [_customizeButton setTitle:[self buttonTextForState:_state] forState:UIControlStateNormal];
}

@end

@implementation DemoViewController (Private)

- (CustomizationState)nextCustomizationState:(CustomizationState)state {
    switch (state) {
        case CustomizationStateCustomAttributed: return 0;
        default: return (state + 1);
    }
}

- (NSString*)buttonTextForState:(CustomizationState)state {
    switch ([self nextCustomizationState:state]) {
        case CustomizationStateDefault: return @"BACK TO DEFAULTS";
        case CustomizationStateCustom: return @"CUSTOMIZE";
        case CustomizationStateCustomAttributed: return @"ADD ATTRIBUTED TEXT";
    }
}

- (void)customizeAccordingToState:(CustomizationState)state {
    BOOL customized = state != CustomizationStateDefault;
    
    // Progress Bar Customization
    [_circleProgressBar setProgressBarWidth:(customized ? 12.0f : 0)];
    [_circleProgressBar setProgressBarProgressColor:(customized ? [UIColor colorWithRed:0.2 green:0.7 blue:1.0 alpha:0.8] : nil)];
    [_circleProgressBar setProgressBarTrackColor:(customized ? [UIColor colorWithWhite:0.000 alpha:0.800] : nil)];
    
    // Hint View Customization
    [_circleProgressBar setHintViewSpacing:(customized ? 10.0f : 0)];
    [_circleProgressBar setHintViewBackgroundColor:(customized ? [UIColor colorWithWhite:1.000 alpha:0.800] : nil)];
    [_circleProgressBar setHintTextFont:(customized ? [UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:40.0f] : nil)];
    [_circleProgressBar setHintTextColor:(customized ? [UIColor blackColor] : nil)];
    [_circleProgressBar setHintTextGenerationBlock:(customized ? ^NSString *(CGFloat progress) {
        return [NSString stringWithFormat:@"%.0f / 255", progress * 255];
    } : nil)];
    
    // Attributed String
    [_circleProgressBar setHintAttributedGenerationBlock:(state == CustomizationStateCustomAttributed ? ^NSAttributedString *(CGFloat progress) {
        NSString *formatString = [NSString stringWithFormat:@"%.0f / 255", progress * 255];
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:formatString];
        [string addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"AvenirNextCondensed-Heavy" size:40.0f] range:NSMakeRange(0, string.length)];
        
        NSArray *components = [formatString componentsSeparatedByString:@"/"];
        UIColor *valueColor = [UIColor colorWithRed:(0.2f) green:(0.2f) blue:(0.5f + progress * 0.5f) alpha:1.0f];
        [string addAttribute:NSForegroundColorAttributeName value:valueColor range:NSMakeRange(0, [[components firstObject] length])];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange([[components firstObject] length], 1)];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:NSMakeRange([[components firstObject] length] + 1, [[components lastObject] length])];
        return string;
    } : nil)];
}

@end
