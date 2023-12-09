//
//  ShopInListWidget_ExtensionBundle.swift
//  ShopInListWidget Extension
//
//  Created by Vitalii Todorovych on 09.12.2023.
//

import WidgetKit
import SwiftUI

@main
struct ShopInListWidget_ExtensionBundle: WidgetBundle {
    var body: some Widget {
        ShopInListWidget_Extension()
        ShopInListWidget_ExtensionLiveActivity()
    }
}
