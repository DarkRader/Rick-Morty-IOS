import SwiftUI
import CoreData

class FavouriteViewModel: ObservableObject {
    @Published private(set) var characters: [Character] = []
    
    func loadFavouriteCharactersFromCoreData(context: NSManagedObjectContext) {
        let fetchRequest: NSFetchRequest<CoreDataCharacter> = CoreDataCharacter.fetchRequest()
        
        // Add a predicate to filter only favourite characters
        fetchRequest.predicate = NSPredicate(format: "isFavourite == %@", NSNumber(value: true))
        
        // Sort by id in ascending order
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
            }
        } catch {
            print("Failed to fetch favourite characters from Core Data: \(error)")
        }
    }
}
