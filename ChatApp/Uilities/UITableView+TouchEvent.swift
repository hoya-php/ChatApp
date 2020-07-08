//
//  UITableView+TouchEvent.swift
//  ChatApp
//
//  Created by 伊藤和也 on 2020/07/07.
//  Copyright © 2020 kazuya ito. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.next?.touchesBegan(touches, with: event)
    }
}
