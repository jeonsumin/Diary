//
//  StarViewController.swift
//  Diary
//
//  Created by Terry on 2022/01/03.
//

import UIKit

class StarViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary]()
    
    //MARK: - LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        loadStarDiaryList()
        //notificationCenter.default.addObserver로 동록 된 로티를 옵저버를 통해서 구독 
        NotificationCenter.default.addObserver(self, selector: #selector(editDiaryNotification(_:)), name: Notification.Name("editDiary"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(starDiaryNotification(_:)), name: Notification.Name("starDiary"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(deleteDiaryNotification(_:)), name: Notification.Name("deleteDiary"), object: nil)
    }
    
    //MARK: - Function
    private func configureCollectionView(){
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        collectionView.contentInset = UIEdgeInsets(top: 10,
                                                   left: 10,
                                                   bottom: 10,
                                                   right: 10)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func loadStarDiaryList(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String:Any]] else { return }
        diaryList = data.compactMap {
            guard let uuidString = $0["uuidString"] as? String else {return nil }
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil }
            guard let date = $0["date"] as? Date else { return nil }
            guard let isStar = $0["isStar"] as? Bool else {return nil }
            return Diary(uuidString: uuidString,
                         title: title,
                         contents: contents,
                         date: date,
                         isStar: isStar)
        }.filter({
            $0.isStar == true
        }).sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
    }
    
    //날짜 포멧 설정 메소드
    private func dateToString(date: Date) -> String {
        let formmatter = DateFormatter()
        formmatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formmatter.locale = Locale(identifier: "ko_KR")
        return formmatter.string(from: date)
    }
    
    @objc func editDiaryNotification(_ notification : Notification){
        guard let diary = notification.object as? Diary else { return }
//        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        guard let index = diaryList.firstIndex(where: {$0.uuidString == diary.uuidString}) else { return }
        diaryList[index] = diary
        diaryList = diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        collectionView.reloadData()
    }
    
    @objc func deleteDiaryNotification(_ notification : Notification){
//        guard let indexPath = notification.object as? IndexPath else { return }
        guard let uuidString = notification.object as? String else { return }
        guard let index = diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
        diaryList.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
    }
    
    @objc func starDiaryNotification(_ notification : Notification){
        guard let starDiary = notification.object as? [String:Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let diary = starDiary["diary"]as? Diary else { return }
//        guard let indexPath = starDiary["indexPath"] as? IndexPath else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        
        if isStar {
            diaryList.append(diary)
            diaryList = diaryList.sorted(by: {
                $0.date.compare($1.date) == .orderedDescending
            })
            collectionView.reloadData()
        }else {
            guard let index = diaryList.firstIndex(where: {$0.uuidString == uuidString}) else { return }
            diaryList.remove(at: index)
            collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        }
    }
}
extension StarViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "starCell", for: indexPath) as? StarCell else { return UICollectionViewCell() }
        let diary = diaryList[indexPath.row]
        cell.titleLabel.text = diary.title
        cell.dateLabel.text = dateToString(date: diary.date)
        return cell
    }
}

extension StarViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 20, height: 80)
    }
}
extension StarViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = self.diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
        navigationController?.pushViewController(viewController, animated: true)
    }
}
