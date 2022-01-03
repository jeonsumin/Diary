//
//  ViewController.swift
//  Diary
//
//  Created by Terry on 2022/01/03.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet var collectionView: UICollectionView!
    
    private var diaryList = [Diary](){
        didSet {
            saveDiaryList()
        }
    }
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        
    }
    
    //MARK: Function
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
            guard let title = $0["title"] as? String else { return nil }
            guard let contents = $0["contents"] as? String else { return nil}
            guard let date = $0["date"] as? Date else {return nil}
            guard let isStar = $0["isStar"] as? Bool else { return nil }
            return Diary(title: title, contents: contents, date: date, isStar: isStar)
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
