//  FileBookmarkHandler.swift
//  Created by Holger Hinzberg on 26.11.20.
// based on
// https://github.com/sidmhatre/GetFolderAccessMacOS.git

// 1. Change Files name for fileNameForBookmarks

// 2. Add this to the Entitlements File, NOT the Info.plist
// <key>com.apple.security.files.user-selected.read-write</key>
// <true/>
// <key>com.apple.security.files.bookmarks.app-scope</key>
// <true/>

// 3. Add a folder to the bookmark list anytime you access a folder
// FileBookmarkHandler.shared.storeFolderInBookmark(url: url)
// FileBookmarkHandler.shared.saveBookmarksData()

// 4. Restore saved bookmarks in applicationDidFinishLaunching
// FileBookmarkHandler.shared.loadBookmarks()

import SwiftUI

class FileBookmarkItem : Identifiable {
    var id : UUID
    var url : URL
    
    init(url: URL) {
        self.id = UUID()
        self.url = url
    }
}

class FileBookmarkHandler : ObservableObject {
    
    static let shared = FileBookmarkHandler()
    @Published private var bookmarks = [URL: Data]()
    
    let fileNameForBookmarks = "CollectionComposer3_Bookmarks.dict";
    
    private init() {  }
    
    /// Show an NSOpenPanel and saves the selected folder in the bookmarks
    /// - Returns: Selected URL
    public func openFolderSelection(save : Bool)
    {
        let openPanel = NSOpenPanel()
        openPanel.allowsMultipleSelection = false
        openPanel.canChooseDirectories = true
        openPanel.canCreateDirectories = true
        openPanel.canChooseFiles = false
        openPanel.begin
        { (result) -> Void in
            if result.rawValue == NSApplication.ModalResponse.OK.rawValue
            {
                let url = openPanel.url
                self.storeFolderInBookmark(url: url!)
                if (save == true){
                    self.saveBookmarksArchive()
                }
            }
        }
    }
    
    ///  Adds another Url to the dicitionary of booksmarks
    ///  Does not save the bookmark file.
    ///  Use saveBookmarksArchive to save
    /// - Parameter url: url
    public func storeFolderInBookmark(url: URL)
    {
        do
        {
            let data = try url.bookmarkData(options: NSURL.BookmarkCreationOptions.withSecurityScope, includingResourceValuesForKeys: nil, relativeTo: nil)
            bookmarks[url] = data
        }
        catch
        {
            Swift.print ("Error storing bookmarks")
        }
    }
    
    public func clearBookmarks() {
        bookmarks.removeAll()
        self.saveBookmarksArchive()
    }
    
    /// Location of archived bookmarks directory
    /// - Returns: Location folder
    private func getBookmarkPath() -> String
    {
        var url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0] as URL
        url = url.appendingPathComponent(fileNameForBookmarks)
        return url.path
    }
    
    /// Saves bookmarks to file
    public func saveBookmarksArchive()
    {
        let path = getBookmarkPath()
        let encoder = JSONEncoder()
        let pathAsURL = URL(fileURLWithPath: path)
        
        do {
            let data = try encoder.encode(bookmarks)
            try data.write(to: pathAsURL)
            print("Bookmarks saved")
        } catch let Error {
            print("Bookmarks note saved")
            print(Error.localizedDescription)
        }
    }
    
    /// Loads bookmarks from file
    func loadBookmarksArchive()
    {
        let path = getBookmarkPath()
        guard  let data = try? Data(contentsOf: URL(fileURLWithPath: path), options: []) else {return}
        
        do {
            let decoder = JSONDecoder()
            let loaded : [URL: Data] = try decoder.decode([URL: Data].self, from: data)
            bookmarks = loaded
            print("Bookmarks loaded")
            for bookmark in bookmarks
            {
                restoreBookmark(bookmark)
            }
        } catch let error {
            print("Bookmarks not loaded")
            print(error.localizedDescription)
        }
    }
    
    /// Restores a bookmark (typical after loading from file)
    /// - Parameter bookmark: a bookmark
    private func restoreBookmark(_ bookmark: (key: URL, value: Data))
    {
        let restoredUrl: URL?
        var isStale = false
        
        print ("Restoring \(bookmark.key)")
        do
        {
            restoredUrl = try URL.init(resolvingBookmarkData: bookmark.value, options: NSURL.BookmarkResolutionOptions.withSecurityScope, relativeTo: nil, bookmarkDataIsStale: &isStale)
        }
        catch
        {
            print ("Error restoring bookmarks")
            restoredUrl = nil
        }
        
        if let url = restoredUrl
        {
            if isStale
            {
                print ("URL is stale")
            }
            else
            {
                if !url.startAccessingSecurityScopedResource()
                {
                    Swift.print ("Couldn't access: \(url.path)")
                }
            }
        }
    }
    
    public func getBookmarksFolders() ->[URL] {
        return Array(self.bookmarks.keys).sorted{$0.lastPathComponent < $1.lastPathComponent }
    }
    
    public func getBookmarksItems() -> [FileBookmarkItem] {
        var items = [FileBookmarkItem]()
        let urls : [URL] = Array(self.bookmarks.keys).sorted{$0.lastPathComponent < $1.lastPathComponent }
        for url in urls {
            items.append(FileBookmarkItem(url: url))
        }
        return items
    }
    
    public func deleteBookmark(url :URL, save : Bool) {
        self.bookmarks.removeValue(forKey: url)
        
        if (save == true){
            self.saveBookmarksArchive()
        }
    }
}

