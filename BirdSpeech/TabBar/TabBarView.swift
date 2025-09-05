import SwiftUI

struct TabBarView: View {
    @StateObject var tabBarModel =  TabBarViewModel()
    @State private var selectedTab: CustomTabBar.TabType = .Home
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                if selectedTab == .Home {
                    MainView()
                } else if selectedTab == .History {
                    HistoryView()
                } else if selectedTab == .Translator {
                    TranslatorView()
                }
            }
            .frame(maxHeight: .infinity)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
            }
            
            CustomTabBar(selectedTab: $selectedTab)
        }
        .ignoresSafeArea(.keyboard)
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    TabBarView()
}

struct CustomTabBar: View {
    @Binding var selectedTab: TabType
    
    enum TabType: Int {
        case Home
        case History
        case Translator
    }
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ZStack {
                Rectangle()
                    .fill(Color(red: 26/255, green: 23/255, blue: 23/255))
                    .frame(height: 120)
                    .cornerRadius(20)
                    .edgesIgnoringSafeArea(.bottom)
                    .offset(y: 55)
            }
            
            HStack(spacing: 0) {
                TabBarItem(imageName: "tab1", tab: .Home, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab2", tab: .History, selectedTab: $selectedTab)
                TabBarItem(imageName: "tab3", tab: .Translator, selectedTab: $selectedTab)
            }
            .padding(.top, 15)
            .padding(.horizontal)
            .frame(height: 60)
        }
        .frame(width: 300)
    }
}

struct TabBarItem: View {
    let imageName: String
    let tab: CustomTabBar.TabType
    @Binding var selectedTab: CustomTabBar.TabType
    
    var body: some View {
        Button(action: {
            selectedTab = tab
        }) {
            VStack(spacing: 8) {
                Image(selectedTab == tab ? imageName + "Picked" : imageName)
                    .resizable()
                    .frame(width: 24, height: 24)
                    
                
                Text("\(tab)")
                    .MontserratMeidum(size: 12, color: selectedTab == tab ? Color(red: 19/255, green: 83/255, blue: 255/255) : Color.white)
            }
            .frame(maxWidth: .infinity)
        }
    }
}
