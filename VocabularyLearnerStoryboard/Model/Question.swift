//
//  Question.swift
//  VocabularyLearnerStoryboard
//
//  Created by Weiduo Sun on 7/4/20.
//  Copyright © 2020 Weiduo Sun. All rights reserved.
//

import Foundation

struct Question {
    var text: String
    var word: String
    var choices: [String]
    var answer: String
    
    init(q: String, w: String, c:[String], a: String) {
        text = q
        answer = a
        choices = c
        word = w
    }
}
