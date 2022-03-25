//
//  ControlInteractable.swift
//  ContextMenuPOC
//
//  Created by Raman Singh on 2022-03-24.
//

import Foundation
import UIKit

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
