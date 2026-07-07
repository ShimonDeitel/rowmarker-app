import Foundation

struct Row: Identifiable, Codable, Equatable {
    var id: UUID
    var createdAt: Date
    var rowLabel: String
    var crop: String
    var plantedNote: String
    var notes: String

    init(id: UUID = UUID(), createdAt: Date = Date(), rowLabel: String = "", crop: String = "", plantedNote: String = "", notes: String = "") {
        self.id = id
        self.createdAt = createdAt
        self.rowLabel = rowLabel
        self.crop = crop
        self.plantedNote = plantedNote
        self.notes = notes
    }
}
