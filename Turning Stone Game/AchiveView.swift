import SwiftUI

struct AchiveView: View {
    // Состояние для текущего индекса изображения
    @State private var currentImageIndex: Int = 0
    
    // Массив с названиями изображений
    let imageNames = ["achive1", "achive2", "achive3", "achive4", "achive5", "achive6", "achive7", "achive8", "achive9", "achive10"]
    
    // Массив состояний разблокировки достижений
    @State private var isUnlocked: [Bool] = Array(repeating: false, count: 10)
    
    // Время последней разблокировки (хранится в UserDefaults)
    private var lastUnlockTimeKey = "lastUnlockTime"
    private var lastUnlockTime: TimeInterval {
        get {
            UserDefaults.standard.double(forKey: lastUnlockTimeKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: lastUnlockTimeKey)
        }
    }
    
    // Таймер для обновления интерфейса
    @State private var timer: Timer?
    
    // Оставшееся время до следующей разблокировки
    @State private var timeRemaining: TimeInterval = 0
    
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
                
                HStack {
                    // Стрелка влево
                    Image("left")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            // Уменьшаем индекс (переход к предыдущему изображению)
                            currentImageIndex = max(0, currentImageIndex - 1)
                        }
                    
                    Spacer()
                    
                    // Стрелка вправо
                    Image("right")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40, height: 40)
                        .onTapGesture {
                            // Увеличиваем индекс (переход к следующему изображению)
                            currentImageIndex = min(imageNames.count - 1, currentImageIndex + 1)
                        }
                }
                .padding(.horizontal, 20)

                // Отображение текущего изображения
                ZStack {
                    Image(imageNames[currentImageIndex])
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 200)
                        .padding(.top, 40)
                        .opacity(isUnlocked[currentImageIndex] ? 1 : 0.3) // Затемнение заблокированных достижений
                    
                    if !isUnlocked[currentImageIndex] {
//                        VStack {
//                            Text("Locked")
//                                .font(.headline)
//                                .foregroundColor(.white)
//                            Text("\(Int(timeRemaining / 3600)) ч осталось")
//                                .font(.caption)
//                                .foregroundColor(.white)
//                        }
//                        .background(Color.black.opacity(0.6))
//                        .cornerRadius(10)
//                        .padding()
                    }
                }

                // Прогресс-бар
                VStack {
                    Spacer()
                    ProgressView(value: 1 - timeRemaining / 86400) // 86400 секунд в сутках
                        .progressViewStyle(LinearProgressViewStyle(tint: .white))
                        .frame(width: geometry.size.width * 0.8)
                        .padding(.bottom, 20)
                }
            }
            .frame(width: geometry.size.width, height: geometry.size.height)
            .background(
                Image("backgroundAchive")
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .scaleEffect(1.1)
            )
            .onAppear {
                startTimer()
                checkUnlockStatus()
            }
            .onDisappear {
                timer?.invalidate()
            }
        }
    }
    
    // Функция проверки состояния разблокировки
    private func checkUnlockStatus() {
        let now = Date().timeIntervalSince1970
        let elapsed = now - lastUnlockTime
        
        if elapsed >= 86400 { // 86400 секунд = 1 день
            unlockNextAchievement()
//            lastUnlockTime = now
        } else {
            timeRemaining = 86400 - elapsed
        }
    }
    
    // Функция разблокировки следующего достижения
    private func unlockNextAchievement() {
        for i in isUnlocked.indices {
            if !isUnlocked[i] {
                isUnlocked[i] = true
                break
            }
        }
    }
    
    // Функция запуска таймера
    private func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            checkUnlockStatus()
        }
    }
}

#Preview {
    AchiveView()
}
