////
////  File.swift
////  ConnectFourMinimax
////
////  Created by Nathan on 9/18/24.
////
//
//import Foundation
//
//let BOT_PIECE = 1
//let PLAYER_PIECE = 2
//
//func minimax(board: [[Int]], depth: Int, alpha: Int, beta: Int, maximizingPlayer: Bool) -> (column: Int?, score: Int) {
//    let validLocations = getValidLocations(board: board)
//    
//    let isTerminal = isTerminalNode(board: board)
//    if depth == 0 || isTerminal {
//        if isTerminal {
//            // Weight the bot winning really high
//            if winningMove(board: board, piece: BOT_PIECE) {
//                return (nil, 9999999)
//            } else if winningMove(board: board, piece: PLAYER_PIECE) {
//                // Weight the human winning really low
//                return (nil, -9999999)
//            } else {
//                // No more valid moves
//                return (nil, 0)
//            }
//        } else {
//            // Return the bot's score
//            return (nil, scorePosition(board: board, piece: BOT_PIECE))
//        }
//    }
//    
//    if maximizingPlayer {
//        var value = -9999999
//        var column: Int? = validLocations.randomElement() // Randomize column to start
//
//        for col in validLocations {
//            let row = getNextOpenRow(board: board, column: col)
//            var bCopy = board
//            // Drop a piece in the temporary board and record score
//            dropPiece(board: &bCopy, row: row, column: col, piece: BOT_PIECE)
//            let newScore = minimax(board: bCopy, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: false).score
//            
//            if newScore > value {
//                value = newScore
//                column = col
//            }
//            let newAlpha = max(alpha, value)
//            if newAlpha >= beta {
//                break
//            }
//        }
//        return (column, value)
//        
//    } else { // Minimizing player
//        var value = 9999999
//        var column: Int? = validLocations.randomElement() // Randomize column to start
//
//        for col in validLocations {
//            let row = getNextOpenRow(board: board, column: col)
//            var bCopy = board
//            // Drop a piece in the temporary board and record score
//            dropPiece(board: &bCopy, row: row, column: col, piece: PLAYER_PIECE)
//            let newScore = minimax(board: bCopy, depth: depth - 1, alpha: alpha, beta: beta, maximizingPlayer: true).score
//            
//            if newScore < value {
//                value = newScore
//                column = col
//            }
//            let newBeta = min(beta, value)
//            if alpha >= newBeta {
//                break
//            }
//        }
//        return (column, value)
//    }
//}
