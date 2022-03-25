//
//  Interaction.swift
//  ContextMenuPOC
//
//  Created by Raman Singh on 2022-03-24.
//

import Foundation
import UIKit

struct Interaction {
  
  enum InteractionType {
    case regular
    case destructive
    case disabled
    
    @available(iOS 13.0, *)
    var toUIMenuElementAttributes: UIMenuElement.Attributes {
      switch self {
        case .regular:
          return []
        case .destructive:
          return .destructive
        case .disabled:
          return .disabled
      }
    }
    
    var toUIAlertActionStyle: UIAlertAction.Style? {
      switch self {
        case .destructive:
          return .destructive
        case .regular:
          return UIAlertAction.Style.default
        default:
          return nil
          
      }
    }
  }
  
  let title: String
  let imageName: String
  var type: InteractionType = .regular
  let action: (() -> Void)?
}


extension Interaction {
  
  @available(iOS 13.0, *)
  var toUIAction: UIAction {
    .init(
      title: NSLocalizedString(title, comment: ""),
      image: .localOrSystemImage(named: imageName, rendered: .alwaysTemplate),
      attributes: type.toUIMenuElementAttributes) { _ in
        action?()
      }
  }
  
  var toUIAlertAction: UIAlertAction? {
    if let style = type.toUIAlertActionStyle {
      return UIAlertAction(
        title: NSLocalizedString(title, comment: ""), style: style) { _ in
          action?()
        }
    }
    
    return nil
  }
  
}
