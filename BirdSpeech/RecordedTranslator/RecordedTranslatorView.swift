import SwiftUI
import AVFoundation

struct RecordedTranslatorView: View {
    @StateObject var recordedTranslatorModel =  RecordedTranslatorViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var showSave = false
    @State var isSettings = false
    @Binding var audioPath: String
    @Binding var secondsElapsed: String
    @Binding var imageBird: String
    @State private var audioPlayer: AVAudioPlayer?
    @State var audioDur = ""
    @State var text = ""
    @StateObject private var audioManager = AudioPlayerManager()
    @Binding var seconds: Int
    @State var isMain = false
    
    var body: some View {
        ZStack {
            Image(.bgMain)
                .resizable().ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        isMain = true
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
                                    Image(imageBird)
                                        .resizable()
                                        .frame(width: 64, height: 64)
                                    
                                    VStack(alignment: .leading) {
                                        Text("Recorded sound")
                                            .MontserratSemiBold(size: 14)
                                        
                                        HStack {
                                            Image(.mic)
                                                .resizable()
                                                .frame(width: 24, height: 24)
                                            
                                            Text(secondsElapsed)
                                                .MontserratSemiBold(size: 14, color: Color(red: 19/255, green: 83/255, blue: 255/255))
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        if audioManager.isPlaying {
                                            audioManager.pauseAudio()
                                        } else {
                                            audioManager.playAudio(from: audioPath)
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
                                        
                                        Text(text)
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
                    
                    VStack(spacing: 30) {
                        Button(action: {
                            withAnimation {
                                showSave = true
                            }
                        }) {
                            Rectangle()
                                .fill(Color(red: 19/255, green: 83/255, blue: 255/255))
                                .frame(width: 179, height: 50)
                                .overlay {
                                    Text("Save translation")
                                        .MontserratMeidum(size: 16)
                                }
                                .cornerRadius(10)
                        }
                        
                        Button(action: {
                            isMain = true
                        }) {
                            Text("Cancel")
                                .MontserratMeidum(size: 16, color: Color(red: 86/255, green: 85/255, blue: 126/255))
                        }
                    }
                }
                .padding(.top)
                
                Spacer()
            }
            
            if showSave {
                SaveRecorded(show: $showSave, textTranse: $text, imageBird: $imageBird, audioPath: $audioPath, duration: $secondsElapsed)
            }
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $isMain) {
            TabBarView()
        }
        .onAppear {
            text = getText()
            audioPlayer?.prepareToPlay()
        }
        
        .onReceive(audioManager.$isPlaying) { isPlaying in
            recordedTranslatorModel.isPlaying = isPlaying
        }
    }
    
    func getText() -> String {
        let translations = recordedTranslatorModel.contact.translations

        guard let randomElement = translations.randomElement() else {
            return "Ошибка: нет элементов"
        }

        let selectedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") ?? "france"
        switch selectedLanguage {
        case "france", "fr", "fr-FR":
            return randomElement.france
        case "italy", "it", "it-IT":
            return randomElement.italy
        case "germany", "de", "de-DE":
            return randomElement.germny
        case "uk", "en", "en-UK", "en-US":
            return randomElement.uk
        case "russia", "ru", "ru-RU":
            return randomElement.russia
        case "portugal", "pt", "pt-PT":
            return randomElement.portugal
        case "spain", "es", "es-ES":
            return randomElement.spain
        default:
            return randomElement.uk
        }
    }
}

#Preview {
    RecordedTranslatorView(audioPath: .constant(""), secondsElapsed: .constant("3"), imageBird: .constant("king"), seconds: .constant(3))
}


