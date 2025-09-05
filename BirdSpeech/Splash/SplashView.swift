import SwiftUI

struct SplashView: View {
    @StateObject var splashModel =  SplashViewModel()
    @State var isMain = false
    
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
              }
              
              VStack(spacing: 40) {
                  Text("Tutorial")
                      .MontserratRegular(size: 18)
                  
                  VStack(spacing: 30) {
                      VStack(alignment: .leading, spacing: 30) {
                          HStack(alignment: .top, spacing: 15) {
                              Circle()
                                  .fill(Color(red: 20/255, green: 82/255, blue: 255/255))
                                  .overlay {
                                      Text("1")
                                          .MontserratMeidum(size: 16)
                                  }
                                  .frame(width: 30, height: 30)
                              
                              Text("Select avatar")
                                  .MontserratMeidum(size: 20)
                          }
                          
                          HStack(alignment: .top, spacing: 15) {
                              Circle()
                                  .fill(Color(red: 20/255, green: 82/255, blue: 255/255))
                                  .overlay {
                                      Text("2")
                                          .MontserratMeidum(size: 16)
                                  }
                                  .frame(width: 30, height: 30)
                              
                              Text("Select bird language")
                                  .MontserratMeidum(size: 20)
                          }
                          
                          HStack(alignment: .top, spacing: 15) {
                              Circle()
                                  .fill(Color(red: 20/255, green: 82/255, blue: 255/255))
                                  .overlay {
                                      Text("3")
                                          .MontserratMeidum(size: 16)
                                  }
                                  .frame(width: 30, height: 30)
                              
                              Text("Record bird voice")
                                  .MontserratMeidum(size: 20)
                          }
                          
                          HStack(alignment: .top, spacing: 15) {
                              Circle()
                                  .fill(Color(red: 20/255, green: 82/255, blue: 255/255))
                                  .overlay {
                                      Text("4")
                                          .MontserratMeidum(size: 16)
                                  }
                                  .frame(width: 30, height: 30)
                              
                              Text("Enjoy your translate")
                                  .MontserratMeidum(size: 20)
                          }
                      }
                      
                      Button(action: {
                          withAnimation {
                              isMain = true
                          }
                      }) {
                          Rectangle()
                              .fill(Color(red: 20/255, green: 82/255, blue: 255/255))
                              .frame(width: 86, height: 50)
                              .overlay {
                                  Text("Next")
                                      .MontserratMeidum(size: 16)
                              }
                              .cornerRadius(10)
                      }
                  }
                  
                  Spacer()
              }
              .padding(.vertical)
          }
          .fullScreenCover(isPresented: $isMain) {
              TabBarView()
          }
      }
}

#Preview {
    SplashView()
}

