//
//  QuizData.swift
//  VocabularyLearnerStoryboard
//
//  Created by Weiduo Sun on 7/4/20.
//  Copyright © 2020 Weiduo Sun. All rights reserved.
//

import Foundation

struct QuizData: Decodable {
    let meta: Meta
}

struct Meta: Decodable {
    let def: Def
}

struct Def: Decodable {
    let defArray: [DefArray]
}

struct DefArray: Decodable {
    let sseq: Sseq
}

struct Sseq: Decodable {
    let sseqArray: [SseqArray]
}

struct SseqArray: Decodable {
    let seeqArrayArray: [SseqArrayArray]
}

struct SseqArrayArray: Decodable {
    let dt: Dt
}

struct Dt: Decodable {
    let dtArray: [dtArray]
}

struct dtArray: Decodable {
    let vis: Vis
}

struct Vis: Decodable {
    let visArray: [VisArray]
}

struct VisArray: Decodable {
    let text: Text
}

struct Text: Decodable {
    let t: String
}
