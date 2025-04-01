import SwiftUI
import StoreKit

struct SettingsView: View {
    @ObservedObject var settings = CheckingSound()
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
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
                    
                    Image(.settingsPlate)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 550, height: 350)
                    
                    
                    VStack(spacing: -20) {
                        HStack {
                            if settings.musicEnabled {
                                Image(.musicOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 90)
                                    .onTapGesture {
                                        settings.musicEnabled.toggle()
                                    }
                            } else {
                                Image(.musicOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 90)
                                    .onTapGesture {
                                        settings.musicEnabled.toggle()
                                    }
                            }
                            
                            if settings.soundEnabled {
                                Image(.soundOn)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 90)
                                    .onTapGesture {
                                        settings.soundEnabled.toggle()
                                    }
                            } else {
                                Image(.soundOff)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 110, height: 90)
                                    .onTapGesture {
                                        settings.soundEnabled.toggle()
                                    }
                            }
                            
                            
                            
                            
                        }
                        if settings.vibroEnabled {
                            Image(.vibroOn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 90)
                                .onTapGesture {
                                    settings.vibroEnabled.toggle()
                                }
                        } else {
                            Image(.vibroOff)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 90)
                                .onTapGesture {
                                    settings.vibroEnabled.toggle()
                                }
                        }
                        
                        HStack {
                            Image(.rateUsBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 50)
                                .onTapGesture {
                                    requestAppReview()
                                }
                            
                            Image(.shareBtn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 110, height: 50)
                                .onTapGesture {
                                    openURLInSafari(urlString: "turningstonegame.top")
                                }
                        }
                        
                    }
                    .padding(.top, 30)
                    }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image(.backgroundMenu)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.05)
            )
        }
    }
}

extension SettingsView {
    func openURLInSafari(urlString: String) {
        if let url = URL(string: urlString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                print("error url: \(urlString)")
            }
        } else {
            print("error url: \(urlString)")
        }
    }
    
    func requestAppReview() {
        if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            // Попробуем показать диалог с отзывом через StoreKit
            SKStoreReviewController.requestReview(in: scene)
        } else {
            print("error")
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(SoundManager.shared)
}


