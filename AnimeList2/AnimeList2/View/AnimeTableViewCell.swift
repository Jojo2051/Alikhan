//
//  AnimeTableViewCell.swift
//  AnimeList2
//
//  Created by Alikhan Aghazade on 11.08.23.
//

import UIKit

class AnimeTableViewCell: UITableViewCell {
    @IBOutlet var animePoster: UIImageView! {
        didSet {
            animePoster.layer.cornerRadius = 20.0
            animePoster.clipsToBounds = true
        }
    }
    var animeURL: String = ""
    @IBOutlet var animeName: UILabel!
    @IBOutlet var animeGenre: UILabel!
    @IBOutlet var animeSeries: UILabel!
    @IBOutlet var animeProducer: UILabel!
    @IBOutlet var animeYear: UILabel!
    @IBOutlet var heartImage: UIImageView!
    @IBOutlet weak var watchedView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
            
    }

}
