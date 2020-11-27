import SpriteKit
import SKTiled

public class City {
    /// Unique city name (no spaces)
    var cityName: String?
    
    /// City size
    let cityWidth: Int = 12
    let cityHeight: Int = 35
    
    /// City terrain, a 2d array of CityTiles
    var cityTerrain: [[CityTile]]?
    
    /// Tilemap
    var tilemap: SKTilemap?
    
    /// Initializes city variables (required)
    func initCity(cityName: String) {
        self.cityName = cityName
        createTMXFile()
    }
    
    /// Try to replace firstTile with secondTile given its global ID
    func changeTileAtLoc(firstTile: SKTile, secondTileID: Int) {
        if let tileLayer = firstTile.layer {
            if tileLayer.name! == "Tile Layer 1" {
                let x = Int(firstTile.tileCoord!.x)
                let y = Int(firstTile.tileCoord!.y)
                
                // Constraints that ALL tiles have to respect
                if cityTerrain![x][y].isEditable == true {
                    // Destroy a building
                    if firstTile.tileData.properties["isBuilding"]! == "true" {
                        let newTileData = tileLayer.getTileData(globalID: secondTileID)!
                        let newTexture = newTileData.texture!
                        
                        newTexture.filteringMode = .nearest
                        firstTile.texture = newTileData.texture
                        firstTile.tileData = newTileData
                        
                        // Update my cityTerrain array
                        let cityTile = CityTile()
                        cityTile.initTile(tile: firstTile, isEditable: true)
                        cityTerrain![x][y] = cityTile
                    } else {
                        // Build a building, satisfying the building's constraints
                        let newTileData = tileLayer.getTileData(globalID: secondTileID)!
                        let newTexture = newTileData.texture!
                        
                        newTexture.filteringMode = .nearest
                        firstTile.texture = newTileData.texture
                        firstTile.tileData = newTileData
                        
                        // Update my cityTerrain array
                        let cityTile = CityTile()
                        cityTile.initTile(tile: firstTile, isEditable: true)
                        cityTerrain![x][y] = cityTile
                    }
                }
            }
        }
    }
    
    // Creates CityTiles from a tilemap and loads it into cityTerrain
    func loadTilemap(_ tilemap: SKTilemap) {
        self.tilemap = tilemap
        
        cityTerrain = Array(repeating: Array(repeating: CityTile(), count: cityHeight), count: cityWidth)
        let layer = tilemap.getLayers(named: "Tile Layer 1")[0] as? SKTileLayer
        for row in 0..<cityWidth {
            for col in 0..<cityHeight {
                let cityTile = CityTile()
                
                // Add padding tiles around the playable area
                var isEditable = true
                if row < 2 || row > cityWidth - 2 || col < 3 || col > cityHeight - 3 {
                    isEditable = false
                }
                cityTile.initTile(tile: (layer?.tileAt(row, col))!, isEditable: isEditable)
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
        let noisemap = Perlin2D().octaveMatrix(width: num_rows * 10, height: num_columns * 3, octaves: 6, persistance: 0.25)
        
        var terrain: [[Int]] = Array(repeating: Array(repeating: 0, count: cityHeight), count: cityWidth)
        // Downsizes a roughly square larger matrix by taking averages of each submatrix
        for row in 0..<num_rows {
            for col in 0..<num_columns {
                let x_st = 10 * row
                let y_st = 3 * col
                
                var total: CGFloat = 0
                for x in x_st..<(x_st+10) {
                    for y in y_st..<(y_st+3) {
                        total = total + noisemap[x][y]
                    }
                }
                let avgTerrainHeight = total / 30
                if avgTerrainHeight <= 0.37 {
                    terrain[row][col] = 3
                } else if avgTerrainHeight <= 0.43 {
                    terrain[row][col] = 2
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
