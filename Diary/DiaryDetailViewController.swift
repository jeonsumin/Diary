//
//  DiaryDetailViewController.swift
//  Diary
//
//  Created by Terry on 2022/01/03.
//

import UIKit

protocol DiaryDetailViewDelegate: AnyObject {
    func didSelectDelete(indexPath:IndexPath)
}

class DiaryDetailViewController: UIViewController {

    @IBOutlet var contentsTextView: UITextView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    var diary: Diary?
    var indexPath: IndexPath?
    var delegate: DiaryDetailViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        
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
        guard let indexPath = indexPath else { return }

        delegate?.didSelectDelete(indexPath: indexPath)
        navigationController?.popViewController(animated: true)
    }
    
    //수정된 다이어리 객체를 가져온다
    @objc func editDiaryNotification(_ notification: Notification){
        guard let diary = notification.object as? Diary else { return }
        guard let row = notification.userInfo?["indexPath.row"] as? Int else { return }
        self.diary = diary
        configureView()
    }
    
    private func configureView(){
        guard let diary = diary else { return }
        titleLabel.text = diary.title
        contentsTextView.text = diary.contents
        dateLabel.text = dateToString(date: diary.date)
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

