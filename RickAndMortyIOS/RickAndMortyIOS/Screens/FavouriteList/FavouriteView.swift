import SwiftUI


struct FavouriteView: View {
    @StateObject private var viewModel = FavouriteViewModel()
    @Binding var isHiddenBar: Bool
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        ZStack {
            ContainerRelativeShape()
                .fill(Color.primaryContainerColor)
                .ignoresSafeArea()
            
            NavigationStack {
                ScrollView {
                    VStack() {
                        ForEach(viewModel.characters) { character in
                            NavigationLink(destination: CharacterDetailView(idCharacter: character.id, isHiddenBar: $isHiddenBar)) {
                                CharacterItem(character: character)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Favourite")
                                .font(.system(size: 28, weight: .bold))
                                .padding(8)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                
            }
        }
        .onAppear {
            isHiddenBar = false
            viewModel.loadFavouriteCharactersFromCoreData(context: moc)
        }
        .onChange(of: isHiddenBar) {
            viewModel.loadFavouriteCharactersFromCoreData(context: moc)
        }
    }
}

struct FavouriteView_Previews: PreviewProvider {
    static var previews: some View {
        FavouriteView(isHiddenBar: .constant(false))
            .preferredColorScheme(.light)
        FavouriteView(isHiddenBar: .constant(false))
            .preferredColorScheme(.dark)
    }
}
