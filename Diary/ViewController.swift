//
//  ViewController.swift
//  Diary
//
//  Created by Terry on 2022/01/03.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Properties
    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary](){
        didSet {
            saveDiaryList()
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: Notification.Name("editDiary"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: Notification.Name("starDiary"),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(deleteDiaryNotification(_:)),
                                               name: Notification.Name("deleteDiary"),
                                               object: nil)
    }
    
    //MARK: - Function
    private func configureCollectionView(){
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        //cell크기 설정
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        collectionView.delegate = self
        collectionView.dataSource = self
        loadDiaryList()
    }
    
    //userDefault에 저장하여 앱이 재실행되어도 데이터 유지 할 수 있도록 하는 메소드
    private func saveDiaryList(){
        let date = diaryList.map {
            [
                "uuidString": $0.uuidString,
                "title" : $0.title,
                "contents": $0.contents,
                "date" :$0.date,
                "isStar":$0.isStar
            ]
        }
        let userDefaults = UserDefaults.standard
        userDefaults.set(date, forKey: "diaryList")
    }

    //userDefault에 저장된 값을 불러오는 메소드
    private func loadDiaryList(){
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "diaryList") as? [[String:Any]] else { return }
        diaryList = data.compactMap{
            guard let uuidString = $0["uuidString"] as? String else { return nil}
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil}
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(uuidString: uuidString,
                         title: title,
                         contents: contents,
                         date: date,
                         isStar: isStar)
        }
        //일기를 최신순으로 정렬
        diaryList = diaryList.sorted(by: {
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
    
    // 수정된 일기 데이터를 노티에서 가져오기
    @objc func editDiaryNotification(_ notification: Notification){
        //노티 객체를 Diary로 캐스팅하여 초기화
        guard let diary = notification.object as? Diary else { return }
//기존 일반적인 노티 UserInfo에서 가져오는 코드
//        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
// Index Out Of Rang 에러 처리를 위해 일기의 id 값을 지정하여 Index 설정
        guard let index = diaryList.firstIndex(where: { $0.uuidString == diary.uuidString }) else { return }
        //일기 배열에 index 값을 notification에 있는 값으로 치환
        diaryList[index] = diary
        diaryList = diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        collectionView.reloadData()
    }
    // 즐겨찾기 일기 데이터를 노티에서 가져오기
    @objc func starDiaryNotification(_ notification: Notification){
        guard let startDiary = notification.object as? [String:Any] else { return }
        guard let isStar = startDiary["isStar"] as? Bool else { return }
//        guard let indexPath = startDiary["indexPath"] as? IndexPath else { return }
        guard let uuidString = startDiary["uuidString"] as? String else { return }
        guard let index = diaryList.firstIndex(where: { $0.uuidString == uuidString }) else { return }
        diaryList[index].isStar = isStar
    }
    
    //삭제될 일기 데이터를 노티에서 가져오기
    @objc func deleteDiaryNotification(_ notification: Notification){
//        guard let indexPath = notification.object as? IndexPath else { return }
        guard let uuidString = notification.object as? String else { return }
        guard let index = diaryList.firstIndex(where: {$0.uuidString == uuidString }) else { return }
        diaryList.remove(at: index)
        collectionView.deleteItems(at: [IndexPath(row: index, section: 0)])
        
    }
    //MARK: Override
    // 작성 화면에서 작성된 데이터를 받아오기 위해 delegate 채택
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let wireDiaryViewController = segue.destination as? WriteDiaryViewController {
            wireDiaryViewController.delegate = self
        }
    }
}

//MARK: UICollectionView Data Source
extension ViewController:UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaryList.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DiaryCell", for: indexPath) as? DiaryCell else { return UICollectionViewCell() }
        let diary = diaryList[indexPath.row]
        cell.titleLb.text = diary.title
        cell.dateLb.text = dateToString(date: diary.date)
        
        return cell
    }
}
//MARK: UICollectionView Delegate Flow Laylout
extension ViewController:UICollectionViewDelegateFlowLayout {
    //Cell 크기 설정
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (UIScreen.main.bounds.width / 2) - 20, height: 200)
    }
}

//MARK: Delegate
// 작성화면에서 정의 된 프로토콜 채택
extension ViewController: WriteDiaryViewDelegate {
    // 프로토콜을 채택하여 작성화면에서 데이터를 받아 일기장 조회 화면에 세팅
    func didSelectRegister(diary: Diary) {
        self.diaryList.append(diary)
        
        //데이터를 최신순으로 정렬
        diaryList = diaryList.sorted(by: {
            $0.date.compare($1.date) == .orderedDescending
        })
        collectionView.reloadData()
    }
}

extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "DiaryDetailViewController") as? DiaryDetailViewController else { return }
        let diary = diaryList[indexPath.row]
        viewController.diary = diary
        viewController.indexPath = indexPath
//        viewController.delegate = self
        navigationController?.pushViewController(viewController, animated: true)
    }
}
//extension ViewController: DiaryDetailViewDelegate {
//    func didSelectDelete(indexPath: IndexPath) {
//        diaryList.remove(at: indexPath.row)
//        collectionView.deleteItems(at: [indexPath])
//    }
//    func didSelectStar(indexPath: IndexPath, isStar: Bool) {
//        diaryList[indexPath.row].isStar = isStar
//    }
//}
