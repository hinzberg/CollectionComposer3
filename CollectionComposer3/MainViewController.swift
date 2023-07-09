//  MainViewController.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI

public class MainViewControler : ObservableObject {
    
    @Published public var doDelete = true
    @Published public var destinationPath = ""
    @Published public var numbersOfFilesToCopy = ""
    @Published public var keywords = ""
    @Published public var statusText = "StatusText"
    
 
    @Published public var folders : [FolderInfo]  = [
 //       FolderInfo(Folder: "pictures", FilesCount: 10, FilesInFolder: nil),
 //       FolderInfo(Folder: "downloads", FilesCount: 11, FilesInFolder: nil),
 //       FolderInfo(Folder: "documents", FilesCount: 12, FilesInFolder: nil)
    ]
    
    private let fileHandler = FolderInfoFileHandler()
    
    init() {
        let infos = fileHandler.Load()
        if infos.count > 0 {
            folders.removeAll()
            folders.append(contentsOf: infos)
        }
    }
        
    public func removeSourceFolder(id : UUID?) {
        guard let id = id else { return }
        if let item = folders.firstIndex(where: {$0.id == id}) {
            folders.remove(at: item)
        }
    }
        
    public func addSourceFolder() {
        if let folderUrl = self.openFileDialog()
        {
            if folderUrl.path != ""
            {
                let fileHelper = HHFileHelper()
                var foldersInfo = FolderInfo()
                foldersInfo.Folder = folderUrl.path
                foldersInfo.FilesCount = fileHelper.getFilesCount(folderPath: folderUrl.path)
                self.folders.append(foldersInfo)
                self.fileHandler.Save(folderInfos: self.folders)
            }
        }
    }
    
    func openFileDialog() -> URL?
    {
        let fileDialog = NSOpenPanel()
        fileDialog.canChooseFiles = false
        fileDialog.canChooseDirectories = true
        fileDialog.runModal()
        return fileDialog.url
    }
    
    
}
