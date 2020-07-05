//
//  QuizBrain.swift
//  VocabularyLearnerStoryboard
//
//  Created by Weiduo Sun on 7/4/20.
//  Copyright © 2020 Weiduo Sun. All rights reserved.
//

import Foundation

protocol QuizBrainDelegate {
    func didUpdateQuiz(question: Question)
    func didFailWithError(error: Error)
}

protocol WordsDelegate {
    func didUploadWords(words: [String])
    func didFailWithError(error: Error)
}

struct QuizBrain: WordsDelegate {
    func didUploadWords(words: [String]) {
//        self.wordsList = words
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
    let quiz = [
        Question(q: "He's been chosen as a delegate to the convention.", w:"delegate", c:["ambassadress", "inventor", "killer", "father"], a: "ambassadress"),
        Question(q: "The light bulb was one of the most important inventions of the 19th century.", w:"happy", c:["sad", "angry", "good", "glad"], a: "glad"),
    ]
    let candidates = ["delegate", "happy"]
    let dictionaryURL = "https://www.dictionaryapi.com/api/v3/references/thesaurus/json/"
    let wordsURL = "https://random-word-api.herokuapp.com/word?number=1000"
    let apiKey = "5f0e5ed6-949e-4683-9361-416f22ceaec7"
    var questionNumber = 0
    var score = 0
    var delegate: QuizBrainDelegate?
    var wordsDelegate: WordsDelegate?
//    var wordsList: [String]
    
    func fetchData() {
        let urlString = "\(dictionaryURL)\(candidates[questionNumber])?key=\(apiKey)"
        performRequest(urlString)
    }
    
    func uploadWords() {
        performWordsRequest(wordsURL)
    }
    
    func performRequest(_ urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url, completionHandler: handle(data: response: error:))
            
            //4. Start the task
            task.resume()
        }
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?) {
        if (error != nil) {
            self.delegate?.didFailWithError(error: error!)
            print(error!)
            return
        }
        
        if let safeData = data {
            if let question = self.parseJSON(safeData) {
                self.delegate?.didUpdateQuiz(question: question)
            }
        }
    }
    
    func parseJSON(_ quizData: Data) -> Question? {
        do {
            let decodedData = try JSONSerialization.jsonObject(with:quizData, options:[]) as? [Dictionary<String, Any>]
            let decodedData1 = decodedData![0]["def"] as? [Dictionary<String, Any>]
            let decodedData2 = decodedData1![0]["sseq"] as? [Any]
            let decodedData3 = decodedData2![0] as? [Any]
            let decodedData4 = decodedData3![0] as? [Any]
            let decodedData5 = decodedData4![1] as? Dictionary<String, Any>
            let decodedData6 = decodedData5!["dt"] as? [Any]
            let decodedData7 = decodedData6![1] as? [Any]
            let decodedData8 = decodedData7![1] as? [Dictionary<String, String>]
            let decodedData9 = decodedData5!["rel_list"] as? [[Dictionary<String, String>]]
            let question = (decodedData8![0]["t"] ?? "").replacingOccurrences(of: "{it}", with: "", options: NSString.CompareOptions.literal, range: nil).replacingOccurrences(of: "{/it}", with: "", options: NSString.CompareOptions.literal, range: nil)
            let word = candidates[questionNumber];
            let choices = quiz[questionNumber].choices
            let answer = decodedData9![0][0]["wd"] ?? ""
            let quiz = Question(q: question, w: word, c: choices, a:answer)
            return quiz
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func performWordsRequest(_ urlString: String) {
        //1. Create a URL
        if let url = URL(string: urlString) {
            //2. Create a URLSession
            let session = URLSession(configuration: .default)
            
            //3. Give the session a task
            let task = session.dataTask(with: url)
            
            //4. Start the task
            task.resume()
        }
    }
    
    func wordsHandle(data: Data?, response: URLResponse?, error: Error?) {
        if (error != nil) {
            self.wordsDelegate?.didFailWithError(error: error!)
            print(error!)
            return
        }
        
        if let safeData = data {
            if let words = self.parseWordsJSON(safeData) {
                self.wordsDelegate?.didUploadWords(words: words)
            }
        }
    }
    
    func parseWordsJSON(_ wordsData: Data) -> [String]? {
        do {
            let decodedData = try JSONSerialization.jsonObject(with:wordsData, options:[]) as? [String]
            return decodedData
        } catch {
            print(error)
            return nil
        }
    }
    
    mutating func checkAnswer(_ userAnswer: String) -> Bool {
        if (userAnswer == quiz[questionNumber].answer) {
            score += 1
            return true;
        }
        return false;
    }
    
    mutating func updateQuestionNumber() {
        if (questionNumber + 1 < quiz.count) {
            questionNumber += 1
        } else {
            questionNumber = 0
        }
    }
    
    func getQuestionText() -> String {
        return quiz[questionNumber].text
    }
    
    func getChoices() -> [String] {
        return quiz[questionNumber].choices
    }
    
    func getWord() -> String {
        return quiz[questionNumber].word
    }
    
    func getProgress() -> Float {
        return Float(questionNumber + 1) / Float(quiz.count)
    }
    
    func getScore() -> Int {
        return score;
    }
}
