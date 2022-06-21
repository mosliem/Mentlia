
import UIKit

extension JournalHomeVC: UICollectionViewDelegate , UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if journalHomePresenter != nil{
            return journalHomePresenter.numOfJournals
        }
        else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = journalsCollectionView.dequeueReusableCell(
            withReuseIdentifier: "cell",
            for: indexPath
        ) as! JournalHomeCollectionViewCell
        
        journalHomePresenter.configureCell(cell: cell, indexPath: indexPath)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.cellForItem(at: indexPath)?.showSizingAnimation {
            self.journalHomePresenter.didTapCell(indexPath: indexPath)
            
        }
    }
    
    
    
}


