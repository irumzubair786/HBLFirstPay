//
//  main.swift
//  First Wallet
//
//  Created by Syed Uzair Ahmed on 09/05/2019.
//  Copyright © 2019 FMFB Pakistan. All rights reserved.
//

import Foundation
import UIKit

CommandLine.unsafeArgv.withMemoryRebound(to: UnsafeMutablePointer<Int8>.self, capacity: Int(CommandLine.argc))
{    argv in
    _ = UIApplicationMain(CommandLine.argc, argv, NSStringFromClass(TimerApplication.self), NSStringFromClass(AppDelegate.self))
}
