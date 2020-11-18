import SwiftUI
import UIKit
import SwiftVideoBackground

struct LoopingVideo: UIViewControllerRepresentable {
    func makeUIViewController(context: UIViewControllerRepresentableContext<LoopingVideo>) -> MyViewController {
        return MyViewController()
    }

    func updateUIViewController(_ uiViewController: MyViewController, context: UIViewControllerRepresentableContext<LoopingVideo>) {}
}


class MyViewController: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()

    try? VideoBackground.shared.play(view: view, videoName: "starfield", videoType: "mp4")
  }
}
