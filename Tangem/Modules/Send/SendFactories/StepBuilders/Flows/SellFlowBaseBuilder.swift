//
//  SellFlowBaseBuilder.swift
//  Tangem
//
//  Created by Sergey Balashov on 09.07.2024.
//  Copyright © 2024 Tangem AG. All rights reserved.
//

import Foundation

struct SellFlowBaseBuilder {
    let userWalletModel: UserWalletModel
    let walletModel: WalletModel

    let sendFeeStepBuilder: SendFeeStepBuilder
    let sendSummaryStepBuilder: SendSummaryStepBuilder
    let sendFinishStepBuilder: SendFinishStepBuilder
    let builder: SendDependenciesBuilder

    func makeSendViewModel(sellParameters: PredefinedSellParameters, router: SendRoutable) -> SendViewModel {
        let notificationManager = builder.makeSendNotificationManager()
        let addressTextViewHeightModel = AddressTextViewHeightModel()
        let sendTransactionDispatcher = builder.makeSendTransactionDispatcher()

        let sendModel = builder.makeSendModel(
            sendTransactionDispatcher: sendTransactionDispatcher,
            predefinedSellParameters: sellParameters
        )

        let fee = sendFeeStepBuilder.makeFeeSendStep(
            io: (input: sendModel, output: sendModel),
            notificationManager: notificationManager,
            router: router
        )

        let summary = sendSummaryStepBuilder.makeSendSummaryStep(
            io: (input: sendModel, output: sendModel),
            sendTransactionDispatcher: sendTransactionDispatcher,
            notificationManager: notificationManager,
            addressTextViewHeightModel: addressTextViewHeightModel,
            editableType: .disable
        )

        let finish = sendFinishStepBuilder.makeSendFinishStep(
            addressTextViewHeightModel: addressTextViewHeightModel
        )

        // We have to set dependicies here after all setups is completed
        sendModel.sendFeeInteractor = fee.interactor
        sendModel.informationRelevanceService = builder.makeInformationRelevanceService(
            sendFeeInteractor: fee.interactor
        )

        // Update the fees in case we in the sell flow
        fee.interactor.updateFees()

        // If we want to notifications in the sell flow
        // 1. Uncomment code below
        // 2. Set the `sendAmountInteractor` into `sendModel`
        // to support the amount changes from the notification's buttons

        // notificationManager.setup(input: sendModel)
        // notificationManager.setupManager(with: sendModel)

        summary.step.setup(sendDestinationInput: sendModel)
        summary.step.setup(sendAmountInput: sendModel)
        summary.step.setup(sendFeeInput: sendModel)

        finish.setup(sendDestinationInput: sendModel)
        finish.setup(sendAmountInput: sendModel)
        finish.setup(sendFeeInput: sendModel)
        finish.setup(sendFinishInput: sendModel)

        let stepsManager = CommonSellStepsManager(
            feeStep: fee.step,
            summaryStep: summary.step,
            finishStep: finish
        )

        summary.step.set(router: stepsManager)

        let interactor = CommonSendBaseInteractor(
            input: sendModel,
            output: sendModel,
            walletModel: walletModel,
            emailDataProvider: userWalletModel
        )

        let viewModel = SendViewModel(
            interactor: interactor,
            stepsManager: stepsManager,
            userWalletModel: userWalletModel,
            feeTokenItem: walletModel.feeTokenItem,
            coordinator: router
        )
        stepsManager.set(output: viewModel)

        fee.step.set(alertPresenter: viewModel)
        sendModel.router = viewModel

        return viewModel
    }
}