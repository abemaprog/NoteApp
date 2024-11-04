//
//  View.swift
//  NoteApp
//
//  Created by Manato Abe on 2024/11/04.
//

import SwiftUI

struct Home: View {
    
    @State var searchText: String = ""
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 20) {
                searchBar()
            }
            
        }
        .safeAreaPadding(15)
    }
    // Custom ViewBuilder
    
    
}

#Preview {
    Home()
}
