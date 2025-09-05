import SwiftUI

class MainViewModel: ObservableObject {
    @Published var birds: [Bird] = []
    private let userDefaultsKey = "selectedBirdIndex"
    let defaultBirds = [Bird(imageName: "bird1", name: "Chicken"), Bird(imageName: "bird2", name: "Sparrow", isSelected: true), Bird(imageName: "bird3", name: "Сrow"),
                        Bird(imageName: "bird4", name: "Goose"), Bird(imageName: "bird5", name: "Turkey"), Bird(imageName: "bird6", name: "Pinguin"),
                        Bird(imageName: "bird7", name: "Peacock"), Bird(imageName: "bird8", name: "Eagle"), Bird(imageName: "bird9", name: "Ara"),
                        Bird(imageName: "bird10", name: "Gull")]
    init() {
        let selectedIndex = UserDefaults.standard.integer(forKey: userDefaultsKey)
        
        birds = defaultBirds.enumerated().map { index, bird in
            var bird = bird
            bird.isSelected = (index == selectedIndex)
            return bird
        }
    }
    
    func selectBird(at index: Int) {
        for i in birds.indices {
            birds[i].isSelected = (i == index)
        }
        UserDefaults.standard.set(index, forKey: userDefaultsKey)
        UserDefaults.standard.set(defaultBirds[index].imageName, forKey: "birdImage")
    }
}
