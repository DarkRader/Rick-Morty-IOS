import SwiftUI
import CoreData

struct CharacterDetailView: View {
    @StateObject private var viewModel: CharacterDetailViewModel
    @Binding var isHiddenBar: Bool
    
    @Environment(\.managedObjectContext) var moc
    
    init(idCharacter: Int, isHiddenBar: Binding<Bool>) {
        _viewModel = StateObject(wrappedValue: CharacterDetailViewModel(idCharacter: idCharacter))
        _isHiddenBar = isHiddenBar
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                ContainerRelativeShape()
                    .fill(Color.primaryContainerColor)
                    .ignoresSafeArea()
                
                VStack {
                    CharacterDetail(
                        character: viewModel.character,
                        onFavouriteClick: { viewModel.updateCharacterFavouriteStatus(context: moc) },
                        isFavourite: viewModel.isFavourite
                    )
                    Spacer()
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
            }
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                Task {
                    isHiddenBar = true
                    await viewModel.getCharacter(context: moc)
                }
            }
            .onDisappear {
                isHiddenBar = false
            }
        }
    }
}

struct CharacterDetail: View {
    var character: Character?
    var onFavouriteClick: () -> Void
    let isFavourite: Bool
    
    var body: some View {
        VStack {
            CharacterCardHeader(character: character, onFavouriteClick: onFavouriteClick, isFavourite: isFavourite)
            Spacer().frame(height: 18)
            Divider()
                .foregroundColor(.gray)
                .frame(maxWidth: .infinity)
                .frame(height: 1)
            CharacterCardDetail(character: character)
        }
        .padding(.vertical, 16)
        .background(Color.secondaryContainerColor)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        
        Spacer()
    }
}

struct CharacterCardHeader: View {
    var character: Character?
    var onFavouriteClick: () -> Void
    let isFavourite: Bool
    
    var body: some View {
        HStack(alignment: .top) {
            LoadImageByUrl(imageUrl: character?.image, size: 144)
            
            VStack(alignment: .leading, spacing: 14) {
                Text("Name")
                    .font(.bodyMedium)
                    .foregroundColor(.onSecondaryColor)
                
                Text(character?.name ?? "Default")
                    .font(.headlineMedium)
                    .foregroundColor(.onPrimaryColor)
            }
            .padding(.leading, 8)
            
            Spacer()
            
            Button(
                action: {
                onFavouriteClick()
            },
                label: {
                    if isFavourite {
                        IconShow(name: "star.fill", size: 25, colorName: Color.primaryColor)
                    } else {
                        IconShow(name: "star", size: 25, colorName: Color.onSecondaryColor)
                    }
            })
        }
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CharacterCardDetail: View {
    var character: Character?
    
    var body: some View {
        VStack(spacing: 32) {
            CharacterSpecificDetail(text: "Status      ", characterParameter: character?.status)
            CharacterSpecificDetail(text: "Species    ", characterParameter: character?.species)
            CharacterSpecificDetail(text: "Type          ", characterParameter: character?.type)
            CharacterSpecificDetail(text: "Gender      ", characterParameter: character?.gender)
            CharacterSpecificDetail(text: "Origin        ", characterParameter: character?.origin)
            CharacterSpecificDetail(text: "Location    ", characterParameter: character?.location)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct CharacterSpecificDetail: View {
    let text: String
    let characterParameter: String?
    
    var body: some View {
        HStack {
            Text(text)
                .font(.bodySmall)
                .foregroundColor(.onSecondaryColor)
            
//            Spacer()
            
            Text(characterParameter?.isEmpty == false ? characterParameter! : "-")
                .font(.headlineSmall)
                .foregroundColor(.onPrimaryColor)
                .padding(.horizontal, 16)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
    }
}

#Preview {
    CharacterDetailView(idCharacter: 1, isHiddenBar: .constant(true))
}
