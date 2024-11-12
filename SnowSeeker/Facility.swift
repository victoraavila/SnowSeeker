//
//  Facility.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 11/11/24.
//

import SwiftUI

// SwiftUI lets us present an alert with an Optional source of truth inside. For this, we'll rewrite the way our resort facilities are shown by replacing with icons that represent each facility. When the user taps each of them, an alert with a description of the facility will be shown.
// This functionality should be available globally in our project.
// 1. Convert facility names into icon names that can be displayed.
// 2. Create Facility instances for every one of the facilities in a resort (inside the Resort struct).
// 3. Replace the old facilities Text in ResortView with the new icons.
// 4. Make facility Images into Buttons so we can tap them to show alerts.
// 4.1. Add 2 @State properties to ResortView: one to store the currently selected facility and another to store whether the alert should be currently shown or not.
// 4.2. Create the Alert by adding a dictionary to our Facility struct containing all the keys and values we need. The Alert will only have an OK Button. We'll provide a message based on the unwrapped Facility data by calling the method message(for:) we wrote.

struct Facility: Identifiable {
    let id = UUID()
    var name: String
    
    // Mapping each facility name with an icon from SF Symbols
    private let icons = [
        "Accommodation": "house",
        "Beginners": "1.circle",
        "Cross-country": "map",
        "Eco-friendly": "leaf.arrow.circlepath",
        "Family": "person.3"
    ]
    
    // Description of each alert
    private let descriptions = [
        "Accommodation": "This resort has popular on-site accommodation.",
        "Beginners": "This resort has lots of ski schools.",
        "Cross-country": "This resort has many cross-country ski routes.",
        "Eco-friendly": "This resort has won an award for environment friendliness.",
        "Family": "This resort is popular with families."
    ]
    
    // A computed property to determine which icon to send back based on the input facility
    // Icons are already stylized
    var icon: some View {
        // If we can read our icon name from the input facility
        if let iconName = icons[name] {
            Image(systemName: iconName)
                .accessibilityLabel(name) // To say the key of icons dict with VoiceOver
                .foregroundStyle(.secondary)
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
    
    // A computed property that returns a description string based on the input facility
    var description: String {
        if let message = descriptions[name] {
            message
        } else {
            fatalError("Unknown facility type: \(name)")
        }
    }
}
