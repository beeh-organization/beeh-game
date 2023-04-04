//
//  ViewCoding.swift
//  beeh-game
//
//  Created by Thiago Henrique on 04/04/23.
//

import Foundation

protocol ViewCoding: AnyObject {
    func setupConstraints()
    func addViewHierarchy()
    func addionalConfiguration()
}

extension ViewCoding {
    func addionalConfiguration() {}
    
    func buildLayout() {
        addViewHierarchy()
        setupConstraints()
        addionalConfiguration()
    }
}
