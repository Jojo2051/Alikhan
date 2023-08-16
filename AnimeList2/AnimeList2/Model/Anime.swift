import Foundation


struct Anime: Hashable {
    var name: String
    var image: String
    var genre: String
    var series: Int
    var year: Int
    var producers: String
    var url: String
    var isFavorite: Bool
    var isWhatched: Bool
    
    init(name: String, image: String, genre: String, series: Int, year: Int, producers: String, url: String, isFavorite: Bool, isWhatched: Bool) {
        self.name = name
        self.image = image
        self.genre = genre
        self.series = series
        self.year = year
        self.producers = producers
        self.url = url
        self.isFavorite = isFavorite
        self.isWhatched = isWhatched
    }
    
    init() {
        self.init(name: "", image: "", genre: "", series: 0, year: 0, producers: "", url: "", isFavorite: false, isWhatched: false)
    }
}
