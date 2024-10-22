//
//  ResortDetailsView.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 22/10/24.
//

import SwiftUI

// ResortDetailsView is a little trickier than SkiDetailsView:
// The size of the resort is stored as a value between 1 and 3 (but we want to say "small", "average" and "large" instead).
// The price of the resort is also stored as a value between 1 and 3 (but we want to say "$", "$$" or "$$$" instead).
// It's a good idea to do calculations out of the SwiftUI layouts, so it is nice and clear, by creating 2 computed properties for size and price.

struct ResortDetailsView: View {
    let resort: Resort
    
    // Getting the size of the resort
    var size: String {
        // When size is 1, subtract from that to get 0 and therefore return the 0th item
        // This would crash if an invalid value was passed in somehow
//        ["Small", "Average", "Large"][resort.size - 1]
        
        // It is much safer to use a switch block
        switch resort.size {
            case 1: "Small"
            case 2: "Average"
            default: "Large"
        }
    }
    
    // For the price property, we can use the same (repeating:, count:) initializer we used to create example cards in Project 17, but by creating a new String by repeating a substring.
    var price: String {
        String(repeating: "$", count: resort.price) // "$", "$$" or "$$$"
    }
    
    
    var body: some View {
        Group {
            VStack {
                Text("Size")
                    .font(.caption.bold())
                
                Text(size)
                    .font(.title3)
            }
            
            VStack {
                Text("Price")
                    .font(.caption.bold())
                
                Text(price)
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity) // Stretching everything horizontally in the Group to be wider as it needs to
    }
}

#Preview {
    ResortDetailsView(resort: .example)
}
