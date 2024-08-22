import SwiftUI
import CoreData

class CharacterDetailViewModel: ObservableObject {
    @Published private(set) var character: Character? = nil
    @Published var idCharacter: Int
    @Published var isFavourite: Bool = false
    
    init(
        idCharacter: Int
    ) {
        self.idCharacter = idCharacter
    }
    
    @MainActor
    func getCharacter(context: NSManagedObjectContext) async {
        if idCharacter > 19 {
            await fetchCharacterFromApi()
        } else {
            loadCharactersFromCoreData(context: context)
        }
    }
    
    private func loadCharactersFromCoreData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CoreDataCharacter> = CoreDataCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", idCharacter)
        fetchRequest.fetchLimit = 1
        
        do {
            let results = try context.fetch(fetchRequest)
            
            if let coreDataCharacter = results.first {
                // Map CoreDataCharacter to Character
                character = Character(
                    id: Int(coreDataCharacter.id),
                    name: coreDataCharacter.name ?? "",
                    status: coreDataCharacter.status ?? "",
                    species: coreDataCharacter.species ?? "",
                    type: coreDataCharacter.type ?? "",
                    gender: coreDataCharacter.gender ?? "",
                    origin: coreDataCharacter.origin ?? "",
                    location: coreDataCharacter.location ?? "",
                    image: coreDataCharacter.image ?? ""
                )
                isFavourite = coreDataCharacter.isFavourite
            } else {
                print("Character with ID \(idCharacter) not found.")
            }
         } catch {
             print("Failed to fetch character with id \(idCharacter): \(error.localizedDescription)")
         }
    }
    
    func updateCharacterFavouriteStatus(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CoreDataCharacter> = CoreDataCharacter.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %d", idCharacter)
        fetchRequest.fetchLimit = 1
        
        if isFavourite {
            self.isFavourite = false
        } else {
            self.isFavourite = true
        }
        
        do {
            let characters = try context.fetch(fetchRequest)
            
            if let coreDataCharacter = characters.first {
                coreDataCharacter.isFavourite = self.isFavourite
                DataController.shared.save()
            } else {
                print("Character with ID \(idCharacter) not found.")
            }
        } catch {
            print("Failed to fetch character: \(error.localizedDescription)")
        }
    }
    
    @MainActor
    private func fetchCharacterFromApi() async {
        var request = URLRequest(url: URL(string: "https://rickandmortyapi.com/api/character/\(idCharacter)")!)
        request.httpMethod = "GET"
        request.timeoutInterval = 5
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            let characterApi = try JSONDecoder().decode(CharacterApi.self, from: data)
            
            let character = Character(
                    id: characterApi.id,
                    name: characterApi.name,
                    status: characterApi.status,
                    species: characterApi.species,
                    type: characterApi.type,
                    gender: characterApi.gender,
                    origin: characterApi.origin.name,
                    location: characterApi.location.name,
                    image: characterApi.image
                )
            
            self.character = character
            
        } catch {
            print("[ERROR]", error)
        }
    }
    
    func addToFavourite() {
        isFavourite.toggle()
    }
}

