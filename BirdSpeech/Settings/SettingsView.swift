import SwiftUI

struct Person {
    var imageName: String
    var name: String
    var isSelected = false
}

struct SettingsView: View {
    @StateObject var settingsModel =  SettingsViewModel()
    @State var showLanguage = false
    @Environment(\.presentationMode) var presentationMode
    let grid = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        ZStack {
            Image(.bgMain)
                .resizable().ignoresSafeArea()
            
            VStack(spacing: 30) {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Text("Settings")
                        .MontserratSemiBold(size: 14)
                    
                    Spacer()
                    
                    Button(action: {
                  
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                    }
                    .hidden()
                    .disabled(true)
                }
                .padding()
                
                VStack {
                    ZStack(alignment: .trailing) {
                        if let selectedPerson = settingsModel.persons.first(where: { $0.isSelected }) {
                            Image(selectedPerson.imageName)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width > 600 ? 250 : 156, height: UIScreen.main.bounds.width > 600 ? 250 : 156)
                        }
                        
                        Button(action: {
                            withAnimation {
                                showLanguage = true
                            }
                        }) {
                            Image(UserDefaults.standard.string(forKey: "selectedLanguage") ?? "france")
                                .resizable()
                                .frame(width: 84, height: 84)
                        }
                        .offset(x: UIScreen.main.bounds.width > 600 ? 40 : 60)
                    }
                    
                    if let selectedPerson = settingsModel.persons.first(where: { $0.isSelected}) {
                        Text(selectedPerson.name)
                            .MontserratSemiBold(size: 24)
                    }
                }
                
                VStack {
                    Text("Select avatar:")
                        .MontserratSemiBold(size: 14)
                    
                    ScrollView(showsIndicators: false) {
                        LazyVGrid(columns: grid) {
                            ForEach(0..<settingsModel.persons.count, id: \.self) { index in
                                Button(action: {
                                    settingsModel.selectPerson(at: index)
                                }) {
                                    ZStack(alignment: .topTrailing) {
                                        VStack {
                                            Image(settingsModel.persons[index].imageName)
                                                .resizable()
                                                .frame(width: UIScreen.main.bounds.width > 600 ? 250 : 156, height: UIScreen.main.bounds.width > 600 ? 250 : 156)
                                            
                                            Text(settingsModel.persons[index].name)
                                                .MontserratSemiBold(size: 14)
                                        }
                                        
                                        if settingsModel.persons[index].isSelected {
                                            Image(.selected)
                                                .resizable()
                                                .frame(width: 36, height: 36)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                }
            }
            
            if showLanguage {
                SelectedLanguage(show: $showLanguage)
            }
        }
    }
}

#Preview {
    SettingsView()
}

struct SelectedLanguage: View {
    let arrayCountry = [["France" : "france"], ["Italy" : "italy"], ["Germany" : "germany"],
                        ["UK" : "uk"], ["Russia" : "russia"], ["Portugal" : "portugal"], ["Spain" : "spain"]]
    
    @State private var selectedCountry: (name: String, image: String) = (name: UserDefaults.standard.string(forKey: "selectedLanguageName") ?? "France", image: UserDefaults.standard.string(forKey: "selectedLanguage") ?? "france")
    @State private var showDropdown = false
    @Binding var show: Bool
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .fill(Color(red: 26/255, green: 23/255, blue: 23/255))
                    .frame(width: 280, height: 395)
                    .overlay {
                        VStack(spacing: 25) {
                            Image(.language)
                                .resizable()
                                .frame(width: 96, height: 96)
                            
                            Text("Select language:")
                                .MontserratRegular(size: 20)
                            
                            Rectangle()
                                .fill(Color(red: 23/255, green: 19/255, blue: 19/255))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 86/255, green: 85/255, blue: 126/255), lineWidth: 2)
                                        .overlay {
                                            VStack(spacing: 0) {
                                                HStack {
                                                    HStack(spacing: 10) {
                                                        Image(selectedCountry.image)
                                                            .resizable()
                                                            .frame(width: 20, height: 20)
                                                        
                                                        Text(selectedCountry.name)
                                                            .MontserratRegular(size: 14)
                                                    }
                                                    
                                                    Spacer()
                                                    
                                                    Button(action: {
                                                        withAnimation {
                                                            showDropdown.toggle()
                                                        }
                                                    }) {
                                                        Image(systemName: "chevron.down")
                                                            .foregroundStyle(.white)
                                                    }
                                                }
                                                .padding(.horizontal, 10)
                                                .frame(height: 39)
                                                
                                                if showDropdown {
                                                    ScrollView(showsIndicators: false) {
                                                        VStack(spacing: 0) {
                                                            ForEach(arrayCountry, id: \.self) { dict in
                                                                let name = dict.keys.first!
                                                                let img = dict.values.first!
                                                                Divider().background(Color.gray)
                                                                
                                                                Button(action: {
                                                                    selectedCountry = (name: name, image: img)
                                                                    withAnimation {
                                                                        showDropdown = false
                                                                    }
                                                                }) {
                                                                    HStack {
                                                                        Image(img)
                                                                            .resizable()
                                                                            .frame(width: 20, height: 20)
                                                                        Text(name)
                                                                            .MontserratRegular(size: 14)
                                                                        Spacer()
                                                                    }
                                                                    .padding(.vertical, 8)
                                                                    .padding(.horizontal, 10)
                                                                }
                                                            }
                                                        }
                                                    }
                                                    .frame(width: 215)
                                                }
                                            }
                                        }
                                }
                                .frame(width: 220, height: showDropdown ? 200 : 39)
                                .cornerRadius(10)
                            
                            if !showDropdown {
                                VStack(spacing: 20) {
                                    Button(action: {
                                        UserDefaults.standard.set(selectedCountry.image, forKey: "selectedLanguage")
                                        UserDefaults.standard.set(selectedCountry.name, forKey: "selectedLanguageName")
                                        show.toggle()
                                    }) {
                                        Rectangle()
                                            .fill(Color(red: 19/255, green: 83/255, blue: 255/255))
                                            .frame(width: 220, height: 50)
                                            .overlay {
                                                Text("Save settings")
                                                    .MontserratMeidum(size: 16)
                                            }
                                            .cornerRadius(10)
                                    }
                                    
                                    Button(action: {
                                        show.toggle()
                                    }) {
                                        Text("Cancel")
                                            .MontserratMeidum(size: 16, color: Color(red: 86/255, green: 85/255, blue: 126/255))
                                    }
                                }
                            }
                        }
                    }
                    .cornerRadius(20)
            }
        }
    }
}
