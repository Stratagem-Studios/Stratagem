import SpriteKit
import SKTiled

public class City {
    /// Unique city name (no spaces)
    var cityName: String?
    
    /// City size
    let cityWidth: Int = 15
    let cityHeight: Int = 45
    
    /// City terrain, a 2d array of CityTiles
    var cityTerrain: [[CityTile]]?
    
    /// Tilemap
    var tilemap: SKTilemap?
    
    /// Initializes city variables (required)
    func initCity(cityName: String) {
        self.cityName = cityName
        createTMXFile()
    }
    
    // Creates CityTiles from a tilemap and loads it into cityTerrain
    func loadTilemap(_ tilemap: SKTilemap) {
        self.tilemap = tilemap
        
        cityTerrain = Array(repeating: Array(repeating: CityTile(), count: cityHeight), count: cityWidth)
        let layer = tilemap.getLayers(named: "Tile Layer 1")[0] as? SKTileLayer
        for row in 0..<cityWidth {
            for col in 0..<cityHeight {
                let cityTile = CityTile()
                cityTile.initTile(tile: (layer?.tileAt(row, col))!, isEditable: true)
                cityTerrain![row][col] = cityTile
            }
        }
    }
    
    /// Creates file [cityName].tmx from cityTerrain
    private func createTMXFile() {
        let terrain = makeCityTerrain()
        
        // Copy tsx file
        copyFileToDocumentsFolder(nameForFile: "PrototypePack", extForFile: "tsx")
        
        // Create tmx file
        var layer1 = ""
        var layer2 = ""
        for row in 0..<cityWidth {
            for col in 0..<cityHeight {
                layer1 = layer1 + "\(terrain[row][col]),"
            }
            layer1 = layer1 + " \n"
        }
        layer1 = String(layer1.dropLast(3)) + "\n"
        for _ in 0..<cityWidth {
            for _ in 0..<cityHeight {
                layer2 = layer2 + "0,"
            }
            layer2 = layer2 + " \n"
        }
        layer2 = String(layer2.dropLast(3)) + "\n"
        
        var text = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<map version=\"1.4\" tiledversion=\"1.4.3\" orientation=\"staggered\" renderorder=\"right-down\" width=\"" + String(cityWidth) + "\" height=\""
        text = text + String(cityHeight) + "\" tilewidth=\"256\" tileheight=\"128\" infinite=\"0\" staggeraxis=\"y\" staggerindex=\"odd\" nextlayerid=\"11\" nextobjectid=\"1\">\n <tileset firstgid=\"1\" source=\"PrototypePack.tsx\"/>\n <layer id=\"8\" name=\"Tile Layer 1\" width=\"" + String(cityWidth) + "\" height=\""
        text = text + String(cityHeight) + "\">\n  <data encoding=\"csv\">\n" + layer1 + "</data>\n </layer>\n <layer id=\"9\" name=\"Tile Layer 2\" width=\"" + String(cityWidth) + "\" height=\"" + String(cityHeight) + "\">\n  <data encoding=\"csv\">\n" + layer2 + "</data>\n </layer>\n</map>\n"
        
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
    private func makeCityTerrain() -> [[Int]] {
        let num_columns = cityHeight
        let num_rows = cityWidth
        //let noiseMap = makeNoiseMap(columns: num_columns, rows: num_rows, persistence: 0.9)
        let noisemap = Perlin2D().octaveMatrix(width: num_rows * 4, height: num_columns * 4, octaves: 6, persistance: 0.25)
        
        var terrain: [[Int]] = Array(repeating: Array(repeating: 0, count: cityHeight), count: cityWidth)
        // Downsizes a 128x128 matrix by averaging every 4x4 sub-matrix
        for row in 0..<num_rows {
            for col in 0..<num_columns {
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
                if avgTerrainHeight <= 0.37 {
                    terrain[row][col] = 2
                } else if avgTerrainHeight <= 0.43 {
                    terrain[row][col] = 3
                } else if avgTerrainHeight <= 1 {
                    terrain[row][col] = 1
                }
            }
        }
        return terrain
    }
    
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
