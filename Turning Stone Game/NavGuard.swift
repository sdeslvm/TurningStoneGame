import Foundation


enum AvailableScreens {
    case MENU
    case SHOP
    case ACHIVE
    case SETTINGS
    case MODE
    case GAMEAI
    case GAMEPLAYER
    case GAMEONLINE
    case STEPONE
    case STEPTWO
    case STEPTHREE
}

class NavGuard: ObservableObject {
    @Published var currentScreen: AvailableScreens = .MENU
    static var shared: NavGuard = .init()
}
