//
//  ViewController.h
//  CircleProgressBar
//
//  Created by Andrew Cherkashin on 3/15/15.
//  Copyright (c) 2015 Eclair. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircleProgressBar;

typedef enum : NSUInteger {
    CustomizationStateDefault = 0,
    CustomizationStateCustom,
    CustomizationStateCustomAttributed,
} CustomizationState;

@interface DemoViewController : UIViewController

@property (weak, nonatomic) IBOutlet CircleProgressBar *circleProgressBar;
@property (weak, nonatomic) IBOutlet UIButton *customizeButton;

- (IBAction)increaseProgress:(id)sender;
- (IBAction)decreaseProgress:(id)sender;
- (IBAction)customizeNext:(id)sender;

@end

