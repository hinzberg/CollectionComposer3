//
//  MainViewDataModelFileHandler.swift
//  CollectionComposer3
//
//  Created by Holger Hinzberg on 09.07.23.
//

import Foundation

public class MainViewDataModelFileHandler{
    
    private var filename = ""
    
    init() {
        let docsDic = HHFileHelper.getDocumentsDirectory();
        self.filename = docsDic + "collectioncomposer3"
    }
    
    public func Save(dataModel : MainViewDataModel)
    {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(dataModel)
            let pathAsURL = URL(fileURLWithPath: self.filename)
            try data.write(to: pathAsURL)
            print("Datamodel saved")
        } catch let error {
            print("Datamodel not saved")
            print(error.localizedDescription)
        }
    }
    
    public func Load() -> MainViewDataModel
    {
        var dataModel = MainViewDataModel()
        guard  let data = try? Data(contentsOf: URL(fileURLWithPath: self.filename), options: []) else {return dataModel}
                
        do {
            let decoder = JSONDecoder()
            let loaded : MainViewDataModel = try decoder.decode(MainViewDataModel.self, from: data)
            dataModel = loaded
            print("Datamodel loaded")
        } catch let error {
            print("Datamodel not loaded")
            print(error.localizedDescription)
        }
        return dataModel
    }
}
