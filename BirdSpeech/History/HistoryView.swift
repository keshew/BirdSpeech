import SwiftUI

struct HistoryView: View {
    @StateObject var historyModel =  HistoryViewModel()
    @State var showDelete = false
    @State var isSettings = false
    @State var selectedIndex: Int? = nil
    @State var selectedAudio: SaveAudio? = nil
    @State var isShowTranslatedView = false
    
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
                    
                    Text("History")
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
                    if !historyModel.savedAudios.isEmpty {
                        VStack(spacing: 15) {
                            ForEach(Array(historyModel.savedAudios.enumerated()), id: \.element.id) { index, audio in
                                Rectangle()
                                    .fill(Color(red: 26/255, green: 23/255, blue: 23/255))
                                    .overlay {
                                        HStack(spacing: 15) {
                                            Image(audio.imageBird)
                                                .resizable()
                                                .frame(width: 64, height: 64)
                                            
                                            VStack(alignment: .leading) {
                                                Text(audio.nameAudio)
                                                    .MontserratSemiBold(size: 14)
                                                
                                                HStack {
                                                    Image(.mic)
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                    
                                                    Text(audio.duration)
                                                        .MontserratSemiBold(size: 14, color: Color(red: 19/255, green: 83/255, blue: 255/255))
                                                }
                                            }
                                            
                                            Spacer()
                                            
                                            VStack {
                                                Button(action: {
                                                    historyModel.playAudio(audio)
                                                }) {
                                                    Image(historyModel.currentlyPlayingID == audio.id && historyModel.isPlaying ? .pause : .playRecord)
                                                        .resizable()
                                                        .frame(width: 34, height: 34)
                                                }
                                                
                                                Button(action: {
                                                    withAnimation {
                                                        selectedAudio = audio
                                                        showDelete = true
                                                    }
                                                }) {
                                                    Image(.trash)
                                                        .resizable()
                                                        .frame(width: 24, height: 24)
                                                }
                                            }
                                        }
                                        .padding(.horizontal)
                                    }
                                    .frame(height: 104)
                                    .cornerRadius(20)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        historyModel.selectedAudio = audio
                                        isShowTranslatedView = true
                                    }
                            }
                        }
                    } else {
                        Text("There's nothing here yet")
                            .MontserratSemiBold(size: 24)
                            .padding(.top, 50)
                    }
                    
                    Color.clear.frame(height: 70)
                }
                .padding(.top)
            }
            
            if showDelete, let selected = selectedAudio {
                DeleteHistory(show: $showDelete, audioToDelete: selected, historyModel: historyModel)
            }
        }
        .onAppear {
            historyModel.loadSavedAudios()
        }
        .fullScreenCover(isPresented: $isShowTranslatedView) {
            TranslatedView(model: $historyModel.selectedAudio)
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
    }
}

struct DeleteHistory: View {
    @Binding var show: Bool
    let audioToDelete: SaveAudio
    @ObservedObject var historyModel: HistoryViewModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .fill(Color(red: 26/255, green: 23/255, blue: 23/255))
                    .frame(width: 280, height: 395)
                    .overlay {
                        VStack(spacing: 25) {
                            Image(.trash2)
                                .resizable()
                                .frame(width: 96, height: 96)
                            
                            Text("Do you want delete this record?")
                                .MontserratRegular(size: 20)
                                .multilineTextAlignment(.center)
                            
                            VStack(spacing: 20) {
                                Button(action: {
                                    historyModel.deleteAudio(audioToDelete)
                                    show = false
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 19/255, green: 83/255, blue: 255/255))
                                        .frame(width: 220, height: 50)
                                        .overlay {
                                            Text("Delete")
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
                    .cornerRadius(20)
            }
        }
    }
}

#Preview {
    HistoryView()
}

