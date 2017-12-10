import Cocoa

final class HoldingViewController: NSViewController {
    
    private var service: Service!

    private var holding: Holding!

    // MARK: - UI
    
    @IBOutlet private(set) var titleLabel: NSTextField!
    
    @IBOutlet private(set) var imageView: NSImageView!
    
    @IBOutlet private(set) var seperator1: NSView! {
        didSet {
            seperator1.setBackgroundColor(NSColor.quaternaryLabelColor)
        }
    }
    
    @IBOutlet private(set) var seperator2: NSView! {
        didSet {
            seperator2.setBackgroundColor(NSColor.quaternaryLabelColor)
        }
    }
    
    // MARK: - Configure
    
    func configure(service: Service) {
        self.service = service
    }
    
    // MARK: - Present
    
    func present(holding: Holding) {
        presentTitle(holding: holding)
        presentImage(holding: holding)
    }
    
    private func presentTitle(holding: Holding) {
        titleLabel.stringValue = holding.coin.name
    }
    
    private func presentImage(holding: Holding) {
        service.imagesService.getImage(for: holding.coin) { [weak self] result in
            guard let image = result.value else { return }
            self?.imageView.image = image
        }
    }
    
}
