import UIKit

class ItemStore {
    var allItems = [Item]()
    let itemArchiveURL: URL = {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!
        print(documentDirectory)
        return documentDirectory.appendingPathComponent("items.json")
    }()
    
    static var hasChanges = false
    
    init() {
//        let notificationCenter = NotificationCenter.default
//        notificationCenter.addObserver(self, selector: #selector(saveChanges), name: UIScene.didEnterBackgroundNotification, object: nil)
        do {
            let data = try Data(contentsOf: itemArchiveURL)
            let decoder = JSONDecoder() //JSON
            allItems = try decoder.decode([Item].self, from: data)
        } catch {
            print("Error reading saved items \(error)")
        }
    }
    
    @discardableResult func createItem() -> Item {
        let newItem = Item(random: true)
        allItems.append(newItem)
        ItemStore.hasChanges = true
        print(#function, ItemStore.hasChanges)
        return newItem
    }
    
    func removeItem(_ item: Item) {
        if let index = allItems.firstIndex(of: item) {
            allItems.remove(at: index)
        }
        ItemStore.hasChanges = true
    }
    
    func getItem(_ indexPath: IndexPath) -> Item {
        return allItems[indexPath.row]
    }
    
    func getRowCountInSection(_ section: Int) -> Int {
        return allItems.count
    }
    
    func move(fromIndex: Int, toIndex: Int) {
        let (start, end, step) = fromIndex < toIndex ?
            (fromIndex, toIndex - 1, 1) :
            (toIndex + 1, fromIndex, -1)
        
        let movedItem = allItems[fromIndex]
        
        for i in start...end {
            allItems[i] = allItems[i + step]
        }
        allItems[toIndex] = movedItem
        ItemStore.hasChanges = true
    }
    
    func saveChanges() {
        if !ItemStore.hasChanges {
            return
        }
        
        do {
            let encoder = JSONEncoder() //JSON
            let data = try encoder.encode(allItems)
            try data.write(to: itemArchiveURL, options: [.atomic])
            ItemStore.hasChanges = false
        } catch let encodingError {
            print("Error encoding allItems: \(encodingError)")
        }
    }
    
    func imageURL(forKey key: String) -> URL {
        let documentsDirectories = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectories.first!

        return documentDirectory.appendingPathComponent(key)
    }
}
