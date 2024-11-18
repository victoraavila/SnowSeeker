//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 21/10/24.
//

import SwiftUI

// In this app we will display 2 Views side by side, just like in Apple Notes.
// We will place these 2 Views in a NavigationSplitView, then use a NavigationLink in the primary View to control what's visible in the secondary View.
// The primary View will be a List of all ski resorts, along with which country they are from and also how many ski runs (trails) each one has.

// The flags will be shown at right size for their resolution (on both Retina 2X devices and Super Retina 3X devices).
// The resorts' images are designed to be shown just big enough to fill all the space on an iPad Pro, and they are more than enough for any iPhone.

struct ContentView: View {
    // Using the Bundle extension to add a property that loads all our Resort into a single Array.
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    
    @State private var favorites = Favorites()
    
    @State private var searchText = ""
    
    var filteredResorts: [Resort] {
        var sortedResorts = resorts
        switch selectedSorting {
        case "Alphabetical order":
            sortedResorts = resorts.sorted { (lhs: Resort, rhs: Resort) -> Bool in
                return lhs.name < rhs.name
            }
        case "Country order":
            sortedResorts = resorts.sorted { (lhs: Resort, rhs: Resort) -> Bool in
                if lhs.country == rhs.country {
                    return lhs.name < rhs.name  // Secondary sort by name when countries are equal
                }
                return lhs.country < rhs.country
            }
        default:
            sortedResorts = resorts
        }
        
        if searchText.isEmpty {
            return sortedResorts
        } else {
            return sortedResorts.filter { $0.name.localizedStandardContains(searchText) } // Only values that pass the test of our choosing will be returned.
            // .localizedStandardContains() is the preferred way of filtering user searches (ignores casing, accents and diacritics).
        }
    }
    
    let sorters = ["Default order", "Alphabetical order", "Country order"]
    @State private var selectedSorting = "Default order"
    
    var body: some View {
        // A NavigationSplitView with a List inside of it to show all our resorts
        // In each row, there is a small flag of which country the resort is, the name of the resort and how many runs it has
        // The size of the flag will be 40x25, which is smaller than our flag assets (and also a different aspect ratio). We'll fix that with .resizable(), .scaledToFill() and a custom frame.
        // A custom shape and stroked overlay will be used to make it look better on screen.
        // When it is tapped, we'll push to a DetailView showing more information about the resort.
        NavigationSplitView {
                List(filteredResorts) { resort in
                    NavigationLink(value: resort) {
                        HStack {
                            Image(resort.country)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 40, height: 25)
                                .clipShape(.rect(cornerRadius: 5))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 5)
                                        .stroke(.black, lineWidth: 1)
                                )
                            
                            VStack(alignment: .leading) {
                                Text(resort.name)
                                    .font(.headline)
                                
                                Text("\(resort.runs) runs")
                                    .foregroundStyle(.secondary) // This is not quite so important
                            }
                            
                            // Display a heart for the user's favorite Resorts.
                            if favorites.contains(resort) {
                                Spacer() // To put our Views to one side
                                
                                Image(systemName: "heart.fill")
                                    .accessibilityLabel("This is a favorite resort")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack {
                        Text("Resorts")
                            .font(.largeTitle) // Matches the navigation title font size
                            .fontWeight(.bold) // Ensures a bold appearance
                            .foregroundColor(.primary) // Adapts to light/dark mode
                    }
                    .padding(.vertical)
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu("Sort") {
                        Picker("", selection: $selectedSorting) {
                            ForEach(sorters, id: \.self) { sorter in
                                Text(sorter)
                            }
                        }
                    }
                    .padding(.vertical)
                }
            }
            // Pointing to our actual ResortView
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort) // Call ResortView with the resort that was chosen
            }
            .searchable(text: $searchText, prompt: "Search for a resort") // prompt is what appears when the box is empty
        } detail: {
            // This is enough for SwiftUI to only show the WelcomeView when first running the app.
            // It is nice to test on several different devices, both in portrait and landscape. On iPad, you might see different things depending on the device orientation and whether the app has all the screen or just half the screen (split screen).
            WelcomeView()
        }
        // Inject our Favorites instance into the Environment, so every View gets the exact same object
        .environment(favorites)
    }
}

// Before the List in ContentView is done, we'll add a new SwiftUI modifier called .searchable().
// Adding this will allow users to filter the list of resorts being shown, making it easy to find the exact thing they are looking for.
// 1. Add an @State property to store the text the user is currently searching for;
// 2. Bind the property to our List in ContentView by using .searchable() right below .navigationDestination(for:);
// 3. Add a computed property to handle the filtering of our data (if searchText is empty, return everything; otherwise use .localizedStandardContains() to filter the Array based on their search criteria).
// 4. Use filteredResorts as the data source for our List.

#Preview {
    ContentView()
}
