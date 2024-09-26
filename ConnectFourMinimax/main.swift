//
//  main.swift
//  ConnectFour
//
//  Created by Nathan on 9/16/24.
//  Adapted from https://roboticsproject.readthedocs.io/en/latest/ConnectFourAlgorithm.html
//

import Foundation

class ConnectFour {
    var board = [
        [" . ", " . ", " . ", " . ", " . ", " . ", " . "], // Row 0
        [" . ", " . ", " . ", " . ", " . ", " . ", " . "], // Row 1
        [" . ", " . ", " . ", " . ", " . ", " . ", " . "], // Row 2
        [" . ", " . ", " . ", " . ", " . ", " . ", " . "], // Row 3
        [" . ", " . ", " . ", " . ", " . ", " . ", " . "], // Row 4
        [" . ", " . ", " . ", " . ", " . ", " . ", " . "], // Row 5
    ]
    
    let columnLabels = " 1  2  3  4  5  6  7 "
    
    var currentPlayer = 1
    
    var gameOver = false
    
    func printBoard() {
        let reversedBoard = board.reversed()
        for row in reversedBoard {
            var rowString = ""
            for cell in row {
                rowString += cell
            }
            print(rowString)
        }
        print(columnLabels)
    }
    
    
    func getValidLocations() -> [Int] {
        var validLocations: [Int] = []
        
        for col in (0...6) {
            if isValidLocation(board: board, col: col) {
                //            if board[5][col] == " . " {
                validLocations.append(col)
            }
        }
        return validLocations
    }
    
    
    func isValidLocation(board: [[String]], col: Int) -> Bool {
        return board[5][col] == " . "
    }
    
    
    func getNextOpenRow(board: [[String]], col: Int) -> Int? {
        for row in (0...5) {
            if board[row][col] == " . " {
                return row
            }
        }
        return nil
    }
    
    
    func dropPiece(board: inout [[String]], row: Int, col: Int, piece: String) {
        board[row][col] = piece
    }
    
    
    func getIntegerInput() -> Int {
        while true {
            print("Which column would you like to drop your piece in?")
            
            if let input = readLine() {
                if let column = Int(input) {
                    return column
                } else {
                    print("Please enter a valid column to play in. (1-7)")
                }
            }
        }
    }
    
    
    func getSelectedColumn() -> Int {
        let validColumns = getValidLocations()
        
        while true {
            var requestedColumn = getIntegerInput()
            while !validColumns.contains(where: { $0 == requestedColumn - 1 }) {
                print("Column not available. Please select an empty column.")
                requestedColumn = getIntegerInput()
            }
            return requestedColumn - 1
        }
    }
    
    
    func nextPlayer(currentPlayer: Int) -> Int {
        currentPlayer == 1 ? 2 : 1
    }
    
    
    func printCurrentPlayer(currentPlayer: Int) {
        currentPlayer == 1 ? print("\nPlayer 1: ") : print("\nPlayer 2: ")
    }
    
    
    func playRound(currentPlayer: Int) {
        if currentPlayer == 1 {
            printBoard()
            printCurrentPlayer(currentPlayer: currentPlayer)
            let column = getSelectedColumn()
            let row = getNextOpenRow(board: board, col: column)
            let piece = currentPlayer == 1 ? " O " : " X "
            dropPiece(board: &board, row: row!, col: column, piece: piece)
            
            // Check for win
            if checkForWin(board: board, piece: piece) {
                gameOver = true
                printBoard()
                print("Player \(currentPlayer) wins! Congratulations!")
            }
            
            self.currentPlayer = nextPlayer(currentPlayer: currentPlayer)
        } else {
            // BOT TAKES TURN USING MINIMAX ALGORITHM
            let piece = currentPlayer == 1 ? " O " : " X "
            let (col, minimaxScore) = minimax(board: board, depth: 4, alpha: -9999999, beta: 9999999, maximizingPlayer: true)
                print("Bot chose column \(col! + 1)")
                
                if isValidLocation(board: board, col: col ?? 9) {
                    let row = getNextOpenRow(board: board, col: col!)
                    dropPiece(board: &board, row: row!, col: col!, piece: " X ")
                    // Check for win
                    if checkForWin(board: board, piece: piece) {
                        gameOver = true
                        printBoard()
                        print("Computer wins! You lose!")
                    }
                    print("")
                    self.currentPlayer = nextPlayer(currentPlayer: currentPlayer)
                }
            
        }
    }
    
    
    func checkForWin(board: [[String]], piece: String) -> Bool {
        // Horizontal
        for c in (0...3) {
            for r in (0...5) {
                if board[r][c] == piece && board[r][c + 1] == piece && board[r][c + 2] == piece && board[r][c + 3] == piece {
                    return true
                }
            }
        }
        
        // Vertical
        for c in (0...6) {
            for r in (0...2) {
                if board[r][c] == piece && board[r + 1][c] == piece && board[r + 2][c] == piece && board[r + 3][c] == piece {
                    return true
                }
            }
        }
        
        // Diagonal upwards
        for c in (0...3) {
            for r in (0...2) {
                if board[r][c] == piece && board[r + 1][c + 1] == piece && board[r + 2][c + 2] == piece && board[r + 3][c + 3] == piece {
                    return true
                }
            }
        }
        
        // Diagonal downwards
        for c in (0...3) {
            for r in (3...5) {
                if board[r][c] == piece && board[r - 1][c + 1] == piece && board[r - 2][c + 2] == piece && board[r - 3][c + 3] == piece {
                    return true
                }
            }
        }
        return false
    }
    
    
    func scorePosition(board: [[String]], piece: String) -> Int {
        var score = 0
        
        // Score the center column. 3 Points for every piece in column 3
        let columnCount = 7
        let centerColumn = columnCount / 2
        let centerArray = board.map { $0[centerColumn] }
        let centerCount = centerArray.filter { $0 == piece }.count
        score += centerCount * 3
        
        // Score horizontal positions
        for r in (0...5) {
            let rowArray = board[r]
            for c in (0...3) {
                let window = Array(rowArray[c..<c + 4])
                score += evaluateWindow(window: window, piece: piece)
            }
        }
        
        // Score vertical positions
        for c in (0...5) {
            let colArray = (0...5).map { row in board[row][c] }
            for r in (0...2) {
                let window = Array(colArray[r..<r + 4])
                score += evaluateWindow(window: window, piece: piece)
            }
        }
        
        // Score upwards diagonals
        for r in (0...2) {
            for c in (0...3) {
                let window = (0...3).map { i in board[r + i][c + i] }
                score += evaluateWindow(window: window, piece: piece)
            }
        }
        
        // Score downwards diagonals
        for r in (0...2) {
            for c in (0...3) {
                let window = (0...3).map { i in board[r + 3 - i][c + i] }
                score += evaluateWindow(window: window, piece: piece)
            }
        }
        
        return score
    }
    
    
    func isTerminalNode(board: [[String]]) -> Bool {
        checkForWin(board: board, piece: " X ") || checkForWin(board: board, piece: " O ") || getValidLocations().count == 0
    }
    
    
    func evaluateWindow(window: [String], piece: String) -> Int {
        var score = 0
        
        var oppPiece = piece == " X " ? " O " : " X "
        
        if window.filter({ $0 == piece }).count == 4 {
            score += 100
        } else if window.filter({ $0 == piece }).count == 3 && window.filter({ $0 == " . " }).count == 1 {
            score += 5
        } else if window.filter({ $0 == piece }).count == 2 && window.filter({ $0 == " . " }).count == 2 {
            score += 2
        }
        
        if window.filter({ $0 == oppPiece }).count == 3 && window.filter({ $0 == " . " }).count == 1 {
            score -= 4
        }
        
        return score
    }
    
    
    func minimax(board: [[String]], depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool) -> (column: Int?, score: Int) {
        let validLocations = getValidLocations()
        let isTerminal = isTerminalNode(board: board)
        
        if depth == 0 || isTerminal {
            if isTerminal {
                if checkForWin(board: board, piece: " X ") {
                    return (nil, 9999999)
                }
                
                else if checkForWin(board: board, piece: " O ") {
                    return (nil, -9999999)
                }
                
                else {
                    return (nil, 0)
                }
            }
            
            else {
                return (nil, scorePosition(board: board, piece: " X "))
            }
        }
        
        if maximizingPlayer {
            var value = -9999999
            var column: Int? = validLocations.randomElement()
            var alpha = alpha
            
            for col in validLocations {
                if let row = getNextOpenRow(board: board, col: col) {
                    var boardCopy = board
                    dropPiece(board: &boardCopy, row: row, col: col, piece: " X ")
                    let newScore = minimax(board: boardCopy, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: false).1
                    if newScore > value {
                        value = newScore
                        column = col
                    }
                    alpha = max(alpha, value)
                    if alpha >= beta {
                        break
                    }
                }
            }
            return (column, value)
        } else {
            var value = 9999999
            var column: Int? = validLocations.randomElement()
            var beta = beta
            
            for col in validLocations {
                if let row = getNextOpenRow(board: board, col: col) {
                    var boardCopy = board
                    dropPiece(board: &boardCopy, row: row, col: col, piece: " O ")
                    let newScore = minimax(board: boardCopy, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: true).1
                    if newScore < value {
                        value = newScore
                        column = col
                    }
                    beta = min(beta, value)
                    if alpha >= beta {
                        break
                    }
                }
            }
            return (column, value)
        }
    }
}




var game = ConnectFour()

while !game.gameOver {
    game.playRound(currentPlayer: game.currentPlayer)
}

