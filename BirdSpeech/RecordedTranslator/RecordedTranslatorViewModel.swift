import SwiftUI

class RecordedTranslatorViewModel: ObservableObject {
    let contact = RecordedTranslatorModel()
    @Published  var isPlaying = false
}
