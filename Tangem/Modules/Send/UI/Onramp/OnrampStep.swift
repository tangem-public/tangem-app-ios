//
//  OnrampStep.swift
//  TangemApp
//
//  Created by Sergey Balashov on 18.10.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class OnrampStep {
    private let tokenItem: TokenItem
    private let viewModel: OnrampViewModel
    private let interactor: OnrampInteractor

    init(
        tokenItem: TokenItem,
        viewModel: OnrampViewModel,
        interactor: OnrampInteractor
    ) {
        self.tokenItem = tokenItem
        self.viewModel = viewModel
        self.interactor = interactor
    }

    func setup(router: OnrampSummaryRoutable) {
        viewModel.router = router
    }
}

// MARK: - SendStep

extension OnrampStep: SendStep {
    var title: String? { "\(Localization.commonBuy) \(tokenItem.name)" }

    var type: SendStepType { .onramp(viewModel) }

    var sendStepViewAnimatable: any SendStepViewAnimatable { viewModel }

    var isValidPublisher: AnyPublisher<Bool, Never> {
        interactor.isValidPublisher
    }
}
