//
//  LockedUserTokenListManager.swift
//  Tangem
//
//  Created by Andrew Son on 28/07/23.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import Foundation
import Combine

struct LockedUserTokenListManager: UserTokenListManager {
    var initialized: Bool { true }

    var initializedPublisher: AnyPublisher<Bool, Never> { .just(output: true) }

    var userTokens: [StorageEntry] { [] }

    var userTokensPublisher: AnyPublisher<[StorageEntry], Never> { .just(output: []) }

    var userTokensList: StoredUserTokenList { .empty }

    var userTokensListPublisher: AnyPublisher<StoredUserTokenList, Never> { .just(output: .empty) }

    func update(with userTokenList: StoredUserTokenList) {}

    func update(_ type: UserTokenListUpdateType, shouldUpload: Bool) {}

    func updateLocalRepositoryFromServer(_ completion: @escaping (Result<Void, Error>) -> Void) {
        completion(.success(()))
    }

    func upload() {}
}