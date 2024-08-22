import SwiftUI

struct CharacterItem: View {
    let character: Character

    var body: some View {
        HStack() {
            LoadImageByUrl(imageUrl: character.image, size: 44)
            
            Spacer().frame(width: 16)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(character.name)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.onPrimaryColor)
                    
                    if character.isFavourite {
                        IconShow(name: "star.fill", size: 14, colorName: Color.primaryColor)
                    }
                }
                
                Text(character.status)
                    .font(.system(size: 14))
                    .foregroundColor(.onSecondaryColor)
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 8)
        .background(Color.secondaryContainerColor)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

#Preview {
    CharacterItem(character: Character(id: 1,
                                       name: "Rick Sanchez",
                                       status: "Alive",
                                       species: "Human",
                                       type: "-",
                                       gender: "Male",
                                       origin: "Earth",
                                       location: "Nevermind",
                                       image: "https://rickandmortyapi.com/api/character/avatar/1.jpeg"))
}
