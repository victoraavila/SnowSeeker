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

// SwiftUI gives us 2 environment values to monitor the current size class of our app. We can show one layout when space is restricted and another when space is plentiful.
// For example, ResortDetailsView() and SkiDetailsView() are Groups. They don't carry layout information. This is why they become 4 pieces of Text displayed horizontally. Though, when space is limited, it would be great to display them as 2x2 instead.
// For this, we will keep them layout-neutral (they will adapt to an HStack or a VStack depending on the parent that places them) by reading the horizontalSizeClass. If we have a regular horizontal space, we will keep the HStack; if we have a compact horizontal space, we will ditch the Views in VStacks.
// Even better: we can combine the approach above with a checking for the Dynamic Type the user has set. This way, we will use the flat horizontal layout almost every time (except when there is no space at all, i.e., when the user has a compact horizontal size AND a larger dynamic type setting).
// These changes don't result in code duplication but also let ResortDetailsView() and SkiDetailsView() not specify the layout, so the parent View can take care of it.
// You can change the range of Dynamic Type sizes supported for one specific View (for example, if it looks bad in xxxLarge). For this, use the .dynamicTypeSize() modifier. (It is recommended to avoid using this if the UI is not going to break).

struct ResortView: View {
    let resort: Resort
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass // This will tell whether the horizontal size is regular or compact (roughly, all iPhones are compact in width and regular in height in Portrait; most iPhones are compact in width and compact in height in Landscape; large iPhones are regular in width and compact in height in Landscape; all iPads are regular in width and regular in height in both Landscape and Portrait when running in Full Screen, but downgraded when running in Split Mode.)
    
    // Detect the Dynamic Type size
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    // Read the Favorites object so the user can choose if they want to make this resort a favorite or not
    @Environment(Favorites.self) var favorites
    
    @State private var selectedFacility: Facility? // This is Optional, so we can't use it as the only title for our Alert. We'll have to use nil coalescing. We also always want to make sure that the Alert reads from selectedFacility, so it passes in the unwrapped value from there.
    @State private var showingFacility = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) { // Spacing set to 0 so it'll be nice and tight
                ZStack(alignment: .bottomTrailing) {
                    Image(decorative: resort.id) // This is decorative (it won't be read by VoiceOver).
                        .resizable()
                        .scaledToFit()
                    
                    Text("© \(resort.imageCredit)")
                        .font(.caption)
                        .foregroundStyle(Color(.darkGray))
                        .shadow(color: .white, radius: 1)
                        .padding(.trailing, 5)
                        .padding(.bottom, 5)
                        
                }
                
                // We could put all the following information on a HStack, but it would restrict what we can do in the future
                // So, we will split it into 2 Views: one for resort information (price and size) and one for ski information (elevation and snow depth).
                HStack {
                    // This might look like a lot of space is being left behind, but this enables users to have larger font sizes
                    if horizontalSizeClass == .compact && dynamicTypeSize > .large { // large is the default in iOS
                        VStack(spacing: 10) { ResortDetailsView(resort: resort) }
                        VStack(spacing: 10) { SkiDetailsView(resort: resort) }
                    } else {
                        // How big the resort is and How much the resort costs
                        ResortDetailsView(resort: resort)
                        
                        // How high the resort is and how deep the resort is
                        SkiDetailsView(resort: resort)
                    }
                }
                .padding(.vertical)
                .background(.primary.opacity(0.1)) // A gentle background color
                .dynamicTypeSize(...DynamicTypeSize.xxxLarge) // This is a one-sided range (go as small as possible, but don't go any bigger than xxxLarge).
                
                Group {
                    Text(resort.description)
                        .padding(.vertical)
                    
                    Text("Facilities")
                        .font(.headline)
                    
//                    Text(resort.facilities.joined(separator: ", ")) // Separator is what will be used to separate each item
//                        .padding(.vertical)
                    
                    // Previously we used the format parameter of Text to control the way numbers are formatted. There is a format for String Arrays too.
                    // This is similar to using .joined(separator:), but rather than getting back "A, B, C" we get back "A, B and C", which is more natural to read.
                    //Text(resort.facilities, format: .list(type: .and)) // This type: .and is what appears in the final String (we could also use .or).
                        //.padding(.vertical)
                    
                    // Loop over each facility icon and displaying it
                    HStack {
                        ForEach(resort.facilityTypes) { facility in
                            Button {
                                selectedFacility = facility
                                showingFacility = true
                            } label: {
                                facility.icon
                                    .font(.title) // Nice and large icon
                            }
                        }
                    }
                    .padding(.vertical)
                }
                .padding(.horizontal) // So the whole group get the same padding
                
                // Add or remove this Resort from the user's Favorites by pressing a Button
                Button(favorites.contains(resort) ? "Remove from Favorites" : "Add to Favorites") {
                    if favorites.contains(resort) {
                        favorites.remove(resort)
                    } else {
                        favorites.add(resort)
                    }
                }
                .buttonStyle(.borderedProminent)
                .padding()
            }
        }
        .navigationTitle("\(resort.name), \(resort.country)")
        .navigationBarTitleDisplayMode(.inline)
        // presenting: is set so it unwraps the value of selectedFacility if we need it.
        // The alert won't be shown if selectedFacility can't be unwrapped.
        .alert(selectedFacility?.name ?? "More information", isPresented: $showingFacility, presenting: selectedFacility) { _ in // We don't want the unwrapped selectedFacility
        } message: { facility in // Here we want the unwrapped selectedFacility
            Text(facility.description)
        }
    }
}

#Preview {
    ResortView(resort: .example) // The example data made earlier.
        // Inject the Favorites object so it won't crash
        .environment(Favorites())
}
