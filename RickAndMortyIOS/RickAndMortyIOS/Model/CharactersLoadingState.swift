import Foundation

enum CharactersLoadingState {
        case loading
        case error(Error)
        case characters([CharacterApi])
}
