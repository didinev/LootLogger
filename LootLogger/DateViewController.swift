//
//  DateViewController.swift
//  LootLogger
//
//  Created by Dimitar Dinev on 14.04.21.
//

import UIKit

class DateViewController: UIViewController {
    @IBOutlet var datePicker: UIDatePicker!
    
    var item: Item!

    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker.datePickerMode = .date
        datePicker.date = item.dateCreated
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        item.dateCreated = datePicker.date
    }
}
