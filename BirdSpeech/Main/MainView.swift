import SwiftUI

struct Bird {
    var imageName: String
    var name: String
    var isSelected = false
}
struct MainView: View {
    @StateObject var mainModel =  MainViewModel()
    let grid = [GridItem(.flexible()), GridItem(.flexible())]
    @State var isSettings = false
    
    var body: some View {
        ZStack {
            Image(.bgMain)
                .resizable().ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                    }
                    .hidden()
                    .disabled(true)
                    
                    Spacer()
                    
                    Text("Select bird")
                        .MontserratSemiBold(size: 14)
                    
                    Spacer()
                    
                    Button(action: {
                        isSettings = true
                    }) {
                        Image(systemName: "gearshape")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                    }
                    
                }
                .padding(.horizontal)
                
                ScrollView(showsIndicators: false) {
                    LazyVGrid(columns: grid) {
                        ForEach(0..<mainModel.birds.count, id: \.self) { index in
                            Button(action: {
                                mainModel.selectBird(at: index)
                            }) {
                                ZStack(alignment: .topTrailing) {
                                    VStack {
                                        Image(mainModel.birds[index].imageName)
                                            .resizable()
                                            .frame(width: UIScreen.main.bounds.width > 600 ? 300 : 156, height: UIScreen.main.bounds.width > 600 ? 300 : 156)
                                        
                                        Text(mainModel.birds[index].name)
                                            .MontserratSemiBold(size: 14)
                                    }
                                    
                                    if mainModel.birds[index].isSelected {
                                        Image(.selected)
                                            .resizable()
                                            .frame(width: 36, height: 36)
                                    }
                                }
                            }
                        }
                    }
                    .padding()
                    
                    Color.clear.frame(height: 60)
                }
            }
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
    }
}

#Preview {
    MainView()
}

