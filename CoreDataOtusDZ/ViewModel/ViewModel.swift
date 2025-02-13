//
//  ViewModel.swift
//  CoreDataOtusDZ
//
//  Created by Вячеслав Вовк on 13.02.2025.
//

import Foundation
import Combine
import CoreData

class ViewModel: ObservableObject {
    private let persistenceContainer = PersistenceController.shared.container
    private var serviceManager = ServiceManager()
    @Published var isLoading = false
    @Published var hasMoreData = true
    private var nextPageURL: String?
    
    @Published var characters: [Item] = []
   
    init() {
        fetchCharactersFromCoreData()
    }
    
    func loadCharacters() {
        guard !isLoading && hasMoreData else { return }
        
        isLoading = true
        Task {
            do {
                let response = try await serviceManager.fetchDataFromAPI(next: nextPageURL)
                await MainActor.run {
                    processPagedResponse(response)
                }
            } catch {
                await MainActor.run {
                    isLoading = false
                }
            }
        }
    }
    
    func loadImage(character: Item) async -> Data? {
        guard character.imageData == nil else {
            return character.imageData
        }
        guard let imageString = character.image else { return nil }
        if let imageData = try? await serviceManager.fetchImage(for: imageString) {
            character.imageData = imageData
            persistenceContainer.viewContext.saveContext()
            return imageData
        }
        return nil
    }
    
    private func fetchCharactersFromCoreData() {
        nextPageURL = UserDefaults.standard.string(forKey: "nextPage")
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        do {
            let result = try persistenceContainer.viewContext.fetch(fetchRequest)
           
            self.characters = result
        }catch {
            print(error)
        }
    }
    
    private func addCharacterToCoreData(characters: [CharacrterModel]) {
        for character in characters {
            guard !self.characters.contains(where: { $0.id == character.id } ) else {
                continue
            }
            let item = Item(context: persistenceContainer.viewContext)
            item.id = Int64(character.id)
            item.name = character.name
            item.image = character.image
            item.timestamp = Date()
            
            persistenceContainer.viewContext.saveContext()
        }
        fetchCharactersFromCoreData()
    }
    
    private func processPagedResponse(_ response: ResponseModel) {
        // Обновляем список ресторанов
        addCharacterToCoreData(characters: response.results)
        nextPageURL = response.info.next
        UserDefaults.standard.set(nextPageURL, forKey: "nextPage")
        isLoading = false
        
    }
}

extension NSManagedObjectContext {
    func saveContext() {
        do {
            try save()
        }catch {
            print(error)
        }
    }
}
