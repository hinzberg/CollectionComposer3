//  ContentView.swift
//  CollectionComposer3
//  Created by Holger Hinzberg on 05.07.23.

import SwiftUI

struct MainView: View {
    
    @State private var doDelete = true
    @State private var destinationPath = ""
    @State private var numbersOfFilesToCopy = ""
    @State private var keywords = ""
    @State private var statusText = "StatusText"
    
    @State private var folders = [
        FolderInfo(Folder: "pictures", FilesCount: 10, FilesInFolder: nil),
        FolderInfo(Folder: "downloads", FilesCount: 11, FilesInFolder: nil),
        FolderInfo(Folder: "documents", FilesCount: 12, FilesInFolder: nil)
    ]
    
    var body: some View {
        
        VStack {
            
            Text("Sourcepaths")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Table(folders) {
                TableColumn("Path") { folder in Text(String(folder.Folder)) }
                TableColumn("Files") { folder in Text(String(folder.FilesCount)) }
            }
                        
            HStack {
                Button("Add Source") { }
                Button("Count Files") { }
                Spacer()
            }
            
            VStack {
                Text("Destinationpath")
                    .frame(maxWidth: .infinity, alignment: .leading)
                HStack {
                    TextField("", text: $destinationPath)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button("...") { }
                }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            VStack {
                Text("Numbers of files to copy")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $numbersOfFilesToCopy)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            VStack {
                Text("Contain Keywords (seperate with comma)")
                    .frame(maxWidth: .infinity, alignment: .leading)
                TextField("", text: $keywords)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Toggle("Delete Original Files", isOn: $doDelete)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            Spacer()
            
            HStack {
                Spacer()
                Button("Copy Files") { }
            }.padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
            
            Text(statusText)
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
