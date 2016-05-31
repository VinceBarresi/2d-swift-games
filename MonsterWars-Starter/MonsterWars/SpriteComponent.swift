//
//  SpriteComponent.swift
//  MonsterWars
//
//  Created by Barresi, Vincent on 5/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

// 1
// To use GameplayKit, you must import it just like you do for SpriteKit.
import SpriteKit
import GameplayKit

// 2
// To create a GameplayKit component, simply subclass GKComponent.
class SpriteComponent: GKComponent {
    
    // 3
    // This component will keep track of a sprite, so you declare a property for one here.
    let node: SKSpriteNode
    
    // 4
    // This is a simple initializer that initializes the sprite based on a texture you pass in.
    init(texture: SKTexture) {
        node = SKSpriteNode(texture: texture, color: SKColor.whiteColor(), size: texture.size())
    }
}