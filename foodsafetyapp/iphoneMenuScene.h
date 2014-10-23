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

@interface iphoneMenuScene : SKScene <SKButtonNodeJRTBDelegate, YTPlayerViewDelegate> {
    
    float                   iphoneAddY;
    float                   iphoneAddX;
    
    float                   primaryScale;
    
    SKSpriteNode            *back;
    
    BOOL                    touched;
    
    BOOL                    videoReady;

    float                   videoLength;
    
    SKButtonNodeJRTB        *playButton;
    
    YTPlayerView            *youTubePlayerView;
    
    BOOL                    youTubeVideoReady;
    
    SKSpriteNode            *overlay;
    
    SKEffectNode            *solarSystem;

}

@end
