//
//  MoveComponenr.swift
//  MonsterWars
//
//  Created by Barresi, Vincent on 5/30/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

// 1
// Remember that GKAgent2D is a subclass of GKComponent. You subclass it here so customize its functionality. Also, you implement GKAgentDelegate – this is how you’ll match up the position of the sprite with the agent’s position.

class MoveComponent: GKAgent2D, GKAgentDelegate {
    
    // 2
    // You’ll need a reference to the entityManger so you can access the other entities in the game. For example, you need to know about your closest enemy (so you can seek to it) and your full list of allies (so you can spread apart from them).
    let entityManager: EntityManager
    
    // 3
    // GKAgent2D has various properties like max speed, acceleration, and so on. Here you configure them based on passed in parameters. You also set this class as its own delegate, and make the mass very small so objects respond to direction changes more easily.
    init(maxSpeed: Float, maxAcceleration: Float, radius: Float, entityManager: EntityManager) {
        self.entityManager = entityManager
        super.init()
        delegate = self
        self.maxSpeed = maxSpeed
        self.maxAcceleration = maxAcceleration
        self.radius = radius
        self.mass = 0.01
    }
    
    // 4
    // Before the agent updates its position, you set the position of the agent to the sprite component’s position. This is so that agents will be positioned in the correct spot to start. Note there’s some funky conversions going on here – GameplayKit uses float2 instead of CGPoint, gah!
    func agentWillUpdate(agent: GKAgent) {
        guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else {
            return
        }
        
        position = float2(spriteComponent.node.position)
    }
    
    // 5
    // Similarly, after the agent updates its position agentDidUpdate(_:) is called. You set the sprite’s position to match the agent’s position.
    func agentDidUpdate(agent: GKAgent) {
        guard let spriteComponent = entity?.componentForClass(SpriteComponent.self) else {
            return
        }
        
        spriteComponent.node.position = CGPoint(position)
    }
    
    func closestMoveComponentForTeam(team: Team) -> GKAgent2D? {
        var closestMoveComponent: MoveComponent? = nil
        var closestDistance = CGFloat(0)
        
        let enemyMoveComponents = entityManager.moveComponentsForTeam(team)
        for enemyMoveComponent in enemyMoveComponents {
            let distance = (CGPoint(enemyMoveComponent.position) - CGPoint(position)).length()
            if closestMoveComponent == nil || distance < closestDistance {
                closestMoveComponent = enemyMoveComponent
                closestDistance = distance
            }
        }
        return closestMoveComponent
    }
    
    override func updateWithDeltaTime(seconds: NSTimeInterval) {
        
        super.updateWithDeltaTime(seconds)
        
        // 1 
        // Here you find the team component for the current entity.
        guard let entity = entity,
            let teamComponent = entity.componentForClass(TeamComponent.self) else {
                return
        }
        
        // 2
        // Here you use the helper method you wrote to find the closest enemy.
        guard let enemyMoveComponent = closestMoveComponentForTeam(teamComponent.team.oppositeTeam()) else {
            return
        }
        
        // 3
        // Here you use the helper method you wrote to find all your allies’s move components.
        let alliedMoveComponents = entityManager.moveComponentsForTeam(teamComponent.team)
        
        // 4
        // Finally, you reset the behavior with the updated values.
        behavior = MoveBehavior(targetSpeed: maxSpeed, seek: enemyMoveComponent, avoid: alliedMoveComponents)
        
    }
}
