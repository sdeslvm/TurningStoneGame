import SwiftUI

struct MenuView: View {
    

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                VStack {
                    HStack {
                        Spacer()
//                        ButtonTemplateSmall(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .MENU})
                        BalanceTemplate()
                            .padding(.top, 5)
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        ButtonTemplateSmall(image: "infoBtn", action: {NavGuard.shared.currentScreen = .ACHIVE})
                        Spacer()
                    }
                }
                
                VStack {
                    HStack {
                        ButtonTemplateSmall(image: "settingsBtn", action: {NavGuard.shared.currentScreen = .SETTINGS})
                        Spacer()
                    }
                    Spacer()
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        ButtonTemplateSmall(image: "shopBtn", action: {NavGuard.shared.currentScreen = .SHOP})
                    }
                }
                
                
                VStack {
                    ButtonTemplateBig(image: "modeBtn", action: {NavGuard.shared.currentScreen = .MODE})
                    ButtonTemplateBig(image: "playBtn", action: {NavGuard.shared.currentScreen = .GAMEAI})
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



struct BalanceTemplate: View {
    @AppStorage("coinscore") var coinscore: Int = 10
    
    var body: some View {
        ZStack {
            Image("balanceTemplate")
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 70)
                .overlay(
                    ZStack {
                        Text("\(coinscore)")
                            .foregroundColor(.white)
                            .fontWeight(.heavy)
                            .font(.title3)
                            .position(x: 65, y: 25)
                    }
                )
        }
    }
}



struct ButtonTemplateSmall: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
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

struct ButtonTemplateBig: View {
    var image: String
    var action: () -> Void

    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 120)
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
    MenuView()
}

