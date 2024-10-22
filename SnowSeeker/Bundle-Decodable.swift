//
//  Bundle-Decodable.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 21/10/24.
//

import Foundation

extension Bundle {
    func decode<T: Decodable>(_ file: String) -> T {
        // It is OK to throw a Fatal Error here, because the JSON is bundled with the app and then easy to find
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Failed to locate \(file) in the bundle.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Failed to load \(file) from bundle.")
        }
        
        // If still here, make a decoder
        let decoder = JSONDecoder()
        
        do {
            
            // Let's try our decoding first: attempt to decode some type (we don't know what type it is, just that it is an unknown decodable type provided by whom is calling us)
            // T could be String, [String], Int, Bool or Resort (since it conforms to Codable).
            return try decoder.decode(T.self, from: data)
            
            // All sorts of errors could have happened here, and we will break down all of them
            // JSON was bad, you could have asked for an [String] and got [Int], etc.
            
        } catch DecodingError.keyNotFound(let key, let context){
            
            // Using key and context ("Here's what we think went wrong") for a meaningful error message
            // Maybe the description or number of runs was not found, for example
            fatalError("Failed to decode \(file) from bundle due to missing key '\(key)' - \(context.debugDescription)")
            
        } catch DecodingError.typeMismatch(_, let context) {
            
            // This happens when you call decode the value of "runs" as Int, but it's actually a String (it exists, but not the way you thought it would exist)
            fatalError("Failed to decode \(file) from bundle due to type mismatch - \(context.debugDescription)")
            
        } catch DecodingError.valueNotFound(let type, let context) {
            
            // This happens when you expect a value, but you actually got back nil
            fatalError("Failed to decode \(file) from bundle due to missing \(type) value - \(context.debugDescription)")
            
        } catch DecodingError.dataCorrupted(_) {
            
            // This happens when the JSON is not valid
            fatalError("Failed to decode \(file) from bundle because it appears to be invalid JSON.")
            
        } catch {
            
            // The Pokémon catch - you've gotta catch them all (all the errors)
            fatalError("Failed to decode \(file) from bundle: \(error.localizedDescription).")
            
        }
    }
}
