//  Menus.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 10.07.23.

import SwiftUI

struct Menus: Commands {
    var body: some Commands {
        CommandGroup(after: .appInfo) {
            Button("Delete all folder bookmarks") {
                FileBookmarkHandler.shared.saveBookmarksArchive()
            }
        }
    }
}
