import SpriteKit
import GameplayKit
import SKTiled

public class City {
    /// Unique city name (no spaces)
    var cityName: String?
    
    /// City terrain, a 2d array of tile ids
    var cityTerrain: [[Int]]?
    
    /// City size
    let citySize: CGSize = CGSize(width: 32, height: 32)
    
    /// Initializes city variables (required)
    func initCity(cityName: String) {
        self.cityName = cityName
        makeCityTerrain()
        createTMXFile()
    }
    
    /// Creates file [cityName].tmx from cityTerrain
    private func createTMXFile() {
        // Copy tsx file
        copyFileToDocumentsFolder(nameForFile: "PrototypePack", extForFile: "tsx")
        
        // Create tmx file
        var layer1 = ""
        var layer2 = ""
        let num_columns = Int(citySize.height)
        let num_rows = Int(citySize.width)
        for row in 0..<num_rows {
            for col in 0..<num_columns {
                layer1 = layer1 + "\(cityTerrain![row][col]),"
            }
            layer1 = layer1 + " \n"
        }
        layer1 = String(layer1.dropLast(3)) + "\n"
        for _ in 0..<num_rows {
            for _ in 0..<num_columns {
                layer2 = layer2 + "0,"
            }
            layer2 = layer2 + " \n"
        }
        layer2 = String(layer2.dropLast(3)) + "\n"
        
        var text = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<map version=\"1.4\" tiledversion=\"1.4.3\" orientation=\"isometric\" renderorder=\"right-down\" width=\"" + String(Int(citySize.width)) + "\" height=\""
        text = text + String(Int(citySize.height)) + "\" tilewidth=\"256\" tileheight=\"128\" infinite=\"0\" nextlayerid=\"11\" nextobjectid=\"1\">\n <tileset firstgid=\"1\" source=\"PrototypePack.tsx\"/>\n <layer id=\"8\" name=\"Tile Layer 1\" width=\"" + String(Int(citySize.width)) + "\" height=\""
        text = text + String(Int(citySize.height)) + "\">\n  <data encoding=\"csv\">\n" + layer1 + "</data>\n </layer>\n <layer id=\"9\" name=\"Tile Layer 2\" width=\"" + String(Int(citySize.width)) + "\" height=\"" + String(Int(citySize.height)) + "\">\n  <data encoding=\"csv\">\n" + layer2 + "</data>\n </layer>\n</map>\n"
        
        if let dir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first {
            let fileURL = dir.appendingPathComponent("City.tmx")
            
            do {
                try text.write(to: fileURL, atomically: true, encoding: .utf8)
            }
            catch {
                print("Unable to write " + fileURL.absoluteString)
            }
        }
    }
    
    /// Creates a 2d array of integers representing the tile id using perlin noise
    private func makeCityTerrain() {
        let num_columns = Int(citySize.height)
        let num_rows = Int(citySize.width)
        //let noiseMap = makeNoiseMap(columns: num_columns, rows: num_rows, persistence: 0.9)
        let noisemap = Perlin2D().octaveMatrix(width: 128, height: 128, octaves: 6, persistance: 0.25)
        
        var terrain: [[Int]] = Array(repeating: Array(repeating: 0, count: Int(citySize.height)), count: Int(citySize.width))
        // Downsizes a 128x128 matrix by averaging every 4x4 sub-matrix
        for row in 0..<32 {
            for col in 0..<32 {
                let x_st = 4 * row
                let y_st = 4 * col
                
                var total: CGFloat = 0
                for x in x_st..<(x_st+4) {
                    for y in y_st..<(y_st+4) {
                        //let location = vector2(Int32(row), Int32(col))
                        //let terrainHeight = noiseMap.value(at: location)
                        total = total + noisemap[x][y]
                        
                    }
                }
                let avgTerrainHeight = total / 16
                if avgTerrainHeight <= 0.47 {
                    terrain[row][col] = 0
                } else if avgTerrainHeight <= 0.53 {
                    terrain[row][col] = 3
                } else if avgTerrainHeight <= 1 {
                    terrain[row][col] = 1
                }
            }
            cityTerrain = terrain
        }
    }
    
    /// Creates a perlin noise map
//    private func makeNoiseMap(columns: Int, rows: Int, persistence: Double) -> GKNoiseMap {
//        let source = GKPerlinNoiseSource()
//        source.persistence = persistence
//
//        let noise = GKNoise(source)
//        let size = vector2(1.0, 1.0)
//        let origin = vector2(0.0, 0.0)
//        let sampleCount = vector2(Int32(columns), Int32(rows))
//
//        return GKNoiseMap(noise, size: size, origin: origin, sampleCount: sampleCount, seamless: true)
//    }
    
    private func copyFileToDocumentsFolder(nameForFile: String, extForFile: String) {
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        let destURL = documentsURL!.appendingPathComponent(nameForFile).appendingPathExtension(extForFile)
        guard let sourceURL = Bundle.main.url(forResource: nameForFile, withExtension: extForFile)
        else {
            print("Source File not found.")
            return
        }
        let fileManager = FileManager.default
        do {
            try? fileManager.removeItem(at: destURL)
            try fileManager.copyItem(at: sourceURL, to: destURL)
        } catch {
            print("Unable to copy file")
        }
    }
}
