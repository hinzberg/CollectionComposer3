//  FolderInfoFileHandler.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 09.07.23.

import Foundation

public class FolderInfoFileHandler{
    
    private var filename = ""
    
    init() {
        let docsDic = HHFileHelper.getDocumentsDirectory();
        self.filename = docsDic + "folderinfo"
    }
    
    public func Save(folderInfos : [FolderInfo])
    {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(folderInfos)
            let pathAsURL = URL(fileURLWithPath: self.filename)
            try data.write(to: pathAsURL)
            print("Repository saved")
        } catch let error {
            print("Repository not saved")
            print(error.localizedDescription)
        }
    }
    
    public func Load() -> [FolderInfo]
    {
        var infos = [FolderInfo]()
        guard  let data = try? Data(contentsOf: URL(fileURLWithPath: self.filename), options: []) else {return infos}
                
        do {
            let decoder = JSONDecoder()
            let loadedInfos : [FolderInfo] = try decoder.decode([FolderInfo].self, from: data)
            infos.append(contentsOf: loadedInfos)
            print("Repository loaded")
        } catch let error {
            print("Repository not loaded")
            print(error.localizedDescription)
        }
        return infos
    }
}
