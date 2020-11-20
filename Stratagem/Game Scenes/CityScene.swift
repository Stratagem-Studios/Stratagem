import SpriteKit
import SKTiled


class CityScene: SKTiledScene {
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        super.setup(tmxFile: "Prototype")
        cameraNode.allowGestures = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let tilemap = tilemap else { return }
        let defaultLayer = tilemap.getLayers()[tilemap.getLayers().count - 2] as! SKTileLayer
        print(defaultLayer)

        for touch in touches {

            // get the position in the defaultLayer
            let positionInLayer = defaultLayer.touchLocation(touch)

            let coord = defaultLayer.coordinateAtTouchLocation(touch)

            print(positionInLayer.roundTo())
            print(coord)
            let tile = defaultLayer.tileAt(coord: coord)
            if let tile = tile {
                print(tile)
                tile.highlightDuration = 5
                tile.showBounds = true
            }
        }
    }
}
