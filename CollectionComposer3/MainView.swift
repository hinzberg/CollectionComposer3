//  ContentView.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI

struct MainView: View {
    
    @ObservedObject var viewController = MainViewControler()
    @State public var tableSelectedFolderId : FolderInfo.ID? = nil
    
    var body: some View {
        
        VStack {
            Text("Sourcepaths")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Table(viewController.folders, selection: $tableSelectedFolderId ) {
                TableColumn("Path") { folder in Text(String(folder.Folder)) }
                TableColumn("Files") { folder in Text(String(folder.FilesCount)) }
            }
                        
            HStack {
                Button("Add Folder") {  viewController.addSourceFolder() }
                Button("Count Files") { }
                Spacer()
                Button("Remove Folder") { viewController.removeSourceFolder(id: self.tableSelectedFolderId) }
            }
            
            VStack {
                Text("Destinationpath")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    TextField("", text: $viewController.destinationPath)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("...") { }
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Text("Numbers of files to copy")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $viewController.numbersOfFilesToCopy)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Text("Contain Keywords (seperate with comma)")
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
