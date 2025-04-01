import SwiftUI

struct ModeView: View {
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    HStack {
                        Image("back")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 40, height: 40)
                            .padding()
                            .foregroundStyle(.white)
                            .onTapGesture {
                                NavGuard.shared.currentScreen = .MENU
                            }
                        Spacer()
                    }
                    Spacer()
                }
                
               
                VStack {
                    HStack {
                        ButtonPlayersTemplate(image: "onlineBtn", action: {NavGuard.shared.currentScreen = .GAMEONLINE})
                        ButtonPlayersTemplate(image: "aiBtn", action: {NavGuard.shared.currentScreen = .GAMEAI})
                               
                            }
                    HStack {
                        ButtonPlayersTemplate(image: "2playerBtn", action: {NavGuard.shared.currentScreen = .GAMEPLAYER})
                        ButtonPlayersTemplate(image: "tutorialBtn", action: {NavGuard.shared.currentScreen = .STEPONE})
                            }
                }
                
                
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )

        }
    }
}



struct ButtonPlayersTemplate: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 230, height: 150)
                .cornerRadius(10)
                .shadow(radius: 10)
        }
        .onTapGesture {
            withAnimation(.easeInOut(duration: 0.2)) {
                action()
            }
        }
    }
}


#Preview {
    ModeView()
}

