import SwiftUI

struct MillGame: View {
    @State private var board: [Int] = Array(repeating: 0, count: 24) // 0 - пусто, 1 - игрок 1, 2 - игрок 2
    @State private var currentPlayer: Int = 1 // Текущий игрок (1 или 2)
    @State private var phase: GamePhase = .placing // Текущая фаза игры
    @State private var selectedNode: Int? = nil
    @State private var winner: Int? = nil
    @State private var piecesToPlace: [Int] = [9, 9]
    @State private var awaitingRemoval: Bool = false
    @State private var previousMills: Set<String> = []
    @AppStorage("currentSelectedCloseCard") private var currentSelectedCloseCard1: String = "background1"
    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard: String = "coin1"

    enum GamePhase {
        case placing, moving, jumping
    }

    var body: some View {
            GeometryReader { geometry in
                ZStack {
                    

                    // Game UI
                    if winner == nil {
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
                                BalanceTemplate()
                                    .padding()
                            }
                            Spacer()
                        }

                        HStack(spacing: -30) {
                            Image(.youPlateYourTurn)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .overlay(
                                    VStack(spacing: 5) {
                                        HStack(spacing: 5) {
                                            ForEach(0..<min(4, piecesToPlace[0]), id: \.self) { _ in
                                                if currentSelectedCloseCard == "coin1" {
                                                    Image("coin1P")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                        .padding(.top, 30)
                                                } else {
                                                    Image("coin2P")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                        .padding(.top, 30)
                                                }
                                                
                                            }
                                        }
                                        if piecesToPlace[0] > 4 {
                                            HStack(spacing: 5) {
                                                ForEach(0..<min(4, piecesToPlace[0] - 4), id: \.self) { _ in
                                                    if currentSelectedCloseCard == "coin1" {
                                                        Image("coin1P")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                    } else {
                                                        Image("coin2P")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                    }
                                                }
                                            }
                                        }
                                        if piecesToPlace[0] > 8 {
                                            HStack(spacing: 5) {
                                                if currentSelectedCloseCard == "coin1" {
                                                    Image("coin1P")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                } else {
                                                    Image("coin2P")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                }
                                                
                                            }
                                        }
                                    }
                                )
                            Spacer()
                            Image(.aiPlateWait)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 180, height: 180)
                                .overlay(
                                    VStack(spacing: 5) {
                                        HStack(spacing: 5) {
                                            ForEach(0..<min(4, piecesToPlace[1]), id: \.self) { _ in
                                                if currentSelectedCloseCard == "coin1" {
                                                    Image("coin1E")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                        .padding(.top, 30)
                                                } else {
                                                    Image("coin2E")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                        .padding(.top, 30)
                                                }
                                            }
                                        }
                                        if piecesToPlace[1] > 4 {
                                            HStack(spacing: 5) {
                                                ForEach(0..<min(4, piecesToPlace[1] - 4), id: \.self) { _ in
                                                    if currentSelectedCloseCard == "coin1" {
                                                        Image("coin1E")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                    } else {
                                                        Image("coin2E")
                                                            .resizable()
                                                            .scaledToFit()
                                                            .frame(width: 20, height: 20)
                                                    }
                                                }
                                            }
                                        }
                                        if piecesToPlace[1] > 8 {
                                            HStack(spacing: 5) {
                                                if currentSelectedCloseCard == "coin1" {
                                                    Image("coin1E")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                } else {
                                                    Image("coin2E")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(width: 20, height: 20)
                                                }
                                            }
                                        }
                                    }
                                )
                        }

                        VStack {
                            Image(.wheel)
                                .resizable()
                                .scaledToFit()
                                .overlay(
                                    MillBoardView(
                                        board: $board,
                                        currentPlayer: currentPlayer,
                                        phase: phase,
                                        selectedNode: selectedNode,
                                        awaitingRemoval: awaitingRemoval,
                                        piecesToPlace: piecesToPlace,
                                        onTap: handleTap
                                    )
                                )
                                .frame(width: 300, height: 400)
                        }
                    } else {
                        // Show WinView or LoseView based on winner
                        if winner == 1 {
                            WinView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        } else {
                            LoseView()
                                .frame(width: geometry.size.width, height: geometry.size.height)
                        }
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(
                    Image(currentSelectedCloseCard1)
                        .resizable()
                        .scaledToFill()
                        .edgesIgnoringSafeArea(.all)
                        .scaleEffect(1.1)
                )
            }
        }

    private func phaseString() -> String {
        switch phase {
        case .placing: return "размещение (\(piecesToPlace[currentPlayer - 1]) фишек)"
        case .moving: return "перемещение"
        case .jumping: return "прыжки"
        }
    }

    private func handleTap(nodeIndex: Int) {
        guard winner == nil else { return }

        if awaitingRemoval {
            let opponent = currentPlayer == 1 ? 2 : 1
            if board[nodeIndex] == opponent && canRemovePiece(at: nodeIndex, opponent: opponent) {
                board[nodeIndex] = 0
                awaitingRemoval = false
                nextTurn()
            }
            return
        }

        switch phase {
        case .placing:
            if board[nodeIndex] == 0 && piecesToPlace[currentPlayer - 1] > 0 {
                board[nodeIndex] = currentPlayer
                piecesToPlace[currentPlayer - 1] -= 1
                if checkForNewMill(player: currentPlayer) {
                    awaitingRemoval = true
                } else {
                    nextTurn()
                }
            }

        case .moving:
            if selectedNode == nil {
                if board[nodeIndex] == currentPlayer {
                    selectedNode = nodeIndex
                }
            } else {
                if board[nodeIndex] == 0 && isAdjacent(node1: selectedNode!, node2: nodeIndex) {
                    board[selectedNode!] = 0
                    board[nodeIndex] = currentPlayer
                    if checkForNewMill(player: currentPlayer) {
                        awaitingRemoval = true
                    } else {
                        selectedNode = nil
                        nextTurn()
                    }
                    selectedNode = nil
                } else {
                    selectedNode = nil
                }
            }

        case .jumping:
            if selectedNode == nil {
                if board[nodeIndex] == currentPlayer {
                    selectedNode = nodeIndex
                }
            } else {
                if board[nodeIndex] == 0 {
                    board[selectedNode!] = 0
                    board[nodeIndex] = currentPlayer
                    if checkForNewMill(player: currentPlayer) {
                        awaitingRemoval = true
                    } else {
                        selectedNode = nil
                        nextTurn()
                    }
                    selectedNode = nil
                } else {
                    selectedNode = nil
                }
            }
        }
    }

    private func nextTurn() {
        currentPlayer = currentPlayer == 1 ? 2 : 1

        let playerPieces = board.filter { $0 == currentPlayer }.count
        if phase == .placing && piecesToPlace[0] == 0 && piecesToPlace[1] == 0 {
            phase = .moving
        }
        if playerPieces == 3 && phase == .moving {
            phase = .jumping
        }

        if isGameOver() {
            winner = currentPlayer == 1 ? 2 : 1
        }
    }

    private func checkForNewMill(player: Int) -> Bool {
        let mills = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23],
            [0, 9, 21], [3, 10, 18], [6, 11, 15], [1, 4, 7], [16, 19, 22], [8, 12, 17], [5, 13, 20], [2, 14, 23]
        ]

        for mill in mills {
            if mill.allSatisfy({ board[$0] == player }) {
                let millKey = mill.map { String($0) }.joined()
                if !previousMills.contains(millKey) {
                    previousMills.insert(millKey)
                    return true
                }
            }
        }
        return false
    }

    private func canRemovePiece(at index: Int, opponent: Int) -> Bool {
        let opponentMills = getMills(for: opponent)
        let isInMill = opponentMills.contains { mill in mill.contains(index) }
        let opponentPiecesNotInMill = board.enumerated().filter { (offset, element) in
            element == opponent && !opponentMills.contains { mill in mill.contains(offset) }
        }.count
        return !isInMill || opponentPiecesNotInMill == 0
    }

    private func getMills(for player: Int) -> [[Int]] {
        let mills = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23],
            [0, 9, 21], [3, 10, 18], [6, 11, 15], [1, 4, 7], [16, 19, 22], [8, 12, 17], [5, 13, 20], [2, 14, 23]
        ]
        return mills.filter { $0.allSatisfy { board[$0] == player } }
    }

    private func isGameOver() -> Bool {
        if phase == .placing { return false }
        let playerPieces = board.filter { $0 == currentPlayer }.count
        return playerPieces < 3 || (phase == .moving && !canMove(player: currentPlayer))
    }

    private func canMove(player: Int) -> Bool {
        let playerNodes = board.enumerated().filter { $1 == player }.map { $0.0 }
        for node in playerNodes {
            for adjacent in adjacentNodes(for: node) {
                if board[adjacent] == 0 {
                    return true
                }
            }
        }
        return false
    }

    private func isAdjacent(node1: Int, node2: Int) -> Bool {
        let adjacencyList = [
            [1, 9], [0, 2, 4], [1, 14], [4, 10], [1, 3, 5, 7], [4, 13], [7, 11], [4, 6, 8], [7, 12],
            [0, 10, 21], [3, 9, 11, 18], [6, 10, 15], [8, 13, 17], [5, 12, 14, 20], [2, 13, 23],
            [11, 16], [15, 17, 19], [12, 16], [10, 19], [16, 18, 20, 22], [13, 19], [9, 22], [19, 21, 23], [14, 22]
        ]
        return adjacencyList[node1].contains(node2)
    }

    private func adjacentNodes(for node: Int) -> [Int] {
        let adjacencyList = [
            [1, 9], [0, 2, 4], [1, 14], [4, 10], [1, 3, 5, 7], [4, 13], [7, 11], [4, 6, 8], [7, 12],
            [0, 10, 21], [3, 9, 11, 18], [6, 10, 15], [8, 13, 17], [5, 12, 14, 20], [2, 13, 23],
            [11, 16], [15, 17, 19], [12, 16], [10, 19], [16, 18, 20, 22], [13, 19], [9, 22], [19, 21, 23], [14, 22]
        ]
        return adjacencyList[node]
    }
}

