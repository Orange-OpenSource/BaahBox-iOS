//
//  DashboardVC.swift
//  OrangeTrainingBox
//
//  Created by Balazs Kovesi on 23/10/2018.
//  Copyright © 2018 Orange. All rights reserved.
//

import UIKit

struct game {
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
    
    var games: [game] = []
    var allGames: [game] = []
    var iconHeight: CGFloat = 0
    
    // =================
    // MARK: - Lifecycle
    // =================
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView()
        
        allGames.append(game(title: L10n.Game.Star.title, icon: Asset.Dashboard.starMenu.image, gameId: StoryboardScene.Games.starGameVC.identifier, color: Asset.Colors.violet.color))
        allGames.append(game(title: L10n.Game.Balloon.title, icon: Asset.Dashboard.balloonMenu.image, gameId: StoryboardScene.Games.balloonGameVC.identifier, color: Asset.Colors.orange.color))
        allGames.append(game(title: L10n.Game.Sheep.title, icon: Asset.Dashboard.sheepMenu.image, gameId: StoryboardScene.Games.sheepGameVC.identifier, color: Asset.Colors.pinky.color))
        allGames.append(game(title: L10n.Game.Space.title, icon: Asset.Dashboard.spaceshipMenu.image, gameId: StoryboardScene.Games.spaceshipGameVC.identifier, color: Asset.Colors.blueGreen.color))
        allGames.append(game(title: L10n.Game.Frog.title, icon: Asset.Dashboard.toadMenu.image, gameId: StoryboardScene.Games.crapaudGameVC.identifier, color: Asset.Colors.greyGreen.color))

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

