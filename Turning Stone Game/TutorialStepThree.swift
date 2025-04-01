import SwiftUI

struct TutorialStepThree: View {

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Image(.step3)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.25)
                        .onTapGesture {pGesture in
                            NavGuard.shared.currentScreen = .MENU
                        }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

#Preview {
    TutorialStepThree()
}
