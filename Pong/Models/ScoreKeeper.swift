//
//  ScoreKeeper.swift
//  Pong
//
//  Created by Fernando Santillana on 09/11/26.
//

import Foundation

enum Player {
    case human
    case opponent
    
    var other: Player {
        switch self {
        case .human: return .opponent
        case .opponent: return .human
        }
    }
}

struct ScoreKeeper {
    let pointsToWin: Int
    private(set) var humanScore = 0
    private(set) var opponentScore = 0
    
    init(pointsToWin: Int = 7) {
        self.pointsToWin = pointsToWin
    }
    
    var winner: Player? {
        if humanScore >= pointsToWin { return .human }
        if opponentScore >= pointsToWin { return .opponent }
        return nil
    }
    
    var isGameOver: Bool {
        winner != nil
    }
    
    mutating func awardPoint(to player: Player ) {
        guard !isGameOver else { return }
        switch player {
        case .human: humanScore += 1
        case .opponent: opponentScore += 1
        }
    }
    
    mutating func reset() {
        humanScore = 0
        opponentScore = 0
    }
}
