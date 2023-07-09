//  AppDelegate.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 09.07.23.

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        print("start")
        FileBookmarkHandler.shared.loadBookmarks()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        print("end")
    }
}
