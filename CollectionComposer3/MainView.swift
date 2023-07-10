//  ContentView.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewController  = MainViewControler()
    @State public var tableSelectedFolderId : FolderInfo.ID? = nil
    
    @FocusState private var isFocusedDestinationPath: Bool
    @FocusState private var isFocusedNumbersOfFilesToCopy: Bool
    @FocusState private var isFocusedKeywords: Bool
    
    var body: some View {
        
        VStack {
            
            Text("Source Folders")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Table(viewController.dataModel.folderInfos, selection: $tableSelectedFolderId ) {
                TableColumn("Folder") { folder in Text(String(folder.Folder)) }
                TableColumn("Number of Files") { folder in Text(String(folder.FilesCount)) }
            }
            
            HStack {
                Button("Add Folder") {  viewController.addSourceFolder() }
                Button("Remove Folder") { viewController.removeSourceFolder(id: self.tableSelectedFolderId) }
                Spacer()
                Button("Count Files") { viewController.countFiles() }
            }
            
            VStack {
                Text("Destination Folder")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    TextField("", text: $viewController.dataModel.destinationPath)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .focused($isFocusedDestinationPath)
                        .onChange(of: isFocusedDestinationPath) { newValue in
                            if !newValue {
                                self.viewController.saveDataModel()
                            }
                        }
                    Button("...") { viewController.addDestinationFolder() }
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Text("Numbers of Files to copy")
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                TextField("", text: $viewController.dataModel.numbersOfFilesToCopy)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focused($isFocusedNumbersOfFilesToCopy)
                    .onChange(of: isFocusedNumbersOfFilesToCopy) { newValue in
                        if !newValue {
                            self.viewController.saveDataModel()
                        }
                    }
            }
            
            VStack {
                Text("Contains Keywords (seperate with comma)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $viewController.dataModel.keywords)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .focused($isFocusedKeywords)
                    .onChange(of: isFocusedKeywords) { newValue in
                        if !newValue {
                            self.viewController.saveDataModel()
                        }
                    }
            }
            
            VStack{
                Toggle("Delete Original Files", isOn: $viewController.dataModel.doDelete)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .onChange(of: viewController.dataModel.doDelete) { newValue in
                        self.viewController.saveDataModel()
                    }
                
                Spacer()
                
                HStack {
                    Spacer()
                    Button("Copy Files") { viewController.copyFiles() }
                }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                
                Text(viewController.statusText)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
