import Cocoa

final class RefreshMenuItemView: MenuItemView, NibLoadable {
    
    @IBOutlet private(set) var refreshLabel: NSTextField!
    @IBOutlet private(set) var lastRefreshDateLabel: NSTextField!
    
    // MARK: - UI
    
    func configure(lastRefreshed: Date?) {
        refreshLabel.stringValue = "Refresh"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        lastRefreshDateLabel.stringValue = ""
        if let lastRefreshed = lastRefreshed.map(dateFormatter.string) {
            lastRefreshDateLabel.stringValue = "Updated: \(lastRefreshed)"
        }
    }
}
