import MetalKit
import SwiftUI

struct MetalView: NSViewControllerRepresentable {
    let device: MTLDevice
    let view: MTKView
    
    func makeNSViewController(context: Context) -> some NSViewController {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.device = device
        return MetalViewController(view: view)
    }
    
    func updateNSViewController(_ nsViewController: NSViewControllerType, context: Context) {}
}

class MetalViewController: NSViewController {
    var metalView: MTKView
    
    init(view: MTKView) {
        self.metalView = view
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(metalView)
        metalView.frame = view.bounds
        metalView.autoresizingMask = [.width, .height]
    }
}
