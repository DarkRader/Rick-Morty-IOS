import SwiftUI
import CoreData

struct CharacterListView: View {
    @StateObject private var viewModel = CharacterListViewModel()
    @State private var searchText = ""
    @Binding var isHiddenBar: Bool
    
    @Environment(\.managedObjectContext) var moc
    
    var body: some View {
        NavigationStack {
            ZStack {
                ContainerRelativeShape()
                    .fill(Color.primaryContainerColor)
                    .ignoresSafeArea()
                
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
            }
//            .navigationTitle("Character")
//            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Characters")
                            .font(.system(size: 28, weight: .bold))
                            .padding(8)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
            }
        }
        .onAppear {
            isHiddenBar = false 
            Task {
                await viewModel.fetchCharacters(context: moc)
            }
        }
        .onChange(of: isHiddenBar) {
            Task {
                await viewModel.fetchCharacters(context: moc)
            }
        }
        .searchable(text: $searchText, prompt: "Search character")
        .onChange(of: searchText) {
            Task {
                if !searchText.isEmpty {
                    await viewModel.searchCharacters(searchCharacters: searchText)
                } else {
                    await viewModel.fetchCharacters(context: moc)
                }
            }
        }
    }
}

struct CharacterListView_Previews: PreviewProvider {
    static var previews: some View {
        CharacterListView(isHiddenBar: .constant(false))
            .preferredColorScheme(.light)
        CharacterListView(isHiddenBar: .constant(false))
            .preferredColorScheme(.dark)
    }
}
