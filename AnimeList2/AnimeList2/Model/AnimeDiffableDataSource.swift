import UIKit

enum Section {
    case all
}

class AnimeDiffableDataSource: UITableViewDiffableDataSource<Section, Anime> {
    enum Section {
        case all
    }

    class RestaurantDiffableDataSource: UITableViewDiffableDataSource<Section, Anime> {
        override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            return true
        }
    }
}
