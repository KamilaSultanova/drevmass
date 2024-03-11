//
// ProductCellProtocol
// Created by Nurasyl on 20.11.2023.
// Copyright © 2023 Drevmass. All rights reserved.
//

import UIKit

protocol ProductCellProtocol: UITableViewCell {
    func setData(withProduct product: Product)
}
