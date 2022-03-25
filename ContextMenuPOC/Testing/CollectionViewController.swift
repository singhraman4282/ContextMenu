//
//  CollectionViewController.swift
//  ContextMenuPOC
//
//  Created by Raman Singh on 2022-03-24.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
  @IBOutlet var contextMenuButton: UIButton!
  @IBOutlet var actionSheetButton: UIButton!
}

class CollectionViewController: UICollectionViewController {

  private var models: [CellViewModel] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    models = (1...10).map { index -> CellViewModel in
      
      let inspect = Interaction(title: "Inspect", imageName: "arrow.up.square") {
        print("Will inspect \(index)")
      }
      
      let rate = Interaction(title: "Rate", imageName: "star_image") {
        print("Will Rate \(index)")
      }
      
      let delete = Interaction(title: "Delete", imageName: "trash.fill", type: .destructive) {
        print("will delete \(index)")
      }
      
      let upload = Interaction(title: "Upload", imageName: "paperplane.fill", type: .disabled) {
        print("will upload \(index)")
      }
      
      let handler = DefaultInteractionHandler(
        interactions: [inspect, rate, upload, delete], title: "Options")
      
      return CellViewModel(itemIndex: index, handler: handler)
      
    }
    
    collectionView.reloadData()
  }
    
  override func numberOfSections(in collectionView: UICollectionView) -> Int {
    1
  }
  
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    models.count
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
    let model = models[indexPath.row]
    if #available(iOS 13.0, *) {
      cell.contextMenuButton
        .addInteractionHandlerWithiOS13(model.handler)
    } else {
      cell.contextMenuButton
        .addInteractionHandlerWithSheetAsFallback(
          model.handler, parentViewController: self)
    }
    
    cell.actionSheetButton
      .addInteractionHandlerWithiOS12(model.handler, parentViewController: self)
    
    cell.contextMenuButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    cell.actionSheetButton.titleLabel?.font = UIFont.systemFont(ofSize: 10)
    
    return cell
  }

}
