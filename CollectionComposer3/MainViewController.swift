//
//  MainViewController.swift
//  CollectionComposer3
//
//  Created by Holger Hinzberg on 05.07.23.
//

import SwiftUI

public class MainViewControler : ObservableObject {
    
    @Published public var doDelete = true
    @Published public var destinationPath = ""
    @Published public var numbersOfFilesToCopy = ""
    @Published public var keywords = ""
    @Published public var statusText = "StatusText"
    
    @Published public var folders = [
        FolderInfo(Folder: "pictures", FilesCount: 10, FilesInFolder: nil),
        FolderInfo(Folder: "downloads", FilesCount: 11, FilesInFolder: nil),
        FolderInfo(Folder: "documents", FilesCount: 12, FilesInFolder: nil)
    ]
}
