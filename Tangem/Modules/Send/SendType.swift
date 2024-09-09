//
//  SendType.swift
//  Tangem
//
//  Created by Andrey Chukavin on 10.11.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import TangemStaking

enum SendType {
    case send
    case sell(parameters: PredefinedSellParameters)
    case staking(manager: StakingManager)
}

struct PredefinedSellParameters {
    let amount: Decimal
    let destination: String
    let tag: String?
}