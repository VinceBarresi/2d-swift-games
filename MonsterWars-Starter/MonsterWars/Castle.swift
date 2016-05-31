//
//  Castle.swift
//  MonsterWars
//
//  Created by Barresi, Vincent on 5/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

// 1
// As I mentioned earlier, it’s often convenient to subclass GKEntity for each type of object in your game. The alternative is to create a base GKEntity and dynamically add the types of components you need; but often you want to have a “cookie cutter” for a particular type of object. That is what this is!
class Castle: GKEntity {

    init(imageName: String, team: Team, entityManager: EntityManager) {
        super.init()
    
    // 2
    // At this point, you add just one component to the entity – the sprite component you just created. You’ll be adding more components to this entity soon!
    let spriteComponent = SpriteComponent(texture: SKTexture(imageNamed: imageName))
    addComponent(spriteComponent)
        
    addComponent(TeamComponent(team: team))
    addComponent(CastleComponent())
    addComponent(MoveComponent(maxSpeed: 0, maxAcceleration: 0, radius: Float(spriteComponent.node.size.width / 2), entityManager: entityManager))
    }
    
    
}
