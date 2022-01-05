//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Terry on 2022/01/03.
//

import UIKit

//protocol DiaryDetailViewDelegate: AnyObject {
    //    func didSelectDelete(indexPath:IndexPath)
    //    func didSelectStar(indexPath:IndexPath, isStar:Bool)
//}

class DiaryDetailViewController: UIViewController {
    
    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var diary: Diary?
    var indexPath: IndexPath?
//    var delegate: DiaryDetailViewDelegate?
    var starButton: UIBarButtonItem?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(starDiaryNotification(_:)),
                                               name: NSNotification.Name("starDiary"),
                                               object: nil)
    }
    
    @IBAction func tapEditButton(_ sender: UIButton) {
        guard let viewController = storyboard?.instantiateViewController(identifier: "WriteDiaryViewController") as? WriteDiaryViewController else { return }
        guard let indexPath = indexPath else { return }
        guard let diary = diary else { return }
        
        viewController.diaryEditorMode = .edit(indexPath, diary)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(editDiaryNotification(_:)),
                                               name: Notification.Name("editDiary"),
                                               object: nil)
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
//        guard let indexPath = indexPath else { return }
        guard let uuidStirng = diary?.uuidString else { return }
        NotificationCenter.default.post(name: Notification.Name("deleteDiary"),
                                        object: uuidStirng,
                                        userInfo: nil)
        
        //        delegate?.didSelectDelete(indexPath: indexPath)
        navigationController?.popViewController(animated: true)
    }
    
    //수정된 다이어리 객체를 가져온다
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else { return }
//        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        configureView()
    }
    
    @objc func tapStarButton(){
        guard let isStar = diary?.isStar else { return }
//        guard let indexPath = indexPath else { return }
        if isStar {
            starButton?.image = UIImage(systemName: "star")
        }else {
            starButton?.image = UIImage(systemName: "star.fill")
        }
        diary?.isStar = !isStar
        //        프로토콜 델리게이트 방식
        //        delegate?.didSelectStar(indexPath: indexPath, isStar: diary?.isStar ?? false )
        NotificationCenter.default.post(name: Notification.Name("starDiary"),
                                        object: [
                                            "diary":diary,
                                            "isStar": diary?.isStar ?? false,
                                            "uuidString": diary?.uuidString
                                        ],
                                        userInfo: nil)
    }
    @objc func starDiaryNotification(_ notification : Notification){
        guard let starDiary = notification.object as? [String: Any] else { return }
        guard let isStar = starDiary["isStar"] as? Bool else { return }
        guard let uuidString = starDiary["uuidString"] as? String else { return }
        guard let diary = diary else { return }
        if diary.uuidString == uuidString {
            self.diary?.isStar = isStar
            configureView()
        }
    }
    
    private func configureView(){
        guard let diary = diary else { return }
        titleLabel.text = diary.title
        
        contentsTextView.text = diary.contents
        
        dateLabel.text = dateToString(date: diary.date)
        
        starButton = UIBarButtonItem(image: nil, style: .plain, target: self, action: #selector(tapStarButton))
        starButton?.image = diary.isStar ? UIImage(systemName: "star.fill") : UIImage(systemName: "star")
        starButton?.tintColor = .orange
        navigationItem.rightBarButtonItem = starButton
    }
    
    
    //날짜 포멧 설정 메소드
    private func dateToString(date: Date) -> String {
        let formmatter = DateFormatter()
        formmatter.dateFormat = "yy년 MM월 dd일(EEEEE)"
        formmatter.locale = Locale(identifier: "ko_KR")
        return formmatter.string(from: date)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}

