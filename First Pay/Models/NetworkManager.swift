//
//  NetworkManager.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 12/11/2018.
//  Copyright © 2018 FMFB Pakistan. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireObjectMapper

class NetworkManager {
    
    static let sharedInstance = NetworkManager()
    var sessionManager: SessionManager?
    
    func enableCertificatePinning() {

//         For certificates
//                let trustPolicy = ServerTrustPolicy.pinCertificates(
//                    certificates: ServerTrustPolicy.certificates(),
//                    validateCertificateChain: true,
//                    validateHost: true)

        // For PublicKey pining
        let serverTrustPolicy = ServerTrustPolicy.pinPublicKeys(
            publicKeys: ServerTrustPolicy.publicKeys(),
            validateCertificateChain: true,
            validateHost: true)

        let trustPolicies = [ "https://bb.fmfb.pk": serverTrustPolicy ]
        let policyManager =  ServerTrustPolicyManager(policies: trustPolicies)
        sessionManager = SessionManager(
            configuration: .default,
            serverTrustPolicyManager: policyManager)
    }
}


