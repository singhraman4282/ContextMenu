  //
  //  InteractionHandler.swift
  //  ContextMenuPOC
  //
  //  Created by Raman Singh on 2022-03-23.
  //

import Foundation
import UIKit

protocol InteractionHandler {
  /// `To be used in production.`
  func showContextMenuOrSheet(for interactable: ControlInteractable, in vc: UIViewController)
  
  /// Demo only. Not to be used in production.
  func showSheetOnTap(for interactable: ControlInteractable, in vc: UIViewController)
  
  /// Demo only. Not to be used in production.
  @available(iOS 13.0, *)
  func showContextMenuOnLongPressOr3DTouch(for interactable: ControlInteractable)
  
  /// Demo only. Not to be used in production.
  @available(iOS 14.0, *)
  func showContextMenuOnTap(for interactable: ControlInteractable)
}

class DefaultInteractionHandler: NSObject, InteractionHandler {
  private let interactions: [Interaction]
  private let title: String
  private weak var containerVC: UIViewController?
  
  init(interactions: [Interaction], title: String = "") {
    self.interactions = interactions
    self.title = title
  }
  
    /// Shows action sheet on tap.
    /// Demo only. Not to be used in production.
  func showSheetOnTap(for interactable: ControlInteractable, in vc: UIViewController) {
    self.containerVC = vc
    interactable.addTarget(self, action: #selector(showActionSheet))
  }
  
    /// Shows context menu on long press or 3D touch.
    /// Demo only. Not to be used in production.
  @available(iOS 13.0, *)
  func showContextMenuOnLongPressOr3DTouch(for interactable: ControlInteractable) {
    let interaction = UIContextMenuInteraction(delegate: self)
    interactable.addInteraction(interaction)
  }
  
    /// Shows context menu on tap.
    /// Demo only. Not to be used in production.
  @available(iOS 14.0, *)
  func showContextMenuOnTap(for interactable: ControlInteractable) {
    interactable.showsMenuAsPrimaryAction = true
    interactable.menu = UIMenu(
      title: NSLocalizedString(title, comment: ""),
      children: interactions.map { $0.toUIAction })
  }
  
    /// Shows sheet on tap for iOS 12 & 13, context menu on long press or 3D touch on iOS 13, and
    /// context menu on tap for iOS 14 and higher. `To be used in production.`
  func showContextMenuOrSheet(for interactable: ControlInteractable, in vc: UIViewController) {
    if #available(iOS 14.0, *) {
      showContextMenuOnTap(for: interactable)
      return
    }
    else if #available(iOS 13.0, *) {
      showContextMenuOnLongPressOr3DTouch(for: interactable)
    }
    
    showSheetOnTap(for: interactable, in: vc)
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

  // MARK: UIButton Extension to be added in production
extension UIButton {
  
    /// Shows context menu no tap
    /// Demo only. Not to be used in production.
  @available(iOS 14.0, *)
  func addInteractionHandlerForiOS14AndHigher(_ handler: InteractionHandler) {
    handler.showContextMenuOnTap(for: self)
  }
  
    /// Shows sheet on tap, context menu on long press or 3D touch.
    /// Demo only. Not to be used in production.
  @available(iOS 13.0, *)
  func addInteractionHandlerForiOS13(_ handler: InteractionHandler, parentViewController: UIViewController) {
    handler.showContextMenuOnLongPressOr3DTouch(for: self)
    handler.showSheetOnTap(for: self, in: parentViewController)
  }
  
    /// Shows sheet on tap.
    /// Demo only. Not to be used in production.
  func addInteractionForiOS12(_ handler: InteractionHandler, parentViewController: UIViewController) {
    handler.showSheetOnTap(for: self, in: parentViewController)
  }
  
    /// Shows sheet on tap for iOS 12 & 13, context menu on long press or 3D touch on iOS 13, and
    /// context menu on tap for iOS 14 and higher. `To be used in production.`
  func oneForAllInteraction(_ handler: InteractionHandler, parentViewController: UIViewController) {
    handler.showContextMenuOrSheet(for: self, in: parentViewController)
  }
  
}

  // MARK: UIImage Extension to be added in production
extension UIImage {
  
  @available(iOS 13.0, *)
  static func localOrSystemImage(
    named name: String,
    rendered renderingMode: UIImage.RenderingMode = .automatic) -> UIImage? {
      
      let image = UIImage(named: name) ?? UIImage(systemName: name)
      return image?.withRenderingMode(renderingMode)
    }
  
}
