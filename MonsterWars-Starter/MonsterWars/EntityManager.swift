//
//  EntityManager.swift
//  MonsterWars
//
//  Created by Barresi, Vincent on 5/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import Foundation
import SpriteKit
import GameplayKit

class EntityManager {
    
    var toRemove = Set<GKEntity>()
    
    lazy var componentSystems: [GKComponentSystem] = {
        let castleSystem = GKComponentSystem(componentClass: CastleComponent.self)
        let moveSystem = GKComponentSystem(componentClass: MoveComponent.self)
        return [castleSystem, moveSystem]
    }()
    
    // 1
    // This class will keep a reference to all entities in the game, along with the scene.
    var entities = Set<GKEntity>()
    let scene: SKScene
    
    // 2
    // This is a simple initializer that stores the scene in the property you created.
    init(scene: SKScene) {
        self.scene = scene
    }
    
    // 3
    // This is a helper function that you will call when you want to add an entity to your game. It adds it to the list of entities, and then check to see if the entity has a SpriteComponent. If it does, it adds the sprite’s node to the scene.
    func add(entity: GKEntity) {
        entities.insert(entity)
        
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            scene.addChild(spriteNode)
        }
        for componentSystem in componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
    // 4
    // This is a helper function that you will call when you want to remove an entity from your game. This does the opposite of the add(_:) method; if the entity has a SpriteComponent, it removes the node from the scene, and it also removes the entity from the list of entities.
    func remove(entity: GKEntity) {
        if let spriteNode = entity.componentForClass(SpriteComponent.self)?.node {
            spriteNode.removeFromParent()
        }
        
        entities.remove(entity)
        toRemove.insert(entity)
    }
    
    func update(deltaTime: CFTimeInterval) {
        // 1
        // Here you loop through all the component systems in the array and call updateWithDeltaTime(_:) on each one. This causes each component system to call updateWithDeltaTime(_:) on each component in their system in turn.
        
        //This actually demonstrates the whole purpose and benefit of using GKComponentSystem. The way this is set up, components are updated one system at a time. In games, it’s often convenient to have precise control over the ordering of the processing of each system (physics, rendering, etc).
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
        
        // 2
        // Here you loop through anything in the toRemove array and remove those entities from the component systems.
        for curRemove in toRemove {
            for componentSystem in componentSystems {
                componentSystem.removeComponentWithEntity(curRemove)
            }
        }
        toRemove.removeAll()
    }
    
    func castleForTeam(team: Team) -> GKEntity? {
        for entity in entities {
            if let teamComponent = entity.componentForClass(TeamComponent.self),
                _ = entity.componentForClass(CastleComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
        }
        return nil
    }
    
    func spawnQuirk(team: Team) {
        // 1
        // Monsters should be spawned near their team’s castle. To do this, you need the position of the castle’s sprite, so this is some code to look up that information in a dynamic way.
        guard let teamEntity = castleForTeam(team),
            teamCastleComponent = teamEntity.componentForClass(CastleComponent.self),
            teamSpriteComponent = teamEntity.componentForClass(SpriteComponent.self) else {
                return
        }
        
        // 2
        // This checks to see if there are enough coins to spawn the monster, and if so subtracts the appropriate coins and plays a sound.
        if teamCastleComponent.coins < costQuirk {
            return
        }
        
        teamCastleComponent.coins -= costQuirk
        scene.runAction(SoundManager.sharedInstance.soundSpawn)
        
        // 3
        // This is the code to create a Quick entity and position it near the castle (at a random y-value).
        let monster = Quirk(team: team, entityManager: self)
        if let spriteComponent = monster.componentForClass(SpriteComponent.self) {
            spriteComponent.node.position = CGPoint(x: teamSpriteComponent.node.position.x, y: CGFloat.random(min: scene.size.height * 0.25, max: scene.size.height * 0.75))
            spriteComponent.node.zPosition = 2
        }
        add(monster)
    }
    
    func entitiesForTeam(team: Team) -> [GKEntity] {
        return entities.flatMap{ entity in
            if let teamComponent = entity.componentForClass(TeamComponent.self) {
                if teamComponent.team == team {
                    return entity
                }
            }
            return nil
        }
    }
    
    func moveComponentsForTeam(team: Team) -> [MoveComponent] {
        let entities = entitiesForTeam(team)
        var moveComponents = [MoveComponent]()
        for entity in entities {
            if let moveComponent = entity.componentForClass(MoveComponent.self) {
                moveComponents.append(moveComponent)
            }
            
        }
        return moveComponents
    }
    
}