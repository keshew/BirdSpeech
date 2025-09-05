import SwiftUI

class TranslatedViewModel: ObservableObject {
    let contact = TranslatedModel()
    @Published  var isPlaying = false
}
