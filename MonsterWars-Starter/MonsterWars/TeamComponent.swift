//
//  TeamComponent.swift
//  MonsterWars
//
//  Created by Barresi, Vincent on 5/29/16.
//  Copyright © 2016 Razeware LLC. All rights reserved.
//

import SpriteKit
import GameplayKit


// 1
// This is an enumeration to keep track of the two teams in this game – team 1 and team 2. It also has a helper method to return the opposite team, which will come in handy later.
enum Team: Int {
    case Team1 = 1
    case Team2 = 2

    static let allValues = [Team1, Team2]
    
    func oppositeTeam() -> Team {
        switch self {
        case .Team1:
            return .Team2
        case .Team2:
            return .Team2
        }
    }
}

// 2
// This is a very simple component that simply keeps track of the team for this entity.
class TeamComponent: GKComponent {
    let team: Team
    
    init(team: Team) {
        self.team = team
        super.init()
    }
}
