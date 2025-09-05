import SwiftUI

class SettingsViewModel: ObservableObject {
    @Published var persons: [Person] = []
    private let userDefaultsKey = "selectedPersonIndex"
    let defaultPerson = [Person(imageName: "cruzo", name: "Cruzo"), Person(imageName: "princess", name: "Princess", isSelected: true), Person(imageName: "king", name: "King"),
                        Person(imageName: "student", name: "Student"), Person(imageName: "marlin", name: "Marlin"), Person(imageName: "avrora", name: "Avrora")]
    
    init() {
        
        
        let selectedIndex = UserDefaults.standard.integer(forKey: userDefaultsKey)
        
        
        persons = defaultPerson.enumerated().map { index, person in
            var person = person
            person.isSelected = (index == selectedIndex)
            return person
        }
    }
    
    func selectPerson(at index: Int) {
        for i in persons.indices {
            persons[i].isSelected = (i == index)
        }
        UserDefaults.standard.set(index, forKey: userDefaultsKey)
        UserDefaults.standard.set(defaultPerson[index].imageName, forKey: "personImage")
    }
}
