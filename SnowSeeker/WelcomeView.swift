//
//  WelcomeView.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 22/10/24.
//

import SwiftUI

// When using NavigationSplitView, it is common to have the DetailView showing information about what was selected on the sidebar.
// What do we show on the DetailView when the app was just launched? On iPhone this is not a problem, since the users will only see the sidebar anyway. However, on iPad, if the orientation is landscape, users will only see the DetailView by default.

// One easy solution is to make a small View with introductory instructions to help users get started. This will only be shown when the user is first running the app. It will replaced as soon as the user taps any link on the sidebar.

struct WelcomeView: View {
    var body: some View {
        VStack {
            Text("Welcome to SnowSeeker")
                .font(.largeTitle)
            
            Text("Please select a resort from the left-hand menu; swipe from the edge to show it.")
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    WelcomeView()
}
