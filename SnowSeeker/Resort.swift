//
//  Resort.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 21/10/24.
//

import Foundation

// We will define a Resort struct that can be loaded for our JSON (i.e., it will conform to Codable). For better compatibility with SwiftUI, it will conform to Hashable and Identifiable too.
// The values are either Strings, Ints or [String].

struct Resort: Codable, Hashable, Identifiable {
    var id: String
    var name: String
    var country: String
    var description: String
    var imageCredit: String
    var price: Int
    var size: Int
    var snowDepth: Int
    var elevation: Int
    var runs: Int
    var facilities: [String]
    
    // It's a good idea to have example data here in the model so it's easier to show working data on designs and previews.
    // We will use the Bundle-Decodable extension for Project 8 in order to load real data from the resorts.json instead of filling manually.
    
    // We have 2 options:
    // 1. Load 2 static properties: one to load all the resorts in the Array and one to store the first item in the Array (this is simpler)
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json") // Belongs to this type, rather than to an instance of Resort
    static let example = allResorts[0]
    // 2. Collapse all this down to a single line of code: this requires typecasting as our decode() extension method needs to know what type of data it is decoding.
//    static let allResorts = (Bundle.main.decode("resorts.json") as [Resort])[0]
    
    // When we use static let, the constants won't get created until they're actually used: Swift will only read Resort.allResorts when we try to read Resort.example.
    // This means we can always be sure the 2 properties will be run in the correct order.
}

