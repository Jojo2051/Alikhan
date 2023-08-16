import UIKit

class AnimeTableViewController: UITableViewController {
    // MARK: - Anime
    var animeArray: [Anime] = [
        Anime(name: "Клинок рассекающий демонов", image: "DemonSlayer", genre: "приключения, фентези, сенен", series: 25, year: 2019, producers: "Харуо Сотодзаки", url: "https://hdrezka.ag/animation/adventures/30522-istrebitel-demonov-tv-1-2019.html", isFavorite: false, isWhatched: false),
        Anime(name: "Re zero", image: "re zero", genre: "драма, фэнтези", series: 25, year: 2016, producers:  "Масахару Ватанабэ", url: "https://hdrezka.ag/animation/fantasy/15553-re-zhizn-v-alternativnom-mire-s-nulya-tv-1-2016.html", isFavorite: false, isWhatched: false),
        Anime(name: "Реинкарнация безработного", image: "bezrab", genre: "приключения, фэнтези, драма", series: 25, year: 2021, producers: "Манабу Окамото", url: "https://hdrezka.ag/animation/adventures/36797-reinkarnaciya-bezrabotnogo-istoriya-o-priklyucheniyah-v-drugom-mire-tv-1-2021.html", isFavorite: false, isWhatched: false),
        Anime(name: "One Punch Man", image: "opm", genre: "приключения, комедия, фэнтези, фантастика", series: 25, year: 2015, producers: "Синъитиро Усидзима", url: "https://hdrezka.ag/animation/adventures/14562-vanpanchmen-put-stanovleniya-geroya-2015.html", isFavorite: false, isWhatched: false),
        Anime(name: "Тетрадь смерти", image: "dn", genre: "мистика, триллер, детектив", series: 25, year: 2006, producers:  "Мицухиро Ёнэда", url: "https://hdrezka.ag/animation/detective/1765-tetrad-smerti-2006.html", isFavorite: false, isWhatched: false)
    ]
    lazy var dataSource = configureDataSource()
    
    // MARK: - View Controller lide cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, Anime>()
        snapshot.appendSections([.all])
        snapshot.appendItems(animeArray, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    // MARK: -  UITableView Diffable Data Source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
        UIApplication.shared.open(URL(string: cell.animeURL)! as URL, options: [:], completionHandler: nil )

    }
    
    
    // MARK: -  UITableViewDelegate Protocol
    func configureDataSource() -> AnimeDiffableDataSource {
        let cellIdentifier = "animecell"
        
        let dataSource = AnimeDiffableDataSource(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, anime in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnimeTableViewCell
              
                cell.animeURL = anime.url
                cell.animeName.text = anime.name
                cell.animeGenre.text = "Жанр: \(anime.genre)"
                cell.animeProducer.text = "Режжисер: \(anime.producers)"
                cell.animeSeries.text = "Количество серий: \(anime.series)"
                cell.animeYear.text = "Год: \(anime.year)"
                cell.animePoster.image = UIImage(named: anime.image)
                
                if anime.isFavorite {
                    cell.heartImage.isHidden = false
                } else {
                    cell.heartImage.isHidden = true
                }
                
                if anime.isWhatched {
                    cell.watchedView.isHidden = false
                } else {
                    cell.watchedView.isHidden = true
                }
                return cell
           }
        )
        
        return dataSource
    }
    
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Get selected Anime
        guard let anime = self.dataSource.itemIdentifier(for: indexPath)
        else {
            return UISwipeActionsConfiguration()
        }
        
        let markAsFavoriteAction = UIContextualAction(style: .normal, title: "Добавить в избранное") {
            (action, sourView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.heartImage.isHidden = false
        
            self.animeArray[indexPath.row].isFavorite = true
            completionHandler(true)
        }
        
        let deleteFromFavoritesAction = UIContextualAction(style: .normal, title: "Удалить из избранных") {
            (action, sourView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.heartImage.isHidden = true
            self.animeArray[indexPath.row].isFavorite = false
            completionHandler(true)
        }
        
        let markAsWhatched = UIContextualAction(style: .normal, title: "Просмотрено") {
            (action, sourView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.watchedView.isHidden = false
            self.animeArray[indexPath.row].isWhatched = true
            completionHandler(true)
        }
        
        let deleteFromWhatched = UIContextualAction(style: .normal, title: "Не просмотрено") {
            (action, sourView, completionHandler) in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.watchedView.isHidden = true
            self.animeArray[indexPath.row].isWhatched = false
            completionHandler(true)
        }
        
        markAsFavoriteAction.backgroundColor = UIColor.systemYellow
        markAsFavoriteAction.image = UIImage(systemName: "heart.fill")
        deleteFromFavoritesAction.backgroundColor = UIColor.systemPink
        deleteFromFavoritesAction.image = UIImage(systemName: "heart.slash.fill")
        markAsWhatched.backgroundColor = UIColor.systemBlue
        markAsWhatched.image = UIImage(systemName: "checkmark.circle")
        deleteFromWhatched.backgroundColor = UIColor.systemGreen
        deleteFromWhatched.image = UIImage(systemName: "xmark")
        var swipeConfiguration = UISwipeActionsConfiguration()
        
        
        if animeArray[indexPath.row].isFavorite && animeArray[indexPath.row].isWhatched {
            swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteFromFavoritesAction, deleteFromWhatched])
        }
       
        if !animeArray[indexPath.row].isFavorite && !animeArray[indexPath.row].isWhatched {
            swipeConfiguration = UISwipeActionsConfiguration(actions: [markAsFavoriteAction, markAsWhatched])
        }
       
        if animeArray[indexPath.row].isFavorite && !animeArray[indexPath.row].isWhatched {
            swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteFromFavoritesAction, markAsWhatched])
        }
        
        if !animeArray[indexPath.row].isFavorite && animeArray[indexPath.row].isWhatched {
            swipeConfiguration = UISwipeActionsConfiguration(actions: [markAsFavoriteAction, deleteFromWhatched])
        }
        
        
        return swipeConfiguration
        
    }
    
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // Get selected Anime
        guard let anime = self.dataSource.itemIdentifier(for: indexPath)
        else {
           return UISwipeActionsConfiguration()
        }
        
        // Delete Action
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить ") {
            (action, sourView, completionHandler) in
            var snapshot = self.dataSource.snapshot()
            snapshot.deleteItems([anime])
            self.dataSource.apply(snapshot, animatingDifferences: true)
            completionHandler(true)
        }
        
        // ShareAction
        let shareAction = UIContextualAction(style: .normal, title: "Поделиться") {
            (action, sourView, completionHandler) in
            let defaultText = "Салам алейкум. Рекомендую посмотреть данное халяльное аниме: \(anime.name)"
            let activityController: UIActivityViewController
            
            
            if let imageToShare = UIImage(named: anime.image) {
                activityController = UIActivityViewController(activityItems: [defaultText, imageToShare], applicationActivities: nil)
            } else {
                activityController = UIActivityViewController(activityItems: [defaultText], applicationActivities: nil)
            }
            
            
            self.present(activityController, animated: true, completion: nil)
            completionHandler(true)
            
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        deleteAction.backgroundColor = UIColor.systemRed
        shareAction.backgroundColor = UIColor.systemOrange
        shareAction.image = UIImage(systemName: "square.and.arrow.up")
        
        let swipeConfiguration = UISwipeActionsConfiguration(actions: [deleteAction, shareAction])
        return swipeConfiguration
    }
    
    
    
}
