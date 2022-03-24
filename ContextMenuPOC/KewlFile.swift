//
//  KewlFile.swift
//  ContextMenuPOC
//
//  Created by Raman Singh on 2022-03-23.
//

import Foundation
import UIKit

struct Interaction {
  let title: String
  let imageName: String
  let action: (() -> Void)?
}


extension Interaction {

  @available(iOS 13.0, *)
  var toUIAction: UIAction {
    .init(
      title: NSLocalizedString(title, comment: ""),
      image: UIImage(named: imageName) ?? UIImage(systemName: imageName)) { _ in
        action?()
      }
  }
  
  var toUIAlertAction: UIAlertAction {
    .init(
      title: NSLocalizedString(title, comment: ""), style: .default) { _ in
      action?()
    }
  }
  
}


protocol ControlInteractable: AnyObject {
  @available(iOS 14.0, *)
  var menu: UIMenu? { get set }
  
  @available(iOS 14.0, *)
  var showsMenuAsPrimaryAction: Bool { get set }
  
  @available(iOS 13.0, *)
  func addInteraction(_ interaction: UIInteraction)
  
  func addTarget(_ target: Any?, action: Selector, for controlEvents: UIControl.Event)
}

extension ControlInteractable {
  func addTarget(_ target: Any?, action: Selector) {
    addTarget(target, action: action, for: .touchUpInside)
  }
}


extension UIButton: ControlInteractable {}


class TDInteractionHandler: NSObject {
  private let interactions: [Interaction]
  private let title: String
  private weak var containerVC: ViewController?
  
  init(interactions: [Interaction], title: String = "") {
    self.interactions = interactions
    self.title = title
  }
  
  func addTouchInteractions(to interactable: ControlInteractable) {
    if #available(iOS 14.0, *) {
      interactable.showsMenuAsPrimaryAction = true
      interactable.menu = UIMenu(
        title: NSLocalizedString(title, comment: ""),
        children: interactions.map { $0.toUIAction })
    } else if #available(iOS 13.0, *) {
      let interaction = UIContextMenuInteraction(delegate: self)
      interactable.addInteraction(interaction)
    }
  }
  
  func addTouchInteractions(to interactable: ControlInteractable, in vc: ViewController) {
    self.containerVC = vc
    interactable.addTarget(self, action: #selector(showActionSheet))
  }
  
  @objc private func showActionSheet() {
    guard let containerVC = containerVC else {
      return
    }

    let alert = UIAlertController(
      title: NSLocalizedString(title, comment: ""),
      message: "", preferredStyle: .actionSheet)
    
    interactions
      .map { $0.toUIAlertAction }
      .forEach {
        alert.addAction($0)
      }
    
    alert.addAction(
      UIAlertAction(
        title: NSLocalizedString("Cancel", comment: ""),
        style: .cancel, handler: nil))
    
    containerVC.present(alert, animated: true, completion: nil)
  }

}

@available(iOS 13.0, *)
extension TDInteractionHandler: UIContextMenuInteractionDelegate {
  
  func contextMenuInteraction(
    _ interaction: UIContextMenuInteraction,
    configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
      
      UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { suggestedActions in
        UIMenu(
          title: NSLocalizedString(self.title, comment: ""),
          children: self.interactions.map { $0.toUIAction })
      }
      
    }

}
