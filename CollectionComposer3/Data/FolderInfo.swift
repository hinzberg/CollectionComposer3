//  FolderInfo.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI

public struct FolderInfo : Identifiable, Codable {
    public var id = UUID()
    public var Folder = ""
    public var FilesCount = 0
    public var FilesInFolder: [URL]? = nil
    
    public init(Folder: String = "", FilesCount: Int = 0, FilesInFolder: [URL]? = nil) {
        self.Folder = Folder
        self.FilesCount = FilesCount
        self.FilesInFolder = FilesInFolder
    }
    
    private enum CodingKeys: String, CodingKey {
        case idKey, FolderKey
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .idKey)
        Folder = try container.decode(String.self, forKey: .FolderKey)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .idKey)
        try container.encode(Folder, forKey: .FolderKey)
    }
}
