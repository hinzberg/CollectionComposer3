//  MainViewController.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI
import Combine

public class MainViewControler : ObservableObject {
    
    @Published public var dataModel : MainViewDataModel = MainViewDataModel()
    @Published public var statusText = ""
    
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
        if let item = dataModel.folderInfos.firstIndex(where: {$0.id == id}) {
            self.dataModel.folderInfos.remove(at: item)
            self.fileHandler.Save(dataModel: self.dataModel)
        }
    }
    
    public func addSourceFolder() {
        if let folderUrl = self.openFileDialog()
        {
            if folderUrl.path != ""
            {
                let fileHelper = HHFileHelper()
                let foldersInfo = FolderInfo()
                foldersInfo.Folder = folderUrl.path
                foldersInfo.FilesCount = fileHelper.getFilesCount(folderPath: folderUrl.path)
                self.dataModel.folderInfos.append(foldersInfo)
                FileBookmarkHandler.shared.storeFolderInBookmark(url: folderUrl)
                FileBookmarkHandler.shared.saveBookmarksArchive()
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
                FileBookmarkHandler.shared.storeFolderInBookmark(url: folderUrl)
                FileBookmarkHandler.shared.saveBookmarksArchive()
                self.fileHandler.Save(dataModel: self.dataModel)
            }
        }
    }
    
    public func countFiles() {
        
        let fileHelper = HHFileHelper()
        self.dataModel.objectWillChange.send()
        
        let count = self.dataModel.folderInfos.count
        for index in 0..<count
        {
            let info = self.dataModel.folderInfos[index]
            let count = fileHelper.getFilesCount(folderPath: info.Folder)
            info.FilesCount = count
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
    
    func copyFiles()
    {
        self.statusText = ""

        // Scan all folders for the files inside
        for folderInfo in self.dataModel.folderInfos {
            let url = URL(fileURLWithPath: folderInfo.Folder)
            folderInfo.FilesInFolder = self.getFilesURLFromFolder(url)
        }
        
        // Collect random URLs from the Folders
        var itemIndex = 0
        var randomFileUrls = [URL]()
        let keywords = self.dataModel.keywords.components(separatedBy: ",")
        let numberOfFilesToCopy = Int(self.dataModel.numbersOfFilesToCopy)
        
        for _ in 0...numberOfFilesToCopy!
        {
            let folderInfo = self.dataModel.folderInfos[itemIndex]
            if let filesInFolder = folderInfo.FilesInFolder
            {
                if filesInFolder.count  > 0
                {
                    // Pick one random File
                    let randFiles = self.getRandomFileUrls(filesInFolder, count: 1, containingKeywords: keywords)
                    randomFileUrls.append(contentsOf: randFiles)
                }
            }
            
            // The next FolderInfo
            itemIndex = itemIndex + 1
            if itemIndex == self.dataModel.folderInfos.count
            {
                itemIndex = 0
            }
        }
        
        // Copy the random Files to the Destination
        let fileHelper = HHFileHelper()
        let destinationUrl = URL(fileURLWithPath: dataModel.destinationPath);
        let copyCounter = fileHelper.copyFiles(sourceUrls: randomFileUrls, toUrl: destinationUrl)
        self.statusText = "\(copyCounter) files copied"
        
        // Delete original files
        if dataModel.doDelete == true
        {
            for url in randomFileUrls
            {
                let _ = fileHelper.deleteItemAtPath(sourcePath: url.path)
            }
        }
    }
    
    private func getFilesURLFromFolder(_ folderURL: URL) -> [URL]?
    {
        let options: FileManager.DirectoryEnumerationOptions =
            [.skipsHiddenFiles, .skipsSubdirectoryDescendants, .skipsPackageDescendants]
        
        let fileManager = FileManager.default
        let resourceValueKeys = [URLResourceKey.isRegularFileKey, URLResourceKey.typeIdentifierKey]
        
        guard let directoryEnumerator = fileManager.enumerator(at: folderURL, includingPropertiesForKeys: resourceValueKeys,
                                                               options: options, errorHandler: { url, error in
                                                                print("`directoryEnumerator` error: \(error).")
                                                                return true
        }) else { return nil }
        
        var urls: [URL] = []
        for case let url as URL in directoryEnumerator
        {
            do {
                let resourceValues = try (url as NSURL).resourceValues(forKeys: resourceValueKeys)
                guard let isRegularFileResourceValue = resourceValues[URLResourceKey.isRegularFileKey] as? NSNumber else { continue }
                guard isRegularFileResourceValue.boolValue else { continue }
                guard let fileType = resourceValues[URLResourceKey.typeIdentifierKey] as? String else { continue }
                guard UTTypeConformsTo(fileType as CFString, "public.image" as CFString) else { continue }
                urls.append(url)
            }
            catch
            {
                print("Unexpected error occured: \(error).")
            }
        }
        return urls
    }
    
    private func getRandomFileUrls(_ fileURLs:[URL], count:Int, containingKeywords:[String]) -> [URL]
    {
        // You can not get more files than avalible
        var randomFilesCount = count
        if fileURLs.count < randomFilesCount
        {
            randomFilesCount = fileURLs.count
        }
        
        // Fill Dictionary with random entries
        var randomFileUrlsDict = [String:URL]()
        while randomFileUrlsDict.count < randomFilesCount
        {
            let randomPosition = arc4random_uniform( UInt32(fileURLs.count - 1))
            let url = fileURLs[Int(randomPosition)]
            
            var containingAllKeywords = true
            
            for keyword in containingKeywords
            {
                if url.path.caseInsensitiveContains(substring: keyword) == false && keyword != ""
                {
                    containingAllKeywords = false
                    break
                }
            }
            
            if containingAllKeywords == true
            {
                randomFileUrlsDict[url.path] = url
            }
        }
        
        // Transfer Dictionary Keys to Array
        let randomFileUrlsArray = Array(randomFileUrlsDict.values)
        return randomFileUrlsArray
    }
}
