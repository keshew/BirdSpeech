import SwiftUI

struct LoadingView: View {
    @State var isFirstLaunch: Bool = UserDefaults.standard.bool(forKey: "isFirstLaunchFlag") == false
    @State var tutorial = false
    @State var main = false
    @State var currentIndex = 0
    
    var body: some View {
        ZStack {
            Image(.bg)
                .resizable()
                .ignoresSafeArea()
            
            
                VStack {
                    Spacer()
                    
                    Image(.loadingMan)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .ignoresSafeArea(edges: .bottom)
                        .offset(y: 40)
                        .opacity(currentIndex == 0 ? 0 : 1)
                }

            VStack(spacing: 0) {
                Image(.logoLoading)
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width > 600 ? 450 : 256, height: UIScreen.main.bounds.width > 600 ? 450 : 256)
                
                if currentIndex == 0 {
                    Spacer()
                    
                    Image(.labelLoading)
                        .resizable()
                        .frame(width: UIScreen.main.bounds.width > 600 ? 250 : 109, height: UIScreen.main.bounds.width > 600 ? 250 : 102)
                } else {
                    Button(action: {
                        if isFirstLaunch {
                            withAnimation {
                                tutorial = true
                            }
                            UserDefaults.standard.set(true, forKey: "isFirstLaunchFlag")
                        } else {
                            withAnimation {
                                main = true
                            }
                        }
                    }) {
                        Rectangle()
                            .fill(Color(red: 20/255, green: 82/255, blue: 255/255))
                            .frame(width: 154, height: 50)
                            .overlay {
                                Text("Start translate")
                                    .MontserratMeidum(size: 16)
                            }
                            .cornerRadius(10)
                    }
                    .padding(.top, 52)
                }
                
                Spacer()
            }
            .padding(.vertical, 30)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    currentIndex += 1
                }
            }
        }
        .fullScreenCover(isPresented: $tutorial) {
            SplashView()
        }
        .fullScreenCover(isPresented: $main) {
            TabBarView()
        }
    }
}

#Preview {
    LoadingView()
}

extension Text {
    func MontserratSemiBold(size: CGFloat,
              color: Color = .white)  -> some View {
        self.font(.custom("Montserrat-SemiBold", size: size))
            .foregroundColor(color)
    }
    
    func MontserratRegular(size: CGFloat,
               color: Color = .white)  -> some View {
        self.font(.custom("Montserrat-Regular", size: size))
            .foregroundColor(color)
    }
    
    func MontserratMeidum(size: CGFloat,
               color: Color = .white)  -> some View {
        self.font(.custom("Montserrat-Medium", size: size))
            .foregroundColor(color)
    }
}
