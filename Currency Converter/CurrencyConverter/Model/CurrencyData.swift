import Foundation

struct CurrancyData: Decodable {
    let result: Result
}


struct Result: Decodable {
    let rate: Double
}