struct MillBoardView: View {
    @Binding var board: [Int]
    let currentPlayer: Int
    let phase: MillGame.GamePhase
    let selectedNode: Int?
    let awaitingRemoval: Bool
    let piecesToPlace: [Int]
    var onTap: (Int) -> Void
    @AppStorage("currentSelectedCloseCard1") private var currentSelectedCloseCard: String = "coin1"
    

    var body: some View {
        GeometryReader { geometry in
            let radius = min(geometry.size.width, geometry.size.height) / 2 - 20
            let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)

            ZStack {
                ForEach([1.0, 0.75, 0.5], id: \.self) { scale in
                    Circle()
                        .stroke(Color.black, lineWidth: 2)
                        .frame(width: radius * scale * 2, height: radius * scale * 2)
                        .position(center)
                }

                ForEach(0..<8) { i in
                    Path { path in
                        let angle = CGFloat(i) / 8 * 2 * .pi
                        let outerPoint = CGPoint(x: center.x + radius * cos(angle), y: center.y - radius * sin(angle))
                        let middlePoint = CGPoint(x: center.x + radius * 0.75 * cos(angle), y: center.y - radius * 0.75 * sin(angle))
                        let innerPoint = CGPoint(x: center.x + radius * 0.5 * cos(angle), y: center.y - radius * 0.5 * sin(angle))
                        path.move(to: outerPoint)
                        path.addLine(to: middlePoint)
                        path.addLine(to: innerPoint)
                    }
                    .stroke(Color.black, lineWidth: 2)
                }

                ForEach(0..<24, id: \.self) { index in
                    let (x, y) = getNodePosition(index: index, radius: radius, center: center)
                    if isAvailableMove(index: index) {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 20, height: 20)
                            .position(x: x, y: y)
                            .onTapGesture {
                                onTap(index)
                            }
                    } else if board[index] == 1 {
                        if currentSelectedCloseCard == "coin1" {
                            Image("coin1P")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .position(x: x, y: y)
                                .onTapGesture {
                                    onTap(index)
                                }
                        } else {
                            Image("coin2P")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .position(x: x, y: y)
                                .onTapGesture {
                                    onTap(index)
                                }
                        }
                        
                    } else if board[index] == 2 {
                        if currentSelectedCloseCard == "coin1" {
                            Image("coin1E")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .position(x: x, y: y)
                                .onTapGesture {
                                    onTap(index)
                                }
                        } else {
                            Image("coin2E")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .position(x: x, y: y)
                                .onTapGesture {
                                    onTap(index)
                                }
                        }
                    } else {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 20, height: 20)
                            .position(x: x, y: y)
                            .onTapGesture {
                                onTap(index)
                            }
                    }
                }
            }
        }
    }

    private func getNodePosition(index: Int, radius: CGFloat, center: CGPoint) -> (x: CGFloat, y: CGFloat) {
        let circleIndex = index / 8
        let nodeIndex = index % 8
        let angle = CGFloat(nodeIndex) / 8 * 2 * .pi
        let scale: CGFloat = circleIndex == 0 ? 1 : circleIndex == 1 ? 0.75 : 0.5
        let x = center.x + radius * scale * cos(angle)
        let y = center.y - radius * scale * sin(angle)
        return (x, y)
    }

    private func isAvailableMove(index: Int) -> Bool {
        if awaitingRemoval {
            let opponent = currentPlayer == 1 ? 2 : 1
            return board[index] == opponent && canRemovePiece(at: index, opponent: opponent)
        }

        if phase == .placing {
            return false
        }

        switch phase {
        case .moving:
            if let selected = selectedNode {
                return board[index] == 0 && isAdjacent(node1: selected, node2: index)
            }
            return false
        case .jumping:
            if selectedNode != nil {
                return board[index] == 0
            }
            return false
        default:
            return false
        }
    }

    private func isAdjacent(node1: Int, node2: Int) -> Bool {
        let adjacencyList = [
            [1, 9], [0, 2, 4], [1, 14], [4, 10], [1, 3, 5, 7], [4, 13], [7, 11], [4, 6, 8], [7, 12],
            [0, 10, 21], [3, 9, 11, 18], [6, 10, 15], [8, 13, 17], [5, 12, 14, 20], [2, 13, 23],
            [11, 16], [15, 17, 19], [12, 16], [10, 19], [16, 18, 20, 22], [13, 19], [9, 22], [19, 21, 23], [14, 22]
        ]
        return adjacencyList[node1].contains(node2)
    }

    private func canRemovePiece(at index: Int, opponent: Int) -> Bool {
        let opponentMills = getMills(for: opponent)
        let isInMill = opponentMills.contains { mill in mill.contains(index) }
        let opponentPiecesNotInMill = board.enumerated().filter { (offset, element) in
            element == opponent && !opponentMills.contains { mill in mill.contains(offset) }
        }.count
        return !isInMill || opponentPiecesNotInMill == 0
    }

    private func getMills(for player: Int) -> [[Int]] {
        let mills = [
            [0, 1, 2], [3, 4, 5], [6, 7, 8], [9, 10, 11], [12, 13, 14], [15, 16, 17], [18, 19, 20], [21, 22, 23],
            [0, 9, 21], [3, 10, 18], [6, 11, 15], [1, 4, 7], [16, 19, 22], [8, 12, 17], [5, 13, 20], [2, 14, 23]
        ]
        return mills.filter { $0.allSatisfy { board[$0] == player } }
    }
}

struct WinView: View {
    @AppStorage("coinscore") var coinscore: Int = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.winPlate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(1.22)
                    .onTapGesture {
                        coinscore += 100
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
        }
    }
}

struct LoseView: View {
    @AppStorage("coinscore") var coinscore: Int = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.losePlate)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .scaleEffect(1.22)
                    .onTapGesture {
                        coinscore += 100
                        NavGuard.shared.currentScreen = .MENU
                    }
            }
        }
    }
}

#Preview {
    MillGame()
}
