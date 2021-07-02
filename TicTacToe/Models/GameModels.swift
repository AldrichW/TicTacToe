//
//  GameModels.swift
//  TicTacToe
//
//  Created by Aldrich Wingsiong on 7/1/21.
//

import Foundation

enum Player: String {
    case O
    case X
    
    var nextPlayer: Player {
        switch self {
        case .O:
            return .X // who's coming up next
        case .X:
            return .O
        }
    }
}

enum GameState {
    case win(Player) // player has won
    case draw //game is done with a draw
    case inProgress(Player) // player here indicates who's turn it is
}

struct Position {
    let row: Int
    let col: Int
}
