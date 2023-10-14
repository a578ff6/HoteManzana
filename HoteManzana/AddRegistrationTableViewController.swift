//
//  AddRegistrationTableViewController.swift
//  HoteManzana
//
//  Created by 曹家瑋 on 2023/10/13.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {

    // 名字、姓氏、email
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    // 入住、退房日期
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    // 人數顯示Label
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    // 人數的Stepper
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    // Wifi使用與否
    @IBOutlet weak var wifiSwitch: UISwitch!
    // 選擇的房間類型
    @IBOutlet weak var roomTypeLabel: UILabel!
    
    
    // 儲存入住日期 datePicker 的位置（表格視圖的第 1 個seciton 和 第 1 row）
    let checkInDatePickerCellIndexPath = IndexPath(row: 1, section: 1)
    // 儲存退房日期 datePicker 的位置（表格視圖的第 1 個seciton 和 第 3 row）
    let checkOutDatePickerCellIndexPath = IndexPath(row: 3, section: 1)

    // 儲存入「入住日期」Label 的 cell 位置（表格視圖的第 1 個seciton 和 第 0 row）
    let checkInDateLabelCellIndexPath = IndexPath(row: 0, section: 1)
    // 儲存入「退房日期」Label 的 cell 位置（表格視圖的第 1 個seciton 和 第 2 row）
    let checkOutDateLabelCellIndexPath = IndexPath(row: 2, section: 1)
    
    // 用於追蹤入住日期 datePicker 是否應該被顯示
    // 初始值設為 false，意指一開始 datePicker 是不會被顯示的。
    var isCheckInDatePickerVisible: Bool = false {
        // 當發生改變時觸發
        didSet {
            // 如果 isCheckInDatePickerVisible 是 true，將 checkInDatePicker 的 isHidden 設為 false，使之顯示；
            // 如果是 false，則將 isHidden 設為 true，使之隱藏。
            // 這裡用到的 "!" 用來反轉布林值。
            checkInDatePicker.isHidden = !isCheckInDatePickerVisible
        }
    }
    
    // 用於追蹤退房日期 datePicker 是否應該被顯示
    // 運作方式與上面的 isCheckInDatePickerVisible 相同。
    var isCheckOutDatePickerVisible: Bool = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerVisible
        }
    }
    
    // 存放選擇房間類型
    var roomType: RoomType?
    
    /// 產生和返回這個 Registration 物件
    var registration: Registration? {
        // 先檢查 roomType 是否有值
        guard let roomType = roomType else { return nil }
        
        // 使用 textField 的輸入內容，若無輸入則使用空字串。
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        // 從 datePicker 取得入住和退房日期。
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        // 從 stepper 取得大人和小孩的人數，並將其轉換為整數型別。
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        // 檢查 wifi 開關是否開啟。
        let hasWifi = wifiSwitch.isOn
        
        // 使用上述所有取得的值來建立並返回一個 Registration 物件。
        return Registration(firstName: firstName,
                            lastName: lastName,
                            emailAddress: email,
                            checkInDate: checkInDate,
                            checkOutDate: checkOutDate,
                            numberOfAdults: numberOfAdults,
                            numberOfChildren: numberOfChildren,
                            wifi: hasWifi,
                            roomType: roomType)
    }
    
    // 控制器的視圖被加載時調用，這裡設置了入住日期選擇器的可選範圍和初始值。
    override func viewDidLoad() {
        super.viewDidLoad()

        // midnightToday 存儲了今天的午夜時刻。確保入住日期不會選在過去。
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        
        updateDateViews()
        updateNumberOfGuests()
        updateRoomType()
    }
    
    @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = Int(numberOfAdultsStepper.value)
        let numberOfChildren = Int(numberOfChildrenStepper.value)
        let hasWifi = wifiSwitch.isOn
        let roomChoice = roomType?.name ?? "Not Set"
        
        print("DONE TAPPED")
        print("firstName: \(firstName)")
        print("lastName: \(lastName)")
        print("email: \(email)")
        print("checkIn: \(checkInDate)")
        print("checkOut: \(checkOutDate)")
        print("numberOfAdults: \(numberOfAdults)")
        print("numberOfChildren: \(numberOfChildren)")
        print("wifi: \(hasWifi)")
        print("roomType: \(roomChoice)")
    }
    
    // 關閉視圖控制器
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    /// 更新日期視圖，同時確保退房日期總是在入住日期之後。
    func updateDateViews() {
        // 確保退房日期始終至少是入住日期的次日。
        checkOutDatePicker.minimumDate = Calendar.current.date(byAdding: .day, value: 1, to: checkInDatePicker.date)
        
        // 這裡更新了日期Label，依照選擇的日期和時間格式。
        checkInDateLabel.text = checkInDatePicker.date.formatted(date: .abbreviated, time: .omitted)
        checkOutDateLabel.text = checkOutDatePicker.date.formatted(date: .abbreviated, time: .omitted)
    }
    
    
    // 更新日期
    @IBAction func datePickerValueChanged(_ sender: UIDatePicker) {
        updateDateViews()
    }
    
    
    /// 更新房型的Label
    func updateRoomType() {
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        } else {
            roomTypeLabel.text = "Not Set"
        }
    }
    
    
    // 成人、小孩的 Stepper 調整
    @IBAction func stepperValueChanged(_ sender: UIStepper) {
        // 更新畫面上顯示的成人和兒童的數量。
        updateNumberOfGuests()
    }
    
    /// 更新顯示的成人和兒童數量
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    
    // Switch狀態變化的處理wifi
    @IBAction func wifiSwitchChanged(_ sender: UISwitch) {
        // 後續處理
    }
    
    
    // 決定表格視圖中每一行的高度。
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // 利用 switch 檢查當前行（indexPath）是哪一行
        switch indexPath {
        // 如果當前行是「入住」的 datePicker 且 isCheckInDatePickerVisible 為 false
        // 那麼就返回高度 0（隱藏它）
        case checkInDatePickerCellIndexPath where isCheckInDatePickerVisible == false:
            return 0
        // 「退房」相同。
        case checkOutDatePickerCellIndexPath where isCheckOutDatePickerVisible == false:
            return 0
        // 對於其他的行，使用 UITableView.automaticDimension
        // 這讓行的高度能根據內容自動調整
        default:
            return UITableView.automaticDimension
        }
    }
    
    // 預估儲存格高度
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        // switch 檢查 indexPath
        switch indexPath {
        // 如果當前 indexPath 是 checkInDatePickerCellIndexPath
        case checkInDatePickerCellIndexPath:
            return 190
        // 如果當前 indexPath 是 checkOutDatePickerCellIndexPath
        case checkOutDatePickerCellIndexPath:
            return 190
        // 在其他情況
        default:
            // 讓 UITableView 自動決定最適合的儲存格高度
            return UITableView.automaticDimension
        }
    }
    

    // cell的點擊(顯示datePicker與否)
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 首先取消選中的單元格，即點擊後不再高亮顯示
        tableView.deselectRow(at: indexPath, animated: true)
        
        if indexPath == checkInDateLabelCellIndexPath && isCheckOutDatePickerVisible == false {
            // 如果選中的是「入住」的標籤，並且「退房」的日期選擇器目前是隱藏的，那就變換「入住」日期選擇器的顯示/隱藏狀態
            isCheckInDatePickerVisible.toggle()
        } else if indexPath == checkOutDateLabelCellIndexPath && isCheckInDatePickerVisible == false {
            // 選中的是「退房」的標籤，並且「入住」的日期選擇器目前是隱藏的，那就變換「退房」日期選擇器的顯示/隱藏狀態
            isCheckOutDatePickerVisible.toggle()
        } else if indexPath == checkInDateLabelCellIndexPath || indexPath == checkOutDateLabelCellIndexPath {
            // 選中的是「入住」或「退房」的標籤，不論目前的狀態為何， 兩個日期選擇器的顯示/隱藏狀態都要進行變換。
            isCheckInDatePickerVisible.toggle()
            isCheckOutDatePickerVisible.toggle()
        } else {
            return
        }
        
        // 更新表格視圖：通知系統我們要進行一些變更，從而重新計算各個單元格的高度並刷新視圖
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    // 點擊RommType時觸發
    @IBSegueAction func selectRoomType(_ coder: NSCoder) -> SelectRoomTypeTableViewController? {
        
        // 此實例將成為新轉場目的地的視圖控制器。
        let selectRoomTypeController = SelectRoomTypeTableViewController(coder: coder)
        // 將當前的視圖控制器(self)設置為selectRoomTypeController的代理(delegate)。
        // 這樣，selectRoomTypeController就能在適當的時候通知(委託)當前視圖控制器。
        selectRoomTypeController?.delegate = self
        // 把當前選擇的roomType屬性值傳遞給selectRoomTypeController。
        // 這樣selectRoomTypeController就可以知道用戶先前所做的選擇。
        selectRoomTypeController?.roomType = roomType
        
        return selectRoomTypeController
    }
    
    
}


