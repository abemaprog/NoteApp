//
//  Note.swift
//  NoteApp
//
//  Created by Manato Abe on 2024/11/04.
//

import SwiftUI

struct Note: Identifiable{
    var id: String = UUID.init().uuidString
    var color: Color
    
    // View プロパティー
    var allowHitTesting: Bool = false
}

var mockNotes: [Note] = [
    .init(color: .red),
    .init(color: .blue),
    .init(color: .green),
    .init(color: .yellow),
    .init(color: .purple)
]
    
