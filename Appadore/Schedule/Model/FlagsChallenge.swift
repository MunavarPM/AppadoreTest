//
//  FlagsChallenge.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import Foundation

struct FlagQuestionSet: Codable {
    let questions: [FlagQuestion]
}

struct FlagQuestion: Codable, Identifiable {
    var id: String { countryCode }
    let answerID: Int
    let countries: [CountryOption]
    let countryCode: String

    enum CodingKeys: String, CodingKey {
        case answerID = "answer_id"
        case countries
        case countryCode = "country_code"
    }
}

struct CountryOption: Codable, Identifiable {
    let countryName: String
    let id: Int

    enum CodingKeys: String, CodingKey {
        case countryName = "country_name"
        case id
    }
}

