import Cocoa
import AppKit

class MenuItemView: NSView {
    
    var onClick: ((NSClickGestureRecognizer) -> ())?
    
    private var gestureRecognizer: NSClickGestureRecognizer!
    
    // MARK: Life
    
    override func awakeFromNib() {
        super.awakeFromNib()
        applyMenuHighlightStyles(rect: .zero)
        
        gestureRecognizer = NSClickGestureRecognizer(target: self, action: #selector(clicked(_:)))
        addGestureRecognizer(gestureRecognizer)
    }
    
    override func draw(_ dirtyRect: NSRect) {
        if let isHighlighted = enclosingMenuItem?.isHighlighted, isHighlighted {
            applyMenuHighlightStyles(rect: dirtyRect)
            super.draw(dirtyRect)
            return
        }

        super.draw(dirtyRect)
    }
    
    override func acceptsFirstMouse(for event: NSEvent?) -> Bool {
        return true
    }
    
    // MARK: - UI
    
    /// stackoverflow.com/questions/26851306/trouble-matching-the-vibrant-background-of-a-yosemite-nsmenuitem-containing-a-cu
    private func applyMenuHighlightStyles(rect: NSRect) {
        if (subviews.lazy.first { $0 is NSImageView && $0.tag == 1234 }) == nil {
            let bgImageView = NSImageView()
            bgImageView.tag = 1234
            bgImageView.frame = bounds
            addSubview(bgImageView)
        }
        
        if NSGraphicsContext.currentContextDrawingToScreen() {
            NSColor.selectedMenuItemColor.setFill()
            NSBezierPath.fill(rect)
        }
    }
    
    // MARK: - Actions
    
    @objc private func clicked(_ sender: NSClickGestureRecognizer) {
        onClick?(sender)
    }
}
