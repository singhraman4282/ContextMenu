//
//  ViewController.swift
//  ContextMenuPOC
//
//  Created by Raman Singh on 2022-03-23.
//

import UIKit

class ViewController: UIViewController {
  
  @IBOutlet var someOtherButton: UIButton!
  @IBOutlet var someButton: UIButton!
  
  let inspect = Interaction(title: "Inspect", imageName: "arrow.up.square") {
    print("Will inspect")
  }
  
  let rate = Interaction(title: "Rate", imageName: "star_image") {
    print("Will Rate")
  }
  
  let delete = Interaction(title: "Delete", imageName: "trash.fill", type: .destructive) {
    print("will delete")
  }
  
  let upload = Interaction(title: "Upload", imageName: "paperplane.fill", type: .disabled) {
    print("will upload")
  }
  
  lazy private var interactionHandler: InteractionHandler = {
    let interactions: [Interaction] = [inspect, rate, upload, delete]
    return DefaultInteractionHandler(interactions: interactions, title: "Kewl Menu")
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    if #available(iOS 13.0, *) {
      someButton.addInteractionHandlerWithiOS13(interactionHandler)
    } else {
      someButton.addInteractionHandlerWithSheetAsFallback(interactionHandler, parentViewController: self)
    }
    
    someOtherButton.addInteractionHandlerWithiOS12(interactionHandler, parentViewController: self)
  }

}
