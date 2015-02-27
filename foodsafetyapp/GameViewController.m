//
//  GameViewController.m
//  foodsafetyapp
//
//  Created by jrtb on 10/21/14.
//  Copyright (c) 2014 NC State. All rights reserved.
//

#import "AppDelegate.h"

#import "GameViewController.h"
#import "GameScene.h"

#import "iphoneIntroScene.h"

#import "iphoneMenuScene.h"

#import "iphonePreReqScene.h"

#import "iphoneHowlingCowScene.h"

#import "iphoneHACCPScene.h"

#import "iphoneCareersScene.h"

#import "iphoneFS295Scene.h"

#import "iphoneClintStevensonIntroScene.h"

#import "iphoneCareersScene2.h"

#import "iphoneHowlingCowScene2.h"

#import "iphoneHACCPScene2.h"

#include<unistd.h>
#include<netdb.h>

@implementation SKScene (Unarchive)

+ (instancetype)unarchiveFromFile:(NSString *)file {
    /* Retrieve scene file path from the application bundle */
    NSString *nodePath = [[NSBundle mainBundle] pathForResource:file ofType:@"sks"];
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:nodePath
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SKScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    return scene;
}

@end

@implementation GameViewController

@synthesize screenToggle, video, player, item, careersSection, howlingCowSection, fs295ContentNum, networkAvailable, haccp_data, haccp_webView, instructor_data, instructor_webView, careers1_data, careers1_webView, careers2_data, careers2_webView, careers3_data, careers3_webView,careers4_data, careers4_webView, fs2951_data, fs2951_webView, fs2952_data, fs2952_webView, fs2953_data, fs2953_webView;

- (void) killVideo
{
    [item removeObserver:self forKeyPath:@"status"];
    item = nil;
}

- (void) resetVideo: (NSString*) aName
{
    NSString *resourcePath = [[NSBundle mainBundle] pathForResource:aName ofType:@"mp4"];
    NSURL *url = [NSURL fileURLWithPath:resourcePath];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:url options:nil];
    NSArray *keys     = [NSArray arrayWithObject:@"playable"];
    
    __block NSError *error = nil;
    
    [asset loadValuesAsynchronouslyForKeys:keys completionHandler:^()
     {
         dispatch_async(dispatch_get_main_queue(), ^
                        {
                            
                            AVKeyValueStatus playableStatus = [asset statusOfValueForKey:@"playable" error:&error];
                            switch (playableStatus) {
                                case AVKeyValueStatusLoaded: {
                                    //go on
                                    //printf("loaded\n");
                                    item = nil;
                                    item = [AVPlayerItem playerItemWithAsset:asset];
                                    [player removeAllItems];
                                    [player insertItem:item afterItem:nil];
                                    [item addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
                                    
                                    [video setSize:CGSizeMake(320.0, 160.0)];
                                    
                                    break;
                                }
                                default:
                                    return;
                            }
                            
                        });
     }];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if (object == player.currentItem && [keyPath isEqualToString:@"status"]) {
        if (player.currentItem.status == AVPlayerItemStatusReadyToPlay) {
            
            //printf("video is ready\n");
            
            [video setSize:CGSizeMake(320.0, 160.0)];
            
            [player pause];
            
        }
    }
}

