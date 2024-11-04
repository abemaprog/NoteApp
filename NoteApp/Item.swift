//
//  Item.swift
//  NoteApp
//
//  Created by Manato Abe on 2024/11/04.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
