import Testing
@testable import PersonalMap

@Suite("MapTileConfig")
struct MapTileConfigTests {
    @Test
    func noneHasNoConfig() {
        #expect(MapTileType.none.config == nil)
    }

    @Test
    func standardConfig() {
        let config = MapTileType.standard.config
        #expect(config == .standard)
        #expect(config?.urlTemplate.contains("/std/") == true)
        #expect(config?.minimumZ == 2)
        #expect(config?.maximumZ == 25)
        #expect(config?.maxNativeZ == 18)
    }

    @Test
    func paleConfig() {
        let config = MapTileType.pale.config
        #expect(config == .pale)
        #expect(config?.urlTemplate.contains("/pale/") == true)
        #expect(config?.minimumZ == 5)
        #expect(config?.maximumZ == 25)
        #expect(config?.maxNativeZ == 18)
    }

    @Test
    func urlTemplatesAreXyz() {
        // GSI tiles use the {z}/{x}/{y}.png placeholder pattern.
        for config in [MapTileConfig.standard, .pale] {
            #expect(config.urlTemplate.contains("{z}"))
            #expect(config.urlTemplate.contains("{x}"))
            #expect(config.urlTemplate.contains("{y}"))
        }
    }
}