-(void) replaceTheScene
{
    // validate game choices
    
    SKView * skView = (SKView *)self.view;
    if (skView.scene) {
        
        switch (screenToggle) {
            case MENU: {
                SKScene *aScene = [iphoneMenuScene sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case PREREQ: {
                SKScene *aScene = [iphonePreReqScene sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case HOWLINGCOW: {
                SKScene *aScene = [iphoneHowlingCowScene sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case HACCP: {
                SKScene *aScene = [iphoneHACCPScene sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case HACCP2: {
                SKScene *aScene = [iphoneHACCPScene2 sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case CAREERS: {
                SKScene *aScene = [iphoneCareersScene sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case FS295: {
                SKScene *aScene = [iphoneFS295Scene sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case CLINTINTRO: {
                SKScene *aScene = [iphoneClintStevensonIntroScene sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case CAREERS2: {
                SKScene *aScene = [iphoneCareersScene2 sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
            case HOWLINGCOW2: {
                SKScene *aScene = [iphoneHowlingCowScene2 sceneWithSize:skView.bounds.size];
                [skView presentScene:aScene];
                break;
            }
        }
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    careersSection = 1;
    howlingCowSection = 1;
    
    fs295ContentNum = 1;
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    //skView.showsFPS = YES;
    //skView.showsNodeCount = YES;
    /* Sprite Kit applies additional optimizations to improve rendering performance */
    skView.ignoresSiblingOrder = YES;
    
    /*
     // Create and configure the scene.
     GameScene *scene = [GameScene unarchiveFromFile:@"GameScene"];
     scene.scaleMode = SKSceneScaleModeAspectFill;
     */
    
    SKScene *scene;
    
    //if (IS_IPAD)
    //    scene = [IntroScene sceneWithSize:skView.bounds.size];
    //else
    scene = [iphoneIntroScene sceneWithSize:skView.bounds.size];
    
    scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Present the scene.
    [skView presentScene:scene];
    
    player = [[AVQueuePlayer alloc] initWithPlayerItem:[AVPlayerItem playerItemWithAsset:nil]];
    video = [SKVideoNode videoNodeWithAVPlayer:player];
    
    char *hostname;
    struct hostent *hostinfo;
    hostname = "google.com";
    hostinfo = gethostbyname (hostname);
    if (hostinfo == NULL){
        NSLog(@"-> no connection!\n");
        networkAvailable = NO;
    }
    else{
        NSLog(@"-> connection established!\n");
        networkAvailable = YES;
    }
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];

    NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"HACCP" ofType:@"html"];
    NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    haccp_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    haccp_webView = [[UIWebView alloc] init];
    haccp_webView.userInteractionEnabled = YES;
    haccp_webView.backgroundColor = [UIColor clearColor];
    haccp_webView.scalesPageToFit = YES;
    haccp_webView.alpha = 0;
    [haccp_webView loadData:haccp_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:haccp_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"clint_stevenson_intro" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    instructor_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    instructor_webView = [[UIWebView alloc] init];
    instructor_webView.userInteractionEnabled = YES;
    instructor_webView.backgroundColor = [UIColor clearColor];
    instructor_webView.scalesPageToFit = YES;
    instructor_webView.alpha = 0;
    [instructor_webView loadData:instructor_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:instructor_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"Careers1" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    careers1_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    careers1_webView = [[UIWebView alloc] init];
    careers1_webView.userInteractionEnabled = YES;
    careers1_webView.backgroundColor = [UIColor clearColor];
    careers1_webView.scalesPageToFit = YES;
    careers1_webView.alpha = 0;
    [careers1_webView loadData:careers1_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:careers1_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"Careers2" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    careers2_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    careers2_webView = [[UIWebView alloc] init];
    careers2_webView.userInteractionEnabled = YES;
    careers2_webView.backgroundColor = [UIColor clearColor];
    careers2_webView.scalesPageToFit = YES;
    careers2_webView.alpha = 0;
    [careers2_webView loadData:careers2_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:careers2_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"Careers3" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    careers3_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    careers3_webView = [[UIWebView alloc] init];
    careers3_webView.userInteractionEnabled = YES;
    careers3_webView.backgroundColor = [UIColor clearColor];
    careers3_webView.scalesPageToFit = YES;
    careers3_webView.alpha = 0;
    [careers3_webView loadData:careers3_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:careers3_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"Careers4" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    careers4_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    careers4_webView = [[UIWebView alloc] init];
    careers4_webView.userInteractionEnabled = YES;
    careers4_webView.backgroundColor = [UIColor clearColor];
    careers4_webView.scalesPageToFit = YES;
    careers4_webView.alpha = 0;
    [careers4_webView loadData:careers4_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:careers4_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"FS295-1" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    fs2951_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    fs2951_webView = [[UIWebView alloc] init];
    fs2951_webView.userInteractionEnabled = YES;
    fs2951_webView.backgroundColor = [UIColor clearColor];
    fs2951_webView.scalesPageToFit = YES;
    fs2951_webView.alpha = 0;
    [fs2951_webView loadData:fs2951_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:fs2951_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"FS295-2" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    fs2952_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    fs2952_webView = [[UIWebView alloc] init];
    fs2952_webView.userInteractionEnabled = YES;
    fs2952_webView.backgroundColor = [UIColor clearColor];
    fs2952_webView.scalesPageToFit = YES;
    fs2952_webView.alpha = 0;
    [fs2952_webView loadData:fs2952_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:fs2952_webView];

    htmlFile = [[NSBundle mainBundle] pathForResource:@"FS295-3" ofType:@"html"];
    htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
    fs2953_data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    fs2953_webView = [[UIWebView alloc] init];
    fs2953_webView.userInteractionEnabled = YES;
    fs2953_webView.backgroundColor = [UIColor clearColor];
    fs2953_webView.scalesPageToFit = YES;
    fs2953_webView.alpha = 0;
    [fs2953_webView loadData:fs2953_data MIMEType:@"text/html" textEncodingName:@"utf-8" baseURL:baseURL];
    [self.view addSubview:fs2953_webView];

}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
