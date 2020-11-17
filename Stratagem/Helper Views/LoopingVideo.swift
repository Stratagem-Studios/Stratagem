import SwiftUI
import AVKit
import AVFoundation

struct LoopingVideo: View {
    var body: some View {
        LoopingVideoController()
    }
}

struct LoopingVideo_Previews: PreviewProvider {
    static var previews: some View {
        LoopingVideo()
    }
}

final class LoopingVideoController : UIViewControllerRepresentable {
    var playerLooper: AVPlayerLooper?
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<LoopingVideoController>) ->
    AVPlayerViewController {
        let controller = AVPlayerViewController()
        controller.showsPlaybackControls = false
        
        guard let path = Bundle.main.path(forResource: "starfield", ofType:"mp4") else {
            print("starfield.mp4 not found")
            return controller
        }
        
        let asset = AVAsset(url: URL(fileURLWithPath: path))
        let playerItem = AVPlayerItem(asset: asset)
        let queuePlayer = AVQueuePlayer()
        // OR let queuePlayer = AVQueuePlayer(items: [playerItem]) to pass in items
        
        playerLooper = AVPlayerLooper(player: queuePlayer, templateItem: playerItem)
        queuePlayer.play()
        controller.player = queuePlayer
        
        return controller
    }
    
    func updateUIViewController(_ uiViewController: AVPlayerViewController, context: UIViewControllerRepresentableContext<LoopingVideoController>) {
    }
}
