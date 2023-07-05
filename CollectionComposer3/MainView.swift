//  ContentView.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewController = MainViewControler()
    @State public var tableSelectedFolderId : FolderInfo.ID? = nil
    
    var body: some View {
        
        VStack {
            Text("Source Folders")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Table(viewController.folders, selection: $tableSelectedFolderId ) {
                TableColumn("Folder") { folder in Text(String(folder.Folder)) }
                TableColumn("Number of Files") { folder in Text(String(folder.FilesCount)) }
            }
                        
            HStack {
                Button("Add Folder") {  viewController.addSourceFolder() }
                Button("Count Files") { }
                Spacer()
                Button("Remove Folder") { viewController.removeSourceFolder(id: self.tableSelectedFolderId) }
            }
            
            VStack {
                Text("Destination Folder")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    TextField("", text: $viewController.destinationPath)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("...") { }
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Text("Numbers of Files to copy")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $viewController.numbersOfFilesToCopy)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Text("Contains Keywords (seperate with comma)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $viewController.keywords)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Toggle("Delete Original Files", isOn: $viewController.doDelete)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Copy Files") { }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            Text(viewController.statusText)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
