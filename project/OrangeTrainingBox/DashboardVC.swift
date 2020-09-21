//
//  DashboardVC.swift
//  Baah Box
//
//  Copyright (C) 2017 – 2020 Orange SA
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PUR POSE. See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program. If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

struct Game {
    let title: String
    let icon: UIImage
    let gameId: String
    let color: UIColor
    
    init(title: String, icon: UIImage, gameId: String, color: UIColor) {
        self.title = title
        self.icon = icon
        self.gameId = gameId
        self.color = color
    }
}

class DashboardVC: SettableVC, UITableViewDelegate, UITableViewDataSource {
    
    // ==================
    // MARK: - Properties
    // ==================
    
    @IBOutlet weak var tableView: UITableView!
    
    var games: [Game] = []
    var allGames: [Game] = []
    var iconHeight: CGFloat = 0
    
    // =================
    // MARK: - Lifecycle
    // =================
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        allGames.append(Game(title: L10n.Game.Star.title, icon: Asset.Dashboard.starMenu.image,
                             gameId: StoryboardScene.Games.starGameVC.identifier, color: Asset.Colors.violet.color))
        allGames.append(Game(title: L10n.Game.Balloon.title, icon: Asset.Dashboard.balloonMenu.image,
                             gameId: StoryboardScene.Games.balloonGameVC.identifier, color: Asset.Colors.orange.color))
        allGames.append(Game(title: L10n.Game.Sheep.title, icon: Asset.Dashboard.sheepMenu.image,
                             gameId: StoryboardScene.Games.sheepGameVC.identifier, color: Asset.Colors.pinky.color))
        allGames.append(Game(title: L10n.Game.Space.title, icon: Asset.Dashboard.spaceshipMenu.image,
                             gameId: StoryboardScene.Games.spaceshipGameVC.identifier, color: Asset.Colors.blueGreen.color))
        allGames.append(Game(title: L10n.Game.Frog.title, icon: Asset.Dashboard.toadMenu.image,
                             gameId: StoryboardScene.Games.crapaudGameVC.identifier, color: Asset.Colors.greyGreen.color))

        title = L10n.Dashboard.title
     
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        navTintColor = Asset.Colors.pinky.color

        games = allGames
        let cellHeight = tableView.bounds.height / CGFloat(games.count)
        iconHeight = cellHeight// - 2 * 10 - 2 * 3
        let transition = CATransition()
        transition.type = .fade
        transition.duration = 0.5
        tableView.layer.add(transition, forKey: "UITableViewReloadDataAnimationKey")
        
        tableView.reloadData()
    }
    
    override func viewSafeAreaInsetsDidChange() {
        appDelegate.safeAreaInsets = view.safeAreaInsets
    }

    override func configureBaahBox() {
        
        if appDelegate.shouldPresentConnectionPannel {
            presentConnectionPopup()
        }
    }

    // ==========================
    // MARK: - TableView delegate
    // ==========================
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let cell: GameCell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameCell
        cell.iconHeight.constant = iconHeight
        cell.setImage(games[index].icon)
        cell.title.text = games[index].title
        cell.colorView.backgroundColor = games[index].color
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let index = indexPath.row
        let storyBoard: UIStoryboard = UIStoryboard(name: "Games", bundle: nil)
        let newViewController: UIViewController = storyBoard.instantiateViewController(withIdentifier: games[index].gameId)
        navigationController?.pushViewController(newViewController, animated: true)
    }
}
