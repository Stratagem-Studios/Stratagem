import UIKit

extension UIImage {
    func getAlphaMask() -> [[Int]] {
        guard let cgImage = cgImage,
            let provider = cgImage.dataProvider,
            let providerData = provider.data,
            let data = CFDataGetBytePtr(providerData) else {
            return []
        }
        let x_len = Int(size.width) - 1
        let y_len = Int(size.height) - 1
        
        var arr: [[Int]] = Array(repeating: Array(repeating: 0, count: y_len + 1), count: x_len + 1)
        for x in 0...x_len {
            for y in 0...y_len {
                let pixelData = ((Int(size.width) * y) + x) * 4
                    
                arr[x][y_len - y] = Int((CGFloat(data[pixelData + 3]) / 255.0).rounded())
            }
        }

        return arr
    }
}
