//
//  BaseTableViewCell.swift
//  avana_demo
//
//  Created by Iglo-macpro on 20/03/21.
//

import UIKit

class BaseTableViewCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        selectionStyle = .none
        initView()
    }
    
    func initView() {
    }
    
    static var identifier: String {
        return String(describing: self)
    }
}
