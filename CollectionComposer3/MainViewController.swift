//  MainViewController.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI
import Combine

public class MainViewControler : ObservableObject {
    
    @Published public var dataModel : MainViewDataModel = MainViewDataModel()
    @Published public var statusText = "StatusText"
    
    private let fileHandler = MainViewDataModelFileHandler()
    private var anyCancellable: AnyCancellable? = nil
        
    init() {
        dataModel = fileHandler.Load()
        // Forward Changed Event from the SubObject to the View
        anyCancellable = dataModel.objectWillChange.sink { [weak self] (_) in self?.objectWillChange.send() }
    }
    
    public func saveDataModel() {
        self.fileHandler.Save(dataModel: self.dataModel)
    }
        
    public func removeSourceFolder(id : UUID?) {
        guard let id = id else { return }
        if let item = dataModel.folders.firstIndex(where: {$0.id == id}) {
            self.dataModel.folders.remove(at: item)
            self.fileHandler.Save(dataModel: self.dataModel)
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
                self.dataModel.folders.append(foldersInfo)
                self.fileHandler.Save(dataModel: self.dataModel)
            }
        }
    }
    
    public func addDestinationFolder() {
        if let folderUrl = self.openFileDialog()
        {
            if folderUrl.path != ""
            {
                self.dataModel.destinationPath = folderUrl.path
                self.fileHandler.Save(dataModel: self.dataModel)
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
