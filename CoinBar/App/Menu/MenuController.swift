import Cocoa

final class MenuController: NSObject, NSMenuDelegate {
    
    // MARK: - Properties
    
    private var service: Service!
    
    private var serviceObserver: ServiceObserver!

    fileprivate var holdings: [Holding] = []

    fileprivate var isMenuOpen: Bool = false
    
    // MARK: UI
    
    private let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)

    @IBOutlet private(set) weak var statusMenu: NSMenu!

    private var refreshView: RefreshMenuItemView?

    private var totalView: TotalMenuItemView?
    
    private lazy var preferencesWindowController: NSWindowController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let preferencesWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Preferences")) as! NSWindowController
        let preferencesViewController = preferencesWindowController.window!.contentViewController as! PreferencesViewController
        preferencesViewController.configure(service: self.service)
        return preferencesWindowController
    }()
    
    private lazy var holdingWindowController: NSWindowController = {
        let storyboard = NSStoryboard(name: NSStoryboard.Name("Main"), bundle: nil)
        let holdingWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier("Holding")) as! NSWindowController
        let holdingViewController = holdingWindowController.window!.contentViewController as! HoldingViewController
        holdingViewController.configure(service: self.service)
        return holdingWindowController
    }()
    
    // MARK: - Lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
                
        statusItem.menu = statusMenu
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
        
        serviceObserver = ServiceObserver(coinsUpdated: reloadData, preferencesUpdated: reloadData)
    }
    
    func configure(service: Service) {
        self.service = service
        service.coinsService.refreshCoins()
    }
    
    // MARK: - UI
    
    private func reloadData() {
        holdings = service.coinsService.getHoldings()
        DispatchQueue.main.async {
            self.flashMenuBar()
            self.reloadMenu()
        }
    }
    
    private func flashMenuBar() {
        guard !isMenuOpen else { return }
        statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon-active"))
        DispatchQueue.main.asyncAfter(1) {
            self.statusItem.button?.image = NSImage(named: NSImage.Name("status-bar-icon"))
        }
    }
    
    private func reloadMenu() {
        statusMenu.removeAllItems()
        
        let coinItems = makeCoinItems()
        coinItems.forEach { statusMenu.addItem($0) }
        
        if service.preferencesService.getPreferences().showHoldings {
            totalView = makeTotalView()
            let totalItem = NSMenuItem()
            totalItem.view = totalView
            statusMenu.addItem(totalItem)
        }
        
        let seperator = makeSeperatorItem()
        statusMenu.addItem(seperator)
        
        let refreshItem = makeRefreshItem()
        refreshView = makeRefreshMenuItemView()
        refreshItem.view = refreshView
        statusMenu.addItem(refreshItem)
        
        let secondSeperator = makeSeperatorItem()
        statusMenu.addItem(secondSeperator)
        
        let preferencesItem = makePreferencesItem()
        statusMenu.addItem(preferencesItem)
        
        let quitItem = makeQuitItem()
        statusMenu.addItem(quitItem)
        
    }
    
    private func makeCoinItems() -> [NSMenuItem] {
        let prefs = service.preferencesService.getPreferences()
        let preferredCurrency = prefs.currency
        let preferredChangeInterval = prefs.changeInterval
        let showHoldings = prefs.showHoldings

        return holdings.enumerated().map {
            let item = NSMenuItem(title: $0.element.coin.symbol, action: #selector(viewCoin(_:)), keyEquivalent: "")
            item.tag = $0.offset
            item.target = self
            if let coinMenuItemView = makeCoinMenuItemView(holding: $0.element, currency: preferredCurrency, changeInterval: preferredChangeInterval, showHoldings: showHoldings) {
                item.view = coinMenuItemView
            }
            return item
        }
    }
    
    private func makeCoinMenuItemView(holding: Holding, currency: Preferences.Currency, changeInterval: Preferences.ChangeInterval, showHoldings: Bool) -> CoinMenuItemView? {
        guard let coinMenuItemView = CoinMenuItemView.createFromNib() else {
            return nil
        }
        
        coinMenuItemView.configure(
            with: holding,
            currency: currency,
            changeInterval: changeInterval,
            showHoldings: showHoldings,
            imagesService: service.imagesService)

        coinMenuItemView.onClick = viewCoin
        return coinMenuItemView
    }
    
    private func makeSeperatorItem() -> NSMenuItem {
        return NSMenuItem.separator()
    }
    
    private func makeTotalView() -> TotalMenuItemView? {
        guard let totalView = TotalMenuItemView.createFromNib() else {
            return nil
        }
        
        let prefs = service.preferencesService.getPreferences()
        totalView.configureWithHoldings(prefs.holdings, currency: prefs.currency)
        return totalView
    }
    
    private func makeRefreshItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Refresh", action: #selector(refreshMenuItemViewClicked(_:)), keyEquivalent: "")
        item.target = self
        return item
    }
    
    private func makeRefreshMenuItemView() -> RefreshMenuItemView? {
        guard let refreshMenuItemView = RefreshMenuItemView.createFromNib() else {
            return nil
        }
        
        refreshMenuItemView.configure(lastRefreshed: service.coinsService.lastUpdated)
        refreshMenuItemView.onClick = refreshMenuItemViewClicked
        return refreshMenuItemView
    }
    
    private func makePreferencesItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Preferences", action: #selector(presentPreferences(_:)), keyEquivalent: "")
        item.target = self
        return item
    }
    
    private func makeQuitItem() -> NSMenuItem {
        let item = NSMenuItem(title: "Quit CoinBar", action: #selector(quit(_:)), keyEquivalent: "")
        item.target = self
        return item
    }
    
    // MARK: - Actions
    
    @objc private func viewCoin(_ sender: NSClickGestureRecognizer) {
        guard let index = sender.view?.enclosingMenuItem?.tag else { return }
        let holding = holdings[index]
        if let controller = holdingWindowController.contentViewController as? HoldingViewController {
            holdingWindowController.window?.title = holding.coin.name
            controller.present(holding: holding)
            NSApp.activate(ignoringOtherApps: true)
            holdingWindowController.showWindow(self)
        }
    }
    
    @objc private func refreshMenuItemViewClicked(_ sender: NSClickGestureRecognizer) {
        service.coinsService.refreshCoins()
        refreshView?.refreshLabel.stringValue = "Refreshing..."
        refreshView?.lastRefreshDateLabel.stringValue = ""
    }
    
    @objc private func presentPreferences(_ sender: NSMenuItem) {
        NSApp.activate(ignoringOtherApps: true)
        preferencesWindowController.showWindow(self)
    }
    
    @objc private func quit(_ sender: NSMenuItem) {
        NSApplication.shared.terminate(self)
    }
    
    // MARK: - <NSMenuDelegate>
    
    func menuWillOpen(_ menu: NSMenu) {
        isMenuOpen = true
    }
    
    func menuDidClose(_ menu: NSMenu) {
        isMenuOpen = false
    }
    
}
