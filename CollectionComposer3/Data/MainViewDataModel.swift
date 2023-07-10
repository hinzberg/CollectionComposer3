//  MainViewDataModel.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 09.07.23.

import SwiftUI
import Combine

public class MainViewDataModel : ObservableObject , Codable {
    @Published public var doDelete = true
    @Published public var destinationPath = ""
    @Published public var numbersOfFilesToCopy = ""
    @Published public var keywords = ""
    @Published public var folderInfos : [FolderInfo]  = []
        
    public init() {
    }
        
    private enum CodingKeys: String, CodingKey {
        case doDeleteKey
        case destinationPathKey
        case numbersOfFilesToCopyKey
        case keywordsKey
        case foldersKey
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(doDelete, forKey:  .doDeleteKey)
        try container.encode(destinationPath, forKey: .destinationPathKey)
        try container.encode(numbersOfFilesToCopy, forKey: .numbersOfFilesToCopyKey)
        try container.encode(keywords, forKey: .keywordsKey)
        try container.encode(folderInfos, forKey: .foldersKey)
    }
    

        
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        doDelete = try container.decode(Bool.self, forKey: .doDeleteKey)
        destinationPath = try container.decode(String.self, forKey: .destinationPathKey)
        numbersOfFilesToCopy = try container.decode(String.self, forKey: .numbersOfFilesToCopyKey)
        keywords = try container.decode(String.self, forKey: .keywordsKey)
        folderInfos = try container.decode([FolderInfo].self, forKey: .foldersKey)
    }
}
