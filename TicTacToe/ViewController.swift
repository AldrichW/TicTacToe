//
//  ViewController.swift
//  TicTacToe
//
//  Created by Aldrich Wingsiong on 7/1/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var gameCells: [UIButton]!
    @IBOutlet var playerTurnTitle: UILabel!
    @IBOutlet var resetButton: UIButton!
    
    private lazy var gameManager: GameManager = {
        let manager = GameManager(with: self)
        return manager
    }()
    
    private var board: [[Player?]] = [[Player?]](repeating: [Player?](repeating: nil, count: 3), count: 3) {
        didSet {
            updateGameCells()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        gameManager.reset() // initialize
    }
    
    @IBAction func buttonPressed(sender: UIButton) {
        
        guard (0 ..< 9).contains(sender.tag) else {
            return
        }
        let row = sender.tag / 3
        let col = sender.tag % 3
        let position = Position(row: row, col: col)
        
        gameManager.addMove(for: gameManager.currentPlayer, position: position)
        
    }
    
    @IBAction func resetButtonPressed(sender: Any) {
        gameManager.reset()
    }
    
    private func updateGameCells() {
        for i in 0 ..< board.endIndex {
            for j in 0 ..< board[0].endIndex {
                let index = (i * 3) + j
                gameCells[index].setTitle(board[i][j]?.rawValue ?? "", for: .normal)
                gameCells[index].isUserInteractionEnabled = board[i][j] == nil
            }
        }
    }
}

extension ViewController: GameListener {
    func boardShouldUpdate(_ board: [[Player?]], state: GameState) {
        self.board = board
        switch state {
        case .draw, .win:
            showAlert(for: state)
        case .inProgress(let player):
            playerTurnTitle.text = "Player \(player.rawValue)'s turn"
        }
    }
    
    private func showAlert(for gameState: GameState) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Play Again", style: .default) { _ in
            self.gameManager.reset()
        }
        
        switch gameState {
        case .draw:
        alert.title = "It's a draw!"
        case .win(let player):
        alert.title = "Player \(player.rawValue) Wins!"
        case .inProgress(_):
            fatalError("Should not hit this state")
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
}
