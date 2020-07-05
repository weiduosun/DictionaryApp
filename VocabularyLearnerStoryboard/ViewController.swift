//
//  ViewController.swift
//  VocabularyLearnerStoryboard
//
//  Created by Weiduo Sun on 7/4/20.
//  Copyright © 2020 Weiduo Sun. All rights reserved.
//

import UIKit

class ViewController: UIViewController, QuizBrainDelegate {
    func didUpdateQuiz(question: Question) {
        let choices = question.choices
        DispatchQueue.main.async {
            self.questionLabel.text = question.text
            self.wordLabel.text = question.word
            self.choice1.setTitle(choices[0], for: .normal)
            self.choice2.setTitle(choices[1], for: .normal)
            self.choice3.setTitle(choices[2], for: .normal)
            self.choice4.setTitle(choices[3], for: .normal)
            self.choice1.backgroundColor = UIColor.clear
            self.choice2.backgroundColor = UIColor.clear
            self.choice3.backgroundColor = UIColor.clear
            self.choice4.backgroundColor = UIColor.clear
            self.progressBar.progress = self.quizBrain.getProgress()
            self.scoreLabel.text = "Score: \(self.quizBrain.getScore())"
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var wordLabel: UILabel!
    @IBOutlet weak var choice1: UIButton!
    @IBOutlet weak var choice2: UIButton!
    @IBOutlet weak var choice3: UIButton!
    @IBOutlet weak var choice4: UIButton!
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var quizBrain = QuizBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        quizBrain.delegate = self
        quizBrain.fetchData()
        quizBrain.uploadWords()
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        let userAnswer = sender.currentTitle!

        if (quizBrain.checkAnswer(userAnswer)) {
            sender.backgroundColor = UIColor.green
        } else {
            sender.backgroundColor = UIColor.red
        }
        
        quizBrain.updateQuestionNumber()
        Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(updateUI), userInfo: nil, repeats: false)
    }
    
    @objc func updateUI() {
        quizBrain.fetchData()
    }
}

