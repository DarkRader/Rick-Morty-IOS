import SwiftUI
import CoreData

class CharacterListViewModel: ObservableObject {
    @Published private(set) var characters: [Character] = []
    @Published private(set) var state: CharactersLoadingState = .loading
    
    @MainActor
    func fetchCharacters(context: NSManagedObjectContext) async {
        if !loadCharactersFromCoreData(context: context) {
            await fetchCharactersFromApi(context: context)
        }
    }
    
    private func loadCharactersFromCoreData(context: NSManagedObjectContext) -> Bool {
        let fetchRequest: NSFetchRequest<CoreDataCharacter> = CoreDataCharacter.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            let results = try context.fetch(fetchRequest)
            if !results.isEmpty {
                self.characters = results.map { coreDataCharacter in
                    Character(
                        id: Int(coreDataCharacter.id),
                        name: coreDataCharacter.name ?? "",
                        status: coreDataCharacter.status ?? "",
                        species: coreDataCharacter.species ?? "",
                        type: coreDataCharacter.type ?? "",
                        gender: coreDataCharacter.gender ?? "",
                        origin: coreDataCharacter.origin ?? "",
                        location: coreDataCharacter.location ?? "",
                        image: coreDataCharacter.image ?? "",
                        isFavourite: coreDataCharacter.isFavourite
                    )
                }
                return true
            }
        } catch {
            print("Failed to fetch from Core Data: \(error)")
        }
        return false
    }
    
    private func saveCharactersToCoreData(_ characters: [Character], context: NSManagedObjectContext) {
        for character in characters {
            let coreDataCharacter = CoreDataCharacter(context: context)
            coreDataCharacter.id = Int64(character.id)
            coreDataCharacter.name = character.name
            coreDataCharacter.status = character.status
            coreDataCharacter.species = character.species
            coreDataCharacter.type = character.type
            coreDataCharacter.gender = character.gender
            coreDataCharacter.origin = character.origin
            coreDataCharacter.location = character.location
            coreDataCharacter.image = character.image
        }
        
        DataController.shared.save()
    }
    
    @MainActor
    func fetchCharactersFromApi(context: NSManagedObjectContext) async {
        var request = URLRequest(url: URL(string: "https://rickandmortyapi.com/api/character")!)
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let getData = try JSONDecoder().decode(CharactersRequest.self, from: data)
            
            let characterDataList = getData.results.map { character in
                Character(
                    id: character.id,
                    name: character.name,
                    status: character.status,
                    species: character.species,
                    type: character.type,
                    gender: character.gender,
                    origin: character.origin.name,
                    location: character.location.name,
                    image: character.image
                )
            }
            
            self.characters = characterDataList
            saveCharactersToCoreData(characterDataList, context: context)
            state = .characters(getData.results)
        } catch {
            state = .error(error)
            print("[ERROR]", error)
        }
    }
    
    @MainActor
    func searchCharacters(searchCharacters: String) async {
        var request = URLRequest(url: URL(string: "https://rickandmortyapi.com/api/character/?name=\(searchCharacters)")!)
        
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let getData = try JSONDecoder().decode(CharactersRequest.self, from: data)
            
            let characterDataList = getData.results.map { character in
                Character(
                    id: character.id,
                    name: character.name,
                    status: character.status,
                    species: character.species,
                    type: character.type,
                    gender: character.gender,
                    origin: character.origin.name,
                    location: character.location.name,
                    image: character.image
                )
            }
            
            self.characters = characterDataList
        } catch {
            print("[ERROR]", error)
        }
    }
}
