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
    CCNode *_levelNode;
    CCNode *_contentNode;
    CCNode *_pullbackNode;
    CCNode *_mouseJointNode;
    CCPhysicsJoint *_mouseJoint;
}

//called when CCB file loaded
- (void)didLoadFromCCB {
    //tell scene to accept touches
    self.userInteractionEnabled = true;
    CCScene *level = [CCBReader loadAsScene:@"Levels/Level1"];
    [_levelNode addChild:level];
    
    //visualize physics bodies and joints
    _physicsNode.debugDraw = true;
    //nothing will collide with invisible nodes
    _pullbackNode.physicsBody.collisionMask = @[];
    _mouseJointNode.physicsBody.collisionMask = @[];
}

//called for every touch in scene
- (void)touchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    
    //start catapult dragging when touch inside catapult occurs
    if (CGRectContainsPoint([_catapultArm boundingBox], touchLocation)) {
        //move mouseJointNode to touch position
        _mouseJointNode.position = touchLocation;
        
        //setup spring between mouseJointNode and catapultArm
        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 14) anchorB:ccp(14, 150) restLength:0.f stiffness:3000.f damping:150.f];
//        _mouseJoint = [CCPhysicsJoint connectedSpringJointWithBodyA:_mouseJointNode.physicsBody bodyB:_catapultArm.physicsBody anchorA:ccp(0, 0) anchorB:ccp(14, 150) restLength:0.f stiffness:3000.f damping:150.f];
    }
}

- (void)touchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    //whenever touches moves, update position of mouseJointNode to touch position
    CGPoint touchLocation = [touch locationInNode:_contentNode];
    _mouseJointNode.position = touchLocation;
}

- (void)releaseCatapult {
    if (_mouseJoint != nil) {
        //releases joint and lets catapult snap back
        [_mouseJoint invalidate];
        _mouseJoint = nil;
    }
}

- (void)touchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
    //when touches end (user releases finger), release catapult
    [self releaseCatapult];
}

- (void)touchCancelled:(UITouch *)touch withEvent:(UIEvent *)event {
    //when touches cancel (user moves finger off screen) release catapult
    [self releaseCatapult];
}

- (void)launchPenguin {
    //load Penguin.ccb setup in Spritebuilder
    CCNode* penguin = [CCBReader load:@"Penguin"];
    //position penguin at bowl of catapult
    penguin.position = ccpAdd(_catapultArm.position, ccp(16, 50));
    
    //add penguin to physicsNode of scene (because it has physics enabled)
    [_physicsNode addChild:penguin];
    
    //manually create and apply launch force to penguin
    CGPoint launchDirection = ccp(1, 0);
    CGPoint force = ccpMult(launchDirection, 8000);
    [penguin.physicsBody applyForce:force];
    
    //make sure camera follows penguin
    self.position = ccp(0, 0);
    CCActionFollow *follow = [CCActionFollow actionWithTarget:penguin worldBoundary:self.boundingBox];
    [_contentNode runAction:follow];
}

- (void)retry {
    //reload level
    [[CCDirector sharedDirector] replaceScene:[CCBReader loadAsScene:@"Gameplay"]];
}

@end
