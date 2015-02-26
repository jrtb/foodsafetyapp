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
#define FS295 157
#define CLINTINTRO 158
#define CAREERS2 159
#define HOWLINGCOW2 160
#define HACCP2 161

@interface GameViewController : UIViewController

@property int screenToggle;

@property SKVideoNode *video;

@property AVQueuePlayer *player;
@property AVPlayerItem *item;

@property int careersSection;
@property int howlingCowSection;

@property int fs295ContentNum;

@property BOOL networkAvailable;

@property NSData *haccp_data;
@property UIWebView *haccp_webView;

@property NSData *instructor_data;
@property UIWebView *instructor_webView;

- (void) replaceTheScene;

- (void) resetVideo: (NSString*) aName;
- (void) killVideo;

@end
