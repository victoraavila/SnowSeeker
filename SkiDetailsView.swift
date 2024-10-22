//
//  SkiDetailsView.swift
//  SnowSeeker
//
//  Created by Víctor Ávila on 22/10/24.
//

import SwiftUI

struct SkiDetailsView: View {
    let resort: Resort
    
    var body: some View {
        Group {
            VStack {
                Text("Elevation")
                    .font(.caption.bold())
                
                Text("\(resort.elevation)m")
                    .font(.title3)
            }
            
            VStack {
                Text("Snow")
                    .font(.caption.bold())
                
                Text("\(resort.snowDepth)cm")
                    .font(.title3)
            }
        }
        .frame(maxWidth: .infinity) // Adding a maximum frame size to the Group View itself (since the Group does not have a layout, this gets passed to each of its child Views, so they'll automatically spread out horizontally).
    }
}

#Preview {
    SkiDetailsView(resort: .example)
}
