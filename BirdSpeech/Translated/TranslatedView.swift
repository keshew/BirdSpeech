import SwiftUI
import AVFoundation

struct TranslatedView: View {
    @StateObject var translatedModel =  TranslatedViewModel()
    @State var isSettings = false
    @Binding var model: SaveAudio
    @Environment(\.presentationMode) var presentationMode
    @StateObject private var audioManager = AudioPlayerManager()
    
    var body: some View {
        ZStack {
            Image(.bgMain)
                .resizable().ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "arrow.left")
                            .foregroundStyle(.white)
                            .font(.system(size: 24))
                    }
                    
                    Spacer()
                    
                    Text("Translator")
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
                
                VStack(spacing: 50) {
                    VStack(spacing: 15) {
                        Rectangle()
                            .fill(Color(red: 26/255, green: 23/255, blue: 23/255))
                            .overlay {
                                HStack(spacing: 15) {
                                    Image(model.imageBird)
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                    
                                    VStack(alignment: .leading) {
                                        Text(model.nameAudio)
                                            .MontserratSemiBold(size: 14)
                                        
                                        HStack {
                                            Image(.mic)
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                            
                                            Text(model.duration)
                                                .MontserratSemiBold(size: 14, color: Color(red: 19/255, green: 83/255, blue: 255/255))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if audioManager.isPlaying {
                                            audioManager.pauseAudio()
                                        } else {
                                            audioManager.playAudio(from: model.audioPath)
                                        }
                                    }) {
                                        Image(audioManager.isPlaying ? "pause" : "playRecord")
                                            .resizable()
                                            .frame(width: 34, height: 34)
                                    }
                                }
                                .padding(.horizontal)
                            }
                            .frame(height: 104)
                            .cornerRadius(20)
                            .padding(.horizontal)
                        
                        Rectangle()
                            .fill(Color(red: 26/255, green: 23/255, blue: 23/255))
                            .overlay {
                                HStack {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Translate")
                                            .MontserratSemiBold(size: 14, color: Color(red: 19/255, green: 83/255, blue: 255/255))
                                        
                                        Text(model.translate)
                                            .MontserratSemiBold(size: 14)
                                        
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                .padding()
                            }
                            .frame(height: 215)
                            .cornerRadius(20)
                            .padding(.horizontal)
                    }
                }
                .padding(.top)
                
                Spacer()
            }
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
    }
}

#Preview {
    TranslatedView(model: .constant(SaveAudio(nameAudio: "TEST", imageBird: "bird3", audioPath: "qwe", translate: "Lorem ipsum dolor sit amet consectetur. Posuere lectus purus sed posuere pellentesque nunc leo tempor venenatis. Tellus sed at tincidunt suspendisse. Facilisis maecenas sed enim tellus. Rhoncus in suscipit ac integer felis. Interdum integer scelerisque dis lobortis pellentesque vitae volutpat nulla id.", duration: "00:10")))
}

