//
//  GameManager.swift
//  TicTacToe
//
//  Created by Aldrich Wingsiong on 7/1/21.
//

import UIKit

protocol GameListener: AnyObject {
    func boardShouldUpdate(_ board: [[Player?]], state: GameState)
}

protocol GameManaging {
    
    var listener: GameListener { get }
    var currentPlayer: Player { get }
    
    func reset() // starts the game and resets values
    func addMove(for player: Player, position: Position)
}

class GameManager: NSObject {
    
    weak var listener: GameListener?
    
    private var board = [[Player?]](repeating: [Player?](repeating: nil, count: 3), count: 3)
    private var lastLoser: Player? // gets first move in next game
    
    private let winningCombinations = [[[1, 1, 1],[0,0,0],[0,0,0]],
                                       [[0, 0, 0],[1,1,1],[0,0,0]],
                                       [[0, 0, 0],[0,0,0],[1,1,1]],
                                       //verticals
                                       [[1, 0, 0],[1,0,0],[1,0,0]],
                                       [[0, 1, 0],[0,1,0],[0,1,0]],
                                       [[0, 0, 1],[0,0,1],[0,0,1]],
                                       //diagonals
                                       [[1, 0, 0],[0,1,0],[0,0,1]],
                                       [[0, 0, 1],[0,1,0],[1,0,0]]]
                                       
                

    
    init(with listener: GameListener?) {
        self.listener = listener
        super.init()
    }
    
    // MARK :- GameManaging
    
    var currentPlayer
        : Player = .O
    
    func reset() {
        board = [[Player?]](repeating: [Player?](repeating: nil, count: 3), count: 3)
        let current = lastLoser ?? .O // assume O always goes first? or should it be the loser of the last round?
        currentPlayer = current
        listener?.boardShouldUpdate(board, state: .inProgress(current))
    }
    
    func addMove(for player: Player, position: Position) {
        // validate input, within grid bounds, and board position is taken already
        guard (0..<3).contains(position.row),
              (0..<3).contains(position.col),
              board[position.row][position.col] == nil else {
            debugPrint("invalid move for player: \(player), at \(position)")
            return // invalid move, let's make sure the UI doesn't allow for this. But just in case
        }
        board[position.row][position.col] = player
        
        // validation
        if checkIfWinner(for: player) {
            listener?.boardShouldUpdate(board, state: .win(player))
            lastLoser = player.nextPlayer
            return
        }
        if checkIfDraw() {
            listener?.boardShouldUpdate(board, state: .draw)
            return
        }

        currentPlayer = player.nextPlayer
        listener?.boardShouldUpdate(board, state: .inProgress(player.nextPlayer))
    }
    
    private func checkIfWinner(for player: Player) -> Bool {
        for w in winningCombinations {
            var counter = 0
            for i in 0 ..< board.endIndex {
                for j in 0 ..< board[0].endIndex {
                    if w[i][j] == 1 && board[i][j] == player {
                        counter += 1
                    }
                }
            }
            if counter == 3 {
                return true
            }
        }
        
        return false
    }
    
    private func checkIfDraw() -> Bool {
        for rows in board {
            for i in rows {
                if i == nil {
                    return false
                }
            }
        }
        return true
    }
}
