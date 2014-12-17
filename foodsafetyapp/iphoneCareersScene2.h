//
//  iphoneCareersScene2.h
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "SKButtonNodeJRTB.h"

#import "YTPlayerView.h"

@interface iphoneCareersScene2 : SKScene <SKButtonNodeJRTBDelegate, YTPlayerViewDelegate, UIGestureRecognizerDelegate, UIWebViewDelegate> {
    
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
    SKButtonNodeJRTB        *navBackButton;
    
    YTPlayerView            *youTubePlayerView;
    
    BOOL                    youTubeVideoReady;
    
    SKSpriteNode            *overlay;
    
    SKEffectNode            *solarSystem;
    
    UIImage                 *screenshot;
    SKSpriteNode            *screenshotView;
    
    BOOL                    menuOut;
    
    UIWebView               *webView;
    
    UIActivityIndicatorView     *spinner;
    
    BOOL                        showingSpinner;
    
}

@end
