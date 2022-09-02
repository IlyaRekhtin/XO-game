//
//  MainViewController.swift
//  XO-game
//
//  Created by Илья Рехтин on 30.08.2022.
//  Copyright © 2022 plasmon. All rights reserved.
//

import UIKit

public enum GameVariants {
    case pvp
    case pve
    case blinde
}
class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    @IBAction func PVPAction(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        vc.gameVariants = .pvp
        show(vc, sender: nil)
    }
    @IBAction func PVEAction(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        vc.gameVariants = .pve
        show(vc, sender: nil)
    }
    
    @IBAction func BlindeGameAction(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        vc.gameVariants = .blinde
        show(vc, sender: nil)
    }
}
