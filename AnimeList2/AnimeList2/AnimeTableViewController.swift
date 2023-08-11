import UIKit

class AnimeTableViewController: UITableViewController {
    enum Section {
        case all
    }
    
    // Начальные переменные
    let animeNames = ["Клинок рассекающий демонов", "Re zero", "Реинкарнация безработного", "One Punch Man", "Тетрадь смерти"]
    let animeImages = ["DemonSlayer", "re zero", "bezrab", "opm", "dn"]
    let animeGenres = ["приключения, фентези, сенен", "драма, фэнтези", "приключения, фэнтези, драма", "приключения, комедия, фэнтези, фантастика", "мистика, триллер, детектив"]
    
    let animeYear = [2019, 2016, 2021, 2015, 2006]
    let animeSeriers = [25, 25, 25, 25, 26]
    let animveProducers = ["Харуо Сотодзаки", "Масахару Ватанабэ", "Манабу Окамото", "Синъитиро Усидзима", "Мицухиро Ёнэда"]
    let animeURLS = ["https://hdrezka.ag/animation/adventures/30522-istrebitel-demonov-tv-1-2019.html", "https://hdrezka.ag/animation/fantasy/15553-re-zhizn-v-alternativnom-mire-s-nulya-tv-1-2016.html", "https://hdrezka.ag/animation/adventures/36797-reinkarnaciya-bezrabotnogo-istoriya-o-priklyucheniyah-v-drugom-mire-tv-1-2021.html", "https://hdrezka.ag/animation/adventures/14562-vanpanchmen-put-stanovleniya-geroya-2015.html", "https://hdrezka.ag/animation/detective/1765-tetrad-smerti-2006.html"]
    
    lazy var dataSource = configureDataSource()
    var animeIsFavorites = Array(repeating: false, count: 5)
    var animeIsWatched = Array(repeating: false, count: 5)

    
    // Заполнение UITableView
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = dataSource
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, String>()
        snapshot.appendSections([.all])
        snapshot.appendItems(animeNames, toSection: .all)
        
        dataSource.apply(snapshot, animatingDifferences: false)
        
    }
    
    
    // Опции
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let optionMenu = UIAlertController(title: nil, message: "Что хотите сделать?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addToFavoritesAction = UIAlertAction(title: "Добавить в избранное", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.heartImage.isHidden = false
            self.animeIsFavorites[indexPath.row] = true
        })
        
        let removeFromFavorites = UIAlertAction(title: "Удалить из избранных", style: .default, handler: {
            (action:UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.heartImage.isHidden = true
            self.animeIsFavorites[indexPath.row] = false
        })
        
        let markAsWatched = UIAlertAction(title: "Отметить как просмотренное", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.watchedView.isHidden = false
            self.animeIsWatched[indexPath.row] = true
        })
        
        
        let removeFromWatched = UIAlertAction(title: "Удалить из просмотренных", style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            let cell = tableView.cellForRow(at: indexPath) as! AnimeTableViewCell
            cell.watchedView.isHidden = true
            self.animeIsWatched[indexPath.row] = false
        })
        
        optionMenu.addAction(cancelAction)
        
        if self.animeIsFavorites[indexPath.row] {
            optionMenu.addAction(removeFromFavorites)
        } else {
            optionMenu.addAction(addToFavoritesAction)
        }
        
        if self.animeIsWatched[indexPath.row] {
            optionMenu.addAction(removeFromWatched)
        } else {
            optionMenu.addAction(markAsWatched)
        }
        
        present(optionMenu, animated: true, completion: nil)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    
    
    func configureDataSource() -> UITableViewDiffableDataSource<Section, String> {
        let cellIdentifier = "animecell"
        
        let dataSource = UITableViewDiffableDataSource<Section, String>(
            tableView: tableView,
            cellProvider: {  tableView, indexPath, animeName in
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! AnimeTableViewCell
              
                cell.animeURL = self.animeURLS[indexPath.row]
                cell.animeName.setTitle(self.animeNames[indexPath.row], for: .normal)
                cell.animeGenre.text = "Жанр: \(self.animeGenres[indexPath.row])"
                cell.animeProducer.text = "Режжисер: \(self.animveProducers[indexPath.row])"
                cell.animeSeries.text = "Количество серий: \(self.animeSeriers[indexPath.row])"
                cell.animeYear.text = "Год: \(self.animeYear[indexPath.row])"
                cell.animePoster.image = UIImage(named: self.animeImages[indexPath.row])
                
                if self.animeIsFavorites[indexPath.row] {
                    cell.heartImage.isHidden = false
                } else {
                    cell.heartImage.isHidden = false
                }
                
                if self.animeIsWatched[indexPath.row] {
                    cell.watchedView.isHidden = true
                } else {
                    cell.watchedView.isHidden = false
                }
                
                
                return cell
           }
        )
        
        return dataSource
    }
    
    
}
