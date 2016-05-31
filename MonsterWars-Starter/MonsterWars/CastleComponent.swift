//
//  CastleComponent.swift
//  MonsterWars
//
//  Created by Barresi, Vincent on 5/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit

class CastleComponent: GKComponent {
    
    // 1
    // This stores the number of coins in the castle, and the last time coins were earned.
    var coins = 0
    var lastCoinDrop = NSTimeInterval(0)
    
    override init() {
        super.init()
    }
    
    // 2
    // This method will be called on each frame of the game. Note this is not called by default; you have to do a little bit of setup to get this to happen, which you’ll do shortly.
    override func updateWithDeltaTime(seconds:NSTimeInterval) {
        super.updateWithDeltaTime(seconds)
        
        // 3
        // This is a bit of code to spawn coins periodically.
        let coinDropInterval = NSTimeInterval(0.5)
        let coinsPerInterval = 10
        if (CACurrentMediaTime() - lastCoinDrop > coinDropInterval) {
            lastCoinDrop = CACurrentMediaTime()
            coins += coinsPerInterval
        }
    }
}
