//
//  Favorites.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 11/11/24.
//

import SwiftUI

// Let's let the user assign favorites to the resorts they love
// 1. Make a new Favorites class that has a set of Resort ids the user loves. It will have add(), remove() and contains() methods to manipulate the data while also saving changes to UserDefaults. We will not use Set methods so we can call a save() method to persist user changes. The Set of ids will be private in order to avoid missing saving them.
// 2. Then, we will inject an instance of Favorites into the Environment (so all Views can share it) and add some new UI to call the new methods.

@Observable
class Favorites {
    // The actual resorts the user favorited
    private var resorts: Set<String>
    
    // A key to remember which place in UserDefaults we're reading and writing from
    private let key = "Favorites"
    
    // Loading our saved data
    init() {
        resorts = []
    }
    
    func contains(_ resort: Resort) -> Bool {
        resorts.contains(resort.id)
    }
    
    // A method to add a resort to our Set and save it at the same time
    func add(_ resort: Resort) {
        resorts.insert(resort.id)
        save()
    }
    
    // A method to remove a resort from our Set and save it at the same time
    func remove(_ resort: Resort) {
        resorts.remove(resort.id)
        save()
    }
    
    func save() {
        // Write out all data
    }
}
