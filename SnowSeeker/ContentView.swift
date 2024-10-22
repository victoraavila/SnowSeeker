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
    
    var body: some View {
        // A NavigationSplitView with a List inside of it to show all our resorts
        // In each row, there is a small flag of which country the resort is, the name of the resort and how many runs it has
        // The size of the flag will be 40x25, which is smaller than our flag assets (and also a different aspect ratio). We'll fix that with .resizable(), .scaledToFill() and a custom frame.
        // A custom shape and stroked overlay will be used to make it look better on screen.
        // When it is tapped, we'll push to a DetailView showing more information about the resort.
        NavigationSplitView {
            List(resorts) { resort in
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
                    }
                }
            }
            .navigationTitle("Resorts")
            // Pointing to our actual ResortView
            .navigationDestination(for: Resort.self) { resort in
                ResortView(resort: resort) // Call ResortView with the resort that was chosen
            }
        } detail: {
            // This is enough for SwiftUI to only show the WelcomeView when first running the app.
            // It is nice to test on several different devices, both in portrait and landscape. On iPad, you might see different things depending on the device orientation and whether the app has all the screen or just half the screen (split screen).
            WelcomeView()
        }
    }
}

#Preview {
    ContentView()
}
