//
//  iphoneMenuScene.h
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SKButtonNodeJRTB.h"

#import "YTPlayerView.h"

@interface iphoneMenuScene : SKScene <SKButtonNodeJRTBDelegate, YTPlayerViewDelegate, UIGestureRecognizerDelegate> {
    
    UIActivityIndicatorView     *spinner;
    
    BOOL                        showingSpinner;

    float                   iphoneAddY;
    float                   iphoneAddX;
    
    float                   primaryScale;
    
    SKSpriteNode            *back;
    
    BOOL                    touched;
    
    BOOL                    videoReady;

    float                   videoLength;
    
    SKButtonNodeJRTB        *playButton;

    SKButtonNodeJRTB        *menuButton;
    SKButtonNodeJRTB        *backButton;

    YTPlayerView            *youTubePlayerView;
    
    BOOL                    youTubeVideoReady;
    
    SKSpriteNode            *overlay;
    
    SKEffectNode            *solarSystem;
    
    UIImage                 *screenshot;
    SKSpriteNode            *screenshotView;
    
    BOOL                    menuOut;

}

@end
