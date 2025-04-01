import SwiftUI

struct TutorialStepTwo: View {

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Image(.step2)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.25)
                        .onTapGesture {pGesture in
                            NavGuard.shared.currentScreen = .STEPTHREE
                        }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

#Preview {
    TutorialStepTwo()
}
