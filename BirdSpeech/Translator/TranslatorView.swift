import SwiftUI
import AVFoundation

struct TranslatorView: View {
    @StateObject var translatorModel =  TranslatorViewModel()
    @State var isSettings = false
    @State var isSwiftch = false
    @State var isRecorded = false
    @State var isFinish = false
    
    @State private var secondsElapsed = 0
    @State private var timer: Timer? = nil
    @State var indicator = false
    @State var isRecordedFinish = false
    @State var isShowAlert = false
    @State private var pulseImages = [PulseImage]()
    @State private var audioRecorder: AVAudioRecorder? = nil
    let timer2 = Timer.publish(every: 2, on: .main, in: .common).autoconnect()
    @State private var audioPath = ""
    @State private var birdImage = UserDefaults.standard.string(forKey: "birdImage") ?? "bird1"
    @State var duration = ""
    @State var seconds = 0
    
    var body: some View {
        ZStack {
            Image(.bgMain)
                .resizable().ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
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
                    
                    VStack {
                        ZStack {
                            VStack(spacing: 20) {
                                Image(
                                    !isSwiftch ? UserDefaults.standard
                                        .string(
                                            forKey: "birdImage"
                                        ) ?? "bird1" : UserDefaults.standard
                                        .string(forKey: "personImage") ?? "king"
                                )
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width > 600 ? 250 : 156, height: UIScreen.main.bounds.width > 600 ? 250 : 156)
                                
                                Image(
                                    isSwiftch ? UserDefaults.standard
                                        .string(
                                            forKey: "birdImage"
                                        ) ?? "bird1" : UserDefaults.standard
                                        .string(forKey: "personImage") ?? "cruzo"
                                )
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width > 600 ? 250 : 156, height: UIScreen.main.bounds.width > 600 ? 250 : 156)
                                
                            }
                            
                            //                            Button(action: {
                            //                                withAnimation {
                            //                                    isSwiftch.toggle()
                            //                                }
                            //                            }) {
                            Image(.change)
                                .resizable()
                                .frame(width: UIScreen.main.bounds.width > 600 ? 110 : 80, height: UIScreen.main.bounds.width > 600 ? 110 : 80)
                            //                            }
                        }
                        
                        
                        Text(formatTime(secondsElapsed))
                            .MontserratSemiBold(
                                size: 40,
                                color: Color(
                                    red: 19/255,
                                    green: 83/255,
                                    blue: 255/255
                                )
                            )
                        
                        VStack(spacing: 30) {
                            ZStack {
                                ForEach(pulseImages) { pulse in
                                    PulsingCircleView()
                                        .frame(width: 160, height: 160)
                                        .transition(.scale)
                                }
                                
                                Button(action: {
                                    guard UserDefaults.standard.bool(forKey: "isAllowMic") else {
                                        isShowAlert = true
                                        return
                                    }
                                    isRecorded.toggle()
                                    if !isRecorded {
                                        stopTimer()
                                        pulseImages.removeAll()
                                    } else {
                                        startTimer()
                                    }
                                }) {
                                    Image(isRecorded ? "pause" : "play")
                                        .resizable()
                                        .frame(width: 160, height: 160)
                                }
                            }
                            .onReceive(timer2) { _ in
                                guard isRecorded else { return }
                                let now = Date()
                                pulseImages.append(PulseImage())
                                withAnimation {
                                    pulseImages.removeAll { now.timeIntervalSince($0.createdAt) > 4}
                                }
                            }
                            
                            if !isRecorded {
                                Text(indicator ? "Loading..." : "Tap to record bird voice")
                                    .MontserratRegular(size: 16)
                            }
                        }
                    }
                    .padding(.top)
                    
                    if UIScreen.main.bounds.width < 410 {
                        Color.clear.frame(height: 110)
                    }
                }
            }
            .scrollDisabled(UIScreen.main.bounds.width < 370)
       
            
            if indicator {
                ProgressView()
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            isRecordedFinish = true
                        }
                    }
            }
        }
        .disabled(indicator)
        .onAppear {
            requestMicrophonePermission()
        }
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text("Permission Required"),
                message: Text("Allow use mic to record speech"),
                dismissButton: .default(Text("OK"))
            )
        }
        .fullScreenCover(isPresented: $isSettings) {
            SettingsView()
        }
        .fullScreenCover(isPresented: $isRecordedFinish) {
            RecordedTranslatorView(audioPath: $audioPath, secondsElapsed: $duration, imageBird: $birdImage, seconds: $seconds)
        }
    }
    
    func startTimer() {
        secondsElapsed = 0
        startRecording()
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            secondsElapsed += 1
            if secondsElapsed >= 10 {
                duration = formatTime(secondsElapsed)
                timer?.invalidate()
                timer = nil
                isRecorded = false
                isFinish = true
                indicator = true
                pulseImages.removeAll()
                audioRecorder?.stop()
                audioRecorder = nil
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRecorded = false
        duration = formatTime(secondsElapsed)
        isFinish = true
        indicator = true
        pulseImages.removeAll()
        audioRecorder?.stop()
        audioRecorder = nil
    }
    
    func formatTime(_ seconds: Int) -> String {
        let min = seconds / 60
        let sec = seconds % 60
        return String(format: "%02d:%02d", min, sec)
    }
    
    func requestMicrophonePermission() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            DispatchQueue.main.async {
                if granted {
                    UserDefaults.standard.set(granted, forKey: "isAllowMic")
                } else {
                    UserDefaults.standard.set(granted, forKey: "isAllowMic")
                }
            }
        }
    }
    
    func startRecording() {
        DispatchQueue.global(qos: .userInitiated).async {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(.playAndRecord, mode: .default)
                try audioSession.setActive(true)
                
                let settings: [String: Any] = [
                    AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                    AVSampleRateKey: 44100,
                    AVNumberOfChannelsKey: 2,
                    AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
                ]
                
                let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let fileName = "\(UUID().uuidString).m4a"
                let audioFilename = documentsPath.appendingPathComponent(fileName)
                
                audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
                audioRecorder?.prepareToRecord()
                audioRecorder?.record()
                
                DispatchQueue.main.async {
                    audioPath = fileName
                }
            } catch {
                print("Failed to start recording: \(error.localizedDescription)")
            }
        }
    }
}

#Preview {
    TranslatorView()
}

struct PulseImage: Identifiable {
    let id = UUID()
    let createdAt = Date()
}

struct PulsingCircleView: View {
    @State private var scale: CGFloat = 1.0
    
    var body: some View {
        Image(.circle)
            .resizable()
            .frame(width: 160, height: 160)
            .scaleEffect(scale)
            .onAppear {
                withAnimation(.easeOut(duration: 3)) {
                    scale = 1.3
                }
            }
    }
}

struct SaveAudio: Codable, Identifiable {
    var id = UUID().uuidString
    var nameAudio: String
    var imageBird: String
    var audioPath: String
    var translate: String
    var duration: String
}
