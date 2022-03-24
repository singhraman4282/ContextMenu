//
//  InteractionHandler.swift
//  ContextMenuPOC
//
//  Created by Raman Singh on 2022-03-23.
//

import Foundation
import UIKit

protocol InteractionHandler {
  @available(iOS 13.0, *)
  func addTouchInteractions(to interactable: ControlInteractable)
  func addTouchInteractions(to interactable: ControlInteractable, in vc: UIViewController)
}


class DefaultInteractionHandler: NSObject, InteractionHandler {
  private let interactions: [Interaction]
  private let title: String
  private weak var containerVC: UIViewController?
  
  init(interactions: [Interaction], title: String = "") {
    self.interactions = interactions
    self.title = title
  }
  
  @available(iOS 13.0, *)
  func addTouchInteractions(to interactable: ControlInteractable) {
    if #available(iOS 14.0, *) {
      interactable.showsMenuAsPrimaryAction = true
      interactable.menu = UIMenu(
        title: NSLocalizedString(title, comment: ""),
        children: interactions.map { $0.toUIAction })
    } else {
      let interaction = UIContextMenuInteraction(delegate: self)
      interactable.addInteraction(interaction)
    }
  }
  
  func addTouchInteractions(to interactable: ControlInteractable, in vc: UIViewController) {
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
      .compactMap { $0.toUIAlertAction }
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
extension DefaultInteractionHandler: UIContextMenuInteractionDelegate {
  
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

extension UIButton {
  
  func addInteractionHandlerWithSheetAsFallback(_ handler: InteractionHandler, parentViewController: UIViewController) {
    if #available(iOS 13.0, *) {
      handler.addTouchInteractions(to: self)
    } else {
      handler.addTouchInteractions(to: self, in: parentViewController)
    }
  }
  
  @available(iOS 13.0, *)
  func addInteractionHandlerWithiOS13(_ handler: InteractionHandler) {
    handler.addTouchInteractions(to: self)
  }
  
  func addInteractionHandlerWithiOS12(_ handler: InteractionHandler, parentViewController: UIViewController) {
    handler.addTouchInteractions(to: self, in: parentViewController)
  }
  
}

extension UIImage {
  
  @available(iOS 13.0, *)
  static func localOrSystemImage(
    named name: String,
    rendered renderingMode: UIImage.RenderingMode = .automatic) -> UIImage? {
      
    let image = UIImage(named: name) ?? UIImage(systemName: name)
    return image?.withRenderingMode(renderingMode)
  }

}