struct SaveRecorded: View {
    @Binding var show: Bool
    @Binding var textTranse: String
    @Binding var imageBird: String
    @Binding var audioPath: String
    @Binding var duration: String
    @State var text = ""
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.7).ignoresSafeArea()
            
            VStack {
                Rectangle()
                    .fill(Color(red: 26/255, green: 23/255, blue: 23/255))
                    .frame(width: 280, height: 395)
                    .overlay {
                        VStack(spacing: 25) {
                            Image(.save)
                                .resizable()
                                .frame(width: 96, height: 96)
                            
                            Text("Save")
                                .MontserratRegular(size: 20)
                            
                            Rectangle()
                                .fill(Color(red: 23/255, green: 19/255, blue: 19/255))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color(red: 86/255, green: 85/255, blue: 126/255), lineWidth: 2)
                                        .overlay {
                                            CustomTextFiled(text: $text, placeholder: "Record name")
                                        }
                                }
                                .frame(width: 220, height: 39)
                                .cornerRadius(10)
                            
                            VStack(spacing: 20) {
                                Button(action: {
                                    let saveAudio = SaveAudio(
                                        nameAudio: text.isEmpty ? "Record" : text,
                                         imageBird: imageBird,
                                         audioPath: audioPath,
                                         translate: textTranse,
                                         duration: duration
                                     )
                                     saveAudioData(saveAudio)
                                    show.toggle()
                                }) {
                                    Rectangle()
                                        .fill(Color(red: 19/255, green: 83/255, blue: 255/255))
                                        .frame(width: 220, height: 50)
                                        .overlay {
                                            Text("Save translation")
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

    func saveAudioData(_ saveAudio: SaveAudio) {
        let encoder = JSONEncoder()
        let decoder = JSONDecoder()
        let key = "savedAudio"

        var savedAudios: [SaveAudio] = []

        if let data = UserDefaults.standard.data(forKey: key) {
            do {
                savedAudios = try decoder.decode([SaveAudio].self, from: data)
            } catch {
                print("Ошибка декодирования массива из UserDefaults: \(error.localizedDescription)")
            }
        }

        savedAudios.append(saveAudio)

        do {
            let encodedData = try encoder.encode(savedAudios)
            UserDefaults.standard.set(encodedData, forKey: key)
            print("Данные сохранены в массив в UserDefaults")
        } catch {
            print("Ошибка кодирования массива для UserDefaults: \(error.localizedDescription)")
        }
    }
}

struct CustomTextFiled: View {
    @Binding var text: String
    @FocusState var isTextFocused: Bool
    var placeholder: String
    var body: some View {
        ZStack(alignment: .leading) {
            VStack(spacing: 0) {
                TextField("", text: $text, onEditingChanged: { isEditing in
                    if !isEditing {
                        isTextFocused = false
                    }
                })
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .frame(height: 47)
                .font(.custom("MontserratMeidum-Regular", size: 14))
                .cornerRadius(9)
                .foregroundStyle(.white)
                .focused($isTextFocused)
                
                Rectangle()
                    .fill(Color(red: 97/255, green: 102/255, blue: 105/255))
                    .frame(height: 0.5)
                    .cornerRadius(12)
                    .padding(.horizontal, 30)
            }
          
            
            if text.isEmpty && !isTextFocused {
                Text(placeholder)
                    .MontserratRegular(size: 14, color: Color(red: 97/255, green: 102/255, blue: 105/255))
                    .frame(height: 47)
                    .onTapGesture {
                        isTextFocused = true
                    }
            }
        }
        .padding(.horizontal, 10)
    }
}

import Foundation
import AVFoundation
import Combine

class AudioPlayerManager: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isPlaying = false
    private var audioPlayer: AVAudioPlayer?
    
    var didStartPlaying: (() -> Void)?
    var didFinishPlaying: (() -> Void)?

    func playAudio(from path: String) {
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(path)

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let session = AVAudioSession.sharedInstance()
                try session.setCategory(.playback, mode: .default)
                try session.setActive(true)

                let player = try AVAudioPlayer(contentsOf: fileURL)
                player.delegate = self
                player.prepareToPlay()

                DispatchQueue.main.async {
                    self.audioPlayer = player
                    self.audioPlayer?.play()
                    self.isPlaying = true
                    self.didStartPlaying?()
                }
            } catch {
                print("Не удалось воспроизвести аудио: \(error.localizedDescription)")
            }
        }
    }
    
    func pauseAudio() {
        audioPlayer?.pause()
        isPlaying = false
    }
    
    func stopAudio() {
        audioPlayer?.stop()
        isPlaying = false
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        DispatchQueue.main.async {
            self.isPlaying = false
            self.didFinishPlaying?()
        }
    }
}
