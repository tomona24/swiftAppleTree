//
//  ViewController.swift
//  ApplePie
//
//  Created by Tomona Sako on 2020/04/23.
//  Copyright © 2020 Tomona Sako. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let listOfWords = ["banana", "apple", "orange"]
    let incorrectMovesAllowed = 7
    var totalWins = 0 {
        didSet {
            newRound()
        }
    }
    var totalLosses = 0 {
        didSet {
            newRound()
        }
    }
    var finishQuiz: [Int] = []
    var currentGame: Game!
    
    struct Game {
        var word: String
        var incorrectMovesRemaining: Int
        var guessedLetters: [Character] = []
        var hiddenWord: String {
               var guessedWord: String = ""
               for letter in word {
                if guessedLetters.contains(letter){
                    guessedWord += "\(letter)"
                } else {
                    guessedWord += "_"
                }
               }
               return guessedWord
           }
        
        mutating func playerGuessed(letter: Character) {
            if !word.contains(letter) {
                incorrectMovesRemaining -= 1
            } else {
                for l in word {
                    if l == letter {
                        guessedLetters.append(letter)
                    }
                }
            }
        }
    }
    
    @IBOutlet var treeImageView: UIImageView!
    @IBOutlet var correctWordLabel: UILabel!
    @IBOutlet var scoreLabel: UILabel!
    @IBOutlet var letterButtons: [UIButton]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        newRound()
    }

    func newRound() {
        if listOfWords.count != (totalWins + totalLosses) {
        enableLetterButtons(true)
        var newWordNum = Int.random(in: 0...listOfWords.count - 1)
        while finishQuiz.contains(newWordNum) {
            newWordNum = Int.random(in: 0...listOfWords.count - 1)
            }
            currentGame = Game(word: listOfWords[newWordNum], incorrectMovesRemaining: incorrectMovesAllowed)
            finishQuiz.append(newWordNum)
            updateUI()
        } else {
            enableLetterButtons(false)
        }
    }
    
    func updateUI() {
        scoreLabel.text = "Wins: \(totalWins), Losses: \(totalLosses)"
        treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
        var letters = [String]()
        for letter in currentGame.hiddenWord {
            letters.append(String(letter))
        }
        correctWordLabel.text = letters.joined(separator: " ")
    }
    
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        sender.isEnabled = false;
        let letterString: String = sender.title(for: .normal)!
        let letter = Character(letterString.lowercased())
        currentGame.playerGuessed(letter: letter)
        updateGameState()
    }
    
    func updateGameState() {
        if currentGame.incorrectMovesRemaining == 0 {
            totalLosses += 1
        } else if currentGame.guessedLetters.count == currentGame.word.count {
            totalWins += 1
        }
        updateUI()
    }
    
    func enableLetterButtons(_ enable: Bool) {
        for button in letterButtons {
            button.isEnabled = enable
        }
    }
}


