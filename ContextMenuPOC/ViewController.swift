//
//  ViewController.swift
//  ContextMenuPOC
//
//  Created by Raman Singh on 2022-03-23.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var someImageView: UIImageView!
  @IBOutlet var someButton: UIButton!
  @IBOutlet var someLabel: UILabel!
  
  let inspect = Interaction(title: "Inspect", imageName: "arrow.up.square") {
    print("Will inspect")
  }
  
  let rate = Interaction(title: "Rate", imageName: "star_image") {
    print("Will Rate")
  }
  
  @available(iOS 13.0, *)
  lazy private var interactionHandler: TDInteractionHandler = {
    let interactions: [Interaction] = [inspect, rate]
    return TDInteractionHandler(interactions: interactions, title: "Kewl Menu")
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
      // TODO: Play with destructive and shit for UIActionAttributes
    if #available(iOS 13.0, *) {
      someLabel.isUserInteractionEnabled = true
      someImageView.isUserInteractionEnabled = true
      interactionHandler.addInteractions(to: someButton)
      interactionHandler.addInteractions(to: someImageView)
      interactionHandler.addInteractions(to: someLabel)
    }
    
    
    
    
    // Do any additional setup after loading the view.
//    let interaction = UIContextMenuInteraction(delegate: self)
//    someImageView.isUserInteractionEnabled = true
//    someImageView.addInteraction(interaction)
  }


}

