//
//  WriteDiaryViewController.swift
//  Diary
//
//  Created by Terry on 2022/01/03.
//

import UIKit

//작성화면에서 리스트 화면으로 데이터를 전달하기위한 프로토콜 정의
protocol WriteDiaryViewDelegate:AnyObject {
    func didSelectRegister(diary: Diary)
}

class WriteDiaryViewController: UIViewController {

    //MARK: Properties
    @IBOutlet var titleTf: UITextField!
    @IBOutlet var contentsTf: UITextView!
    @IBOutlet var dateTf: UITextField!
    @IBOutlet var confirmBtn: UIBarButtonItem!
    
    private let datePicker = UIDatePicker()
    private var diaryDate: Date?
    
    //정의 된 프로토콜 등록
    weak var delegate: WriteDiaryViewDelegate?
    
    //MARK: Life Cylce
    override func viewDidLoad() {
        super.viewDidLoad()
        configureContentsTextView()
        configureDatePicker()
        configureInputField()
        confirmBtn.isEnabled = false
    }
    
    //MARK: IBAction
    @IBAction func tapConfirmBtn(_ sender: Any) {
        guard let title = titleTf.text else { return }
        guard let contents = contentsTf.text else { return }
        guard let date = diaryDate else { return }
        
        let diary = Diary(title: title, contents: contents, date: date, isStar: false)
        //프로토콜 델리게이트를 통해 데이터 전달
        delegate?.didSelectRegister(diary: diary)
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: Function
    private func configureContentsTextView(){
        let borderColor = UIColor(red: 220/225, green: 220/225, blue: 220/225, alpha: 1.0)
        self.contentsTf.layer.borderColor = borderColor.cgColor
        self.contentsTf.layer.borderWidth = 0.5
        self.contentsTf.layer.cornerRadius = 5.0
    }
    
    private func configureDatePicker(){
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        //데이트 텍스트 필드 tapp 할 시 키보드 대신 데이트픽커가 호출 될수 있도록 타겟 설정
        datePicker.addTarget(self, action: #selector(datePickerValueDidChange(_:)), for: .valueChanged)
        dateTf.inputView = datePicker
    }
    private func configureInputField(){
        contentsTf.delegate = self
        
        titleTf.addTarget(self, action: #selector(titleTextFieldDidChange(_:)), for: .editingChanged)
        
        dateTf.addTarget(self, action: #selector(dateTextFieldDidChange(_:)), for: .editingChanged)
    }
    
    @objc private func datePickerValueDidChange(_ datePicker: UIDatePicker) {
        let formater = DateFormatter()
        formater.dateFormat = "yyyy 년 MM 월 dd 일 (EEEEE)"
        formater.locale = Locale(identifier: "ko_KR")
        diaryDate = datePicker.date
        dateTf.text = formater.string(from: datePicker.date)
        dateTf.sendActions(for: .editingChanged)
    }
    
    @objc private func titleTextFieldDidChange(_ textfield: UITextField){
        validateInputField()
    }
    
    @objc private func dateTextFieldDidChange(_ textfield: UITextField){
        validateInputField()
    }
    
    private func validateInputField(){
        confirmBtn.isEnabled = !(titleTf.text?.isEmpty ?? true)
        && !(dateTf.text?.isEmpty ?? true )
        && !contentsTf.text.isEmpty
    }
    
    //MARK: Overried
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
}

extension WriteDiaryViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        validateInputField()
    }
}