// 擴展協定SelectRoomTypeTableViewControllerDelegate。
extension AddRegistrationTableViewController: SelectRoomTypeTableViewControllerDelegate {
    // 當 SelectRoomTypeTableViewController 中的用戶選擇了一個房間類型，這個方法會被調用，並且選擇的房間類型會作為roomType參數傳遞過來。
    func selectRoomTypeTableViewController(_ controller: SelectRoomTypeTableViewController, didSelect roomType: RoomType) {
        // 用戶選擇的房間類型
        self.roomType = roomType
        updateRoomType()
    }
}


// MARK: - 測試用
/*
 @IBAction func doneBarButtonTapped(_ sender: UIBarButtonItem) {
     let firstName = firstNameTextField.text ?? ""
     let lastName = lastNameTextField.text ?? ""
     let email = emailTextField.text ?? ""
     let checkInDate = checkInDatePicker.date
     let checkOutDate = checkOutDatePicker.date
     let numberOfAdults = Int(numberOfAdultsStepper.value)
     let numberOfChildren = Int(numberOfChildrenStepper.value)
     let hasWifi = wifiSwitch.isOn
     let roomChoice = roomType?.name ?? "Not Set"
     
     print("DONE TAPPED")
     print("firstName: \(firstName)")
     print("lastName: \(lastName)")
     print("email: \(email)")
     print("checkIn: \(checkInDate)")
     print("checkOut: \(checkOutDate)")
     print("numberOfAdults: \(numberOfAdults)")
     print("numberOfChildren: \(numberOfChildren)")
     print("wifi: \(hasWifi)")
     print("roomType: \(roomChoice)")
 }
 */
