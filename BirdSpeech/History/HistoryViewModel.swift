import SwiftUI
import AVFoundation

class HistoryViewModel: NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var savedAudios: [SaveAudio] = []
    private var audioPlayer: AVAudioPlayer?
    @Published var isPlaying: Bool = false
    @Published var currentlyPlayingID: String? = nil
    @Published var selectedAudio: SaveAudio = SaveAudio(nameAudio: "test2", imageBird: "bird3", audioPath: "", translate: "SaveAudio", duration: "00:03")
    override init() {
        audioPlayer?.prepareToPlay()
    }
    
    private let defaultsKey = "savedAudio"
    
    func playAudio(_ audio: SaveAudio) {
        if currentlyPlayingID == audio.id {
            DispatchQueue.main.async {
                if self.audioPlayer?.isPlaying == true {
                    self.audioPlayer?.pause()
                    self.isPlaying = false
                } else {
                    self.audioPlayer?.play()
                    self.isPlaying = true
                }
            }
            return
        }

        guard !audio.audioPath.isEmpty else {
            print("Путь к аудио пустой")
            return
        }

        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = documentsPath.appendingPathComponent(audio.audioPath)

        guard FileManager.default.fileExists(atPath: fileURL.path) else {
            print("Файла по такому пути нет")
            return
        }

        DispatchQueue.global(qos: .userInitiated).async {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)

                let player = try AVAudioPlayer(contentsOf: fileURL)
                player.delegate = self
                player.prepareToPlay()

                DispatchQueue.main.async {
                    self.audioPlayer = player
                    self.audioPlayer?.play()
                    self.currentlyPlayingID = audio.id
                    self.isPlaying = true
                    print("Воспроизведение аудио началось")
                }
            } catch {
                print("Не удалось воспроизвести аудио: \(error.localizedDescription)")
            }
        }
    }

    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
          if flag {
              DispatchQueue.main.async {
                  self.isPlaying = false
                  print("Воспроизведение аудио завершено")
              }
          }
      }
    
    func loadSavedAudios() {
        guard let data = UserDefaults.standard.data(forKey: defaultsKey) else {
            savedAudios = []
            return
        }
        do {
            let decoded = try JSONDecoder().decode([SaveAudio].self, from: data)
            DispatchQueue.main.async {
                self.savedAudios = decoded
            }
        } catch {
            print("Failed to load savedAudios from UserDefaults: \(error.localizedDescription)")
            savedAudios = []
        }
    }

    func saveAudios() {
        do {
            let data = try JSONEncoder().encode(savedAudios)
            UserDefaults.standard.set(data, forKey: defaultsKey)
        } catch {
            print("Failed to save savedAudios to UserDefaults: \(error.localizedDescription)")
        }
    }

    func deleteAudio(_ audio: SaveAudio) {
        savedAudios.removeAll { $0.id == audio.id }
        
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(savedAudios) {
            UserDefaults.standard.set(encoded, forKey: "savedAudio")
        }
    }

    func addAudio(_ audio: SaveAudio) {
        savedAudios.append(audio)
        saveAudios()
    }
}
