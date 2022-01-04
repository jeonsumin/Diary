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
    
    }
    
    @IBAction func tapDeleteButton(_ sender: UIButton) {
        guard let indexPath = indexPath else {
            return
        }

        delegate?.didSelectDelete(indexPath: indexPath)
        navigationController?.popViewController(animated: true)
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
    
}

