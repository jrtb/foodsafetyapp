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

@synthesize screenToggle, video, player, item;

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
        
        if (IS_IPAD) {
            
            switch (screenToggle) {
                
            }
            
        } else {
            
            switch (screenToggle) {
                case MENU: {
                    SKScene *aScene = [iphoneMenuScene sceneWithSize:skView.bounds.size];
                    [skView presentScene:aScene];
                    break;
                }
                
            }
            
        }
        
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];

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
