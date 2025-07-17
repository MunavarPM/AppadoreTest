//
//  Color+Extensions.swift
//  Appadore
//
//  Created by Munavar on 17/07/2025.
//

import SwiftUI

// MARK: Colors kit for `Standart`
extension Color {
    /**
     Colors kit for `Standard` styling.
     
     This extension provides a set of predefined colors for customizing the appearance of exts.
     Usage:
     ```
     
     let color = Color.standard.secondary
     
     ```
     **/
    public enum standard {
        
        public static let primary: Color = Color("clOrange")
        public static let successGreen: Color = Color("clGreen")
        public static let lightGray: Color = Color("clGray")
        public static let darkGray: Color = Color("clDGray")
        
        
    }
}

