//
//  ViewController.swift
//  JRAssistant
//
//  Created by Nathan DeGoey on 2020-06-23.
//  Copyright © 2020 Nathan DeGoey. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    

    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    @IBOutlet weak var flipButton: UIButton!

    @IBOutlet weak var completeButton: UIButton!
    
    @IBOutlet weak var scoreStack: UIStackView!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var titleStack: UIStackView!
    
    @IBOutlet weak var warningLabel: UILabel!
    
    
    //TODO: Add score label
    
    var soundPlayer = SoundManager()
    var score:Int = 0
    var completedCardNumbers = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        completeButton.isEnabled = false
        completeButton.alpha = 0
    }

    override func viewDidAppear(_ animated: Bool) {
           
           // play shuffle sound
           soundPlayer.playSound(effect: .shuffle)
       }

    
    // Button for flipping a card over from back to front in order to view its contents
    @IBAction func flipButton(_ sender: Any) {
        
        // play flip sound
        soundPlayer.playSound(effect: .flip)
        
        // TODO: Change 15 to the total number of cards once completed
        let randCardNum = Int.random(in: 1...32)
        
        print(randCardNum)
        // Check if the user has already completed this card
        if !completedCardNumbers.contains(randCardNum) {
            frontImageView.image = UIImage(named: "card\(randCardNum)")
            completedCardNumbers.append(randCardNum)
            
            // hide the warning label if needed
            warningLabel.isHidden = true
        }
        else {
            // show warning label and return
            warningLabel.isHidden = false
            return
        }

        // Flip up animation (use .transition for lots of helpful options
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.5, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        //disable the flip button
        flipButton.isEnabled = false
        flipButton.alpha = 0
        
        //enable the complete button
        completeButton.isEnabled = true
        completeButton.alpha = 1.0
        
        //let the score appear
        scoreStack.isHidden = false
        
        //hide the title stack for the rest of the game
        titleStack.isHidden = true
    }
    
    
    @IBAction func dealButton(_ sender: Any) {
        
        // play dingcorrect sound
        soundPlayer.playSound(effect: .complete)
        
        showAlert(title: "Complete?", message: "Have you completed this card?")
        
    }
    
    
    //MARK: -Alert Functions
    
    func showAlert(title:String, message:String) {
        
        // Create an alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        // Add a button for the user to dismiss it
        let noAction = UIAlertAction(title: "Nope...", style: .default, handler: nil)
        alert.addAction(noAction)
        
        // Add a button for the user to move on to the next card
        // Not sure why the (handler) works I just randomly put that word in
        let yesAction = UIAlertAction(title: "Yup!", style: .default) { (handler) in
            
            // play shuffle sound
            self.soundPlayer.playSound(effect: .shuffle)
            
            //Increase the score by 1
            self.score += 1
            self.scoreLabel.text = String(self.score)
            
            
            // Flip up animation (use .transition for lots of helpful options
            UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.5, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
            
            //disable to complete button
            self.completeButton.isEnabled = false
            self.completeButton.alpha = 0
            
            //enable the flip button
            self.flipButton.isEnabled = true
            self.flipButton.alpha = 1.0
        }
        alert.addAction(yesAction)
        
        // Show the alert
        present(alert, animated: true, completion: nil)
    }
}
