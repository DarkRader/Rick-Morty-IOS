import SwiftUI

struct CustomTabView: View {
    @Binding  var tabSelection: Int
    @Namespace private var animationNamespace
    
    let tabBarItems: [(image: String, title: String)] = [
        ("rick", "Characters"),
        ("favourite", "Favourities"),
    ]
    
    var body: some View {
        ZStack {
            Capsule()
                .frame(height: 62)
                .frame(width: 182)
                .foregroundColor(.secondaryContainerColor)
                .shadow(radius: 2)
            
            HStack {
                ForEach(0..<2) { index in
                    Button {
                        tabSelection = index + 1
                    } label: {
                        VStack(spacing: 8) {
                                       
                            
                            if index + 1 == tabSelection {
                                Image(tabBarItems[index].image)
                                    .renderingMode(.template)
                                    .foregroundColor(.primaryColor)
                                    .padding(.horizontal, 16)
                            } else {
                                Image(tabBarItems[index].image)
                                    .renderingMode(.template)
                                    .foregroundColor(.onSecondaryColor)
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                }
            }
            .frame(height: 62)
            .frame(width: 182)
            .clipShape(Capsule())
        }
        .padding(.horizontal)
    }
}

struct CustomTabView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabView(tabSelection: .constant(1))
            .preferredColorScheme(.light)
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
        CustomTabView(tabSelection: .constant(1))
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
            .padding(.vertical)
    }
}
