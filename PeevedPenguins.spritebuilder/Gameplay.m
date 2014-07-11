//
//  Gameplay.m
//  PeevedPenguins
//
//  Created by Carmine on 7/10/14.
//  Copyright (c) 2014 Apportable. All rights reserved.
//

#import "Gameplay.h"

@implementation Gameplay {
    CCPhysicsNode *_physicsNode;
    CCNode *_catapultArm;
}

//called when CCB file loaded
- (void)didLoadFromCCB {
    //tell scene to accept touches
    self.userInteractionEnabled = true;
}

//called for every touch in scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    [self launchPenguin];
}

- (void)launchPenguin {
    //load Penguin.ccb setup in Spritebuilder
    CCNode* penguin = [CCBReader load:@"Penguim"];
    //position penguin at bowl of catapult
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
    
    //add penguin to physicsNode of scene (because it has physics enabled)
    [_physicsNode addChild:penguin];
    
    //manually create and apply launch force to penguin
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
}

@end
