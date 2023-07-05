//  FolderInfo.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI

public struct FolderInfo : Identifiable {
    public let id = UUID()
    public var Folder = ""
    public var FilesCount = 0
    public var FilesInFolder: [URL]? = nil
    
    public init(Folder: String = "", FilesCount: Int = 0, FilesInFolder: [URL]? = nil) {
        self.Folder = Folder
        self.FilesCount = FilesCount
        self.FilesInFolder = FilesInFolder
    }
}
