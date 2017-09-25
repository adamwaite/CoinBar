import Cocoa

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {
    
    private var coinsService: CoinsService!
    private var imagesService: ImagesService!
    private var preferencesService: PreferencesService!

    @IBOutlet private(set) var menuController: MenuController!
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        
        let persistence = Persistence()
        
        let networking = Networking()
        
        coinsService = CoinsService(networking: networking, persistence: persistence)
        
        imagesService = ImagesService(networking: networking)
        
        preferencesService = PreferencesService(persistence: persistence)
        
        let service = Service(coinsService: coinsService, imagesService: imagesService, preferencesService: preferencesService)
        
        menuController.configure(service: service)
    }
}
