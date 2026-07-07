import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    @Published private(set) var items: [Row] = []
    @Published var isPro: Bool = false

    static let freeLimit = 20

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        fileURL = dir.appendingPathComponent("rowmarker_items.json")
        load()
    }

    var canAddMore: Bool { isPro || items.count < Store.freeLimit }

    func add(_ item: Row) {
        items.insert(item, at: 0)
        save()
    }

    func update(_ item: Row) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: Row) {
        items.removeAll { $0.id == item.id }
        save()
    }

    private func load() {
        if let data = try? Data(contentsOf: fileURL),
           let decoded = try? JSONDecoder().decode([Row].self, from: data) {
            items = decoded
        } else {
            items = [
        Row(rowLabel: "Row 1", crop: "Carrots", plantedNote: "Spring", notes: ""),
        Row(rowLabel: "Row 2", crop: "Tomatoes", plantedNote: "Spring", notes: ""),
        Row(rowLabel: "Row 3", crop: "Basil", plantedNote: "Spring", notes: "")
            ]
            save()
        }
    }

    private func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL, options: .atomic)
        }
    }
}
