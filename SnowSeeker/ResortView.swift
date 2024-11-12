//
//  ResortView.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 22/10/24.
//

import SwiftUI

// We'll add a new ResortView that chooses a picture from the resort and adds some description text and a list of facilities.
// It'll be a ScrollView, a VStack, an Image and some Text. We'll show the facilities as a single Text View by joining the [String].
// The descriptions are from Wikipedia and photos from unsplash.com. It is necessary to attribute them to the authors in order to commercial usage.

struct ResortView: View {
    let resort: Resort
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) { // Spacing set to 0 so it'll be nice and tight
                Image(decorative: resort.id) // This is decorative (it won't be read by VoiceOver).
                    .resizable()
                    .scaledToFit()
                
                // We could put all the following information on a HStack, but it would restrict what we can do in the future
                // So, we will split it into 2 Views: one for resort information (price and size) and one for ski information (elevation and snow depth).
                HStack {
                    // How big the resort is and How much the resort costs
                    ResortDetailsView(resort: resort)
                    
                    // How high the resort is and how deep the resort is
                    SkiDetailsView(resort: resort)
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1)) // A gentle background color
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
//                    Text(resort.facilities.joined(separator: ", ")) // Separator is what will be used to separate each item
//                        .padding(.vertical)
                    
                    // Previously we used the format parameter of Text to control the way numbers are formatted. There is a format for String Arrays too.
                    // This is similar to using .joined(separator:), but rather than getting back "A, B, C" we get back "A, B and C", which is more natural to read.
                    Text(resort.facilities, format: .list(type: .and)) // This type: .and is what appears in the final String (we could also use .or).
                        .padding(.vertical)
                }
                .padding(.horizontal) // So the whole group get the same padding
                
                
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    ResortView(resort: .example) // The example data made earlier.
}
