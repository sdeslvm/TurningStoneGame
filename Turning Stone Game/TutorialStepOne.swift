import SwiftUI

struct TutorialStepOne: View {

    var body: some View {
        GeometryReader { geo in
            ZStack {
                ZStack {
                    Image(.step1)
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(1.25)
                        .onTapGesture {pGesture in
                            NavGuard.shared.currentScreen = .STEPTWO
                        }
                }
                .frame(width: geo.size.width, height: geo.size.height)
            }
        }
    }
}

#Preview {
    TutorialStepOne()
}
