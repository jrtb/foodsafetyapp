//
//  GameViewController.h
//  foodsafetyapp
//

//  Copyright (c) 2014 NC State. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>

#import "SoundManager.h"

#define INTRO 151
#define MENU 152
#define PREREQ 153
#define HOWLINGCOW 154
#define HACCP 155
#define CAREERS 156

@interface GameViewController : UIViewController

@property int screenToggle;

@property SKVideoNode *video;

@property AVQueuePlayer *player;
@property AVPlayerItem *item;

- (void) replaceTheScene;

- (void) resetVideo: (NSString*) aName;
- (void) killVideo;

@end
