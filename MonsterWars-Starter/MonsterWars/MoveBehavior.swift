//
//  MoveBehavior.swift
//  MonsterWars
//
//  Created by Barresi, Vincent on 5/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import GameplayKit
import SpriteKit

// 1
// You create a GKBehavior subclass here so you can easily configure a set of movement goals.
class MoveBehavior: GKBehavior {
    
    init(targetSpeed: Float, seek: GKAgent, avoid: [GKAgent]) {
        super.init()
        // 2
        // If the speed is less than 0, don’t set any goals as the agent should not move.
        if targetSpeed > 0 {
            // 3
            // To add a goal to your behavior, you use the setWeight(_:forGoal:) method. This allows you to specify a goal, along with a weight of how important it is – larger weight values take priority. In this instance, you set a low priority goal for the agent to reach the target speed.
            setWeight(0.1, forGoal: GKGoal(toReachTargetSpeed: targetSpeed))
            // 4
            // Here you set a medium priority goal for the agent to move toward another agent. You will use this to make your monsters move toward the closest enemy.
            setWeight(0.5, forGoal: GKGoal(toSeekAgent: seek))
            // 5
            // Here you set a high priority goal to avoid colliding with a group of other agents. You will use this to make your monsters stay away from their allies so they are nicely spread out.
            setWeight(1.0, forGoal: GKGoal(toAvoidAgents: avoid, maxPredictionTime: 1.0))
        }
    }
}