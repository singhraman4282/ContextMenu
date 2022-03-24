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

@available(iOS 13.0, *)
extension Interaction {
  var toUIAction: UIAction {
    .init(
      title: NSLocalizedString(title, comment: ""),
      image: UIImage(named: imageName) ?? UIImage(systemName: imageName)) { _ in
        action?()
      }
  }
}

protocol ViewInteractable {
  func addInteraction(_ interaction: UIInteraction)
}

extension UILabel: ViewInteractable {}
extension UIImageView: ViewInteractable {}
extension UIButton: ViewInteractable {}

@available(iOS 13.0, *)
class TDInteractionHandler: NSObject {
  let interactions: [Interaction]
  let title: String
  
  init(interactions: [Interaction], title: String = "") {
    self.interactions = interactions
    self.title = title
  }
  
//  @available(iOS 13.0, *)
//  func addInteractions(to interactable: UIButton) {
//    interactable.showsMenuAsPrimaryAction = true
//    interactable.menu = UIMenu(
//      title: NSLocalizedString(title, comment: ""),
//      children: interactions.map { $0.toUIAction })
//  }
  
    // TODO: Play with UIMenu.Options e.g. display inline etc.
  @available(iOS 13.0, *)
  func addInteractions(to interactable: ViewInteractable) {
    let interaction = UIContextMenuInteraction(delegate: self)
    interactable.addInteraction(interaction)
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
