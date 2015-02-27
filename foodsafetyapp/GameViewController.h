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

@property NSData *careers1_data;
@property UIWebView *careers1_webView;

@property NSData *careers2_data;
@property UIWebView *careers2_webView;

@property NSData *careers3_data;
@property UIWebView *careers3_webView;

@property NSData *careers4_data;
@property UIWebView *careers4_webView;

@property NSData *fs2951_data;
@property UIWebView *fs2951_webView;

@property NSData *fs2952_data;
@property UIWebView *fs2952_webView;

@property NSData *fs2953_data;
@property UIWebView *fs2953_webView;

- (void) replaceTheScene;

- (void) resetVideo: (NSString*) aName;
- (void) killVideo;

@end
