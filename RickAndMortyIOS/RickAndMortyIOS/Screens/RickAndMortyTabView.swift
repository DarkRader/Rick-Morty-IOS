import SwiftUI

struct RickAndMortyTabView: View {
    @State private var tabSelection = 1
    @State var isHiddenBar = false 
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $tabSelection) {
            CharacterListView(isHiddenBar: $isHiddenBar)
                .tag(1)
            
            FavouriteView(isHiddenBar: $isHiddenBar)
                .tag(2)
        }
        .overlay(alignment: .bottom) {
            if !isHiddenBar {
                CustomTabView(tabSelection: $tabSelection)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        RickAndMortyTabView()
            .preferredColorScheme(.light)
        RickAndMortyTabView()
            .preferredColorScheme(.dark)
    }
}
