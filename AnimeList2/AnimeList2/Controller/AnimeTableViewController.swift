import UIKit

class AnimeTableViewController: UITableViewController {
    enum Section {
        case all
    }
    
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
        let optionMenu = UIAlertController(title: nil, message: "Что хотите сделать?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addToFavoritesAction = UIAlertAction(title: "Добавить в избранное", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.heartImage.isHidden = false
            self.animeArray[indexPath.row].isFavorite = true
        })
        
        let removeFromFavorites = UIAlertAction(title: "Удалить из избранных", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.heartImage.isHidden = true
            self.animeArray[indexPath.row].isFavorite = false
        })
        
        let markAsWatched = UIAlertAction(title: "Отметить как просмотренное", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            self.animeArray[indexPath.row].isWhatched = true
            cell.watchedView.isHidden = !self.animeArray[indexPath.row].isWhatched
            
        })
        
        
        let removeFromWatched = UIAlertAction(title: "Удалить из просмотренных", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            self.animeArray[indexPath.row].isWhatched = false
            cell.watchedView.isHidden = !self.animeArray[indexPath.row].isWhatched
            
        })
        
        optionMenu.addAction(cancelAction)
        
        
        if self.animeArray[indexPath.row].isFavorite {
            optionMenu.addAction(removeFromFavorites)
        } else {
            optionMenu.addAction(addToFavoritesAction)
        }
        
        if self.animeArray[indexPath.row].isWhatched {
            optionMenu.addAction(removeFromWatched)
        } else {
            optionMenu.addAction(markAsWatched)
        }
        
        present(optionMenu, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    // MARK: -  UITableViewDelegate Protocol
    func configureDataSource() -> UITableViewDiffableDataSource<Section, Anime> {
        let cellIdentifier = "animecell"
        
        let dataSource = UITableViewDiffableDataSource<Section, Anime>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, anime in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnimeTableViewCell
              
                cell.animeURL = anime.url
                cell.animeName.setTitle(anime.name, for: .normal)
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
    
}
