//
//  OptionsRow.swift
//  Eureka
//
//  Created by Martin Barreto on 2/23/16.
//  Copyright © 2016 Xmartlabs. All rights reserved.
//

import Foundation
import UIKit

public class OptionsRow<T: Equatable, Cell: CellType where Cell: BaseCell, Cell: TypedCellType, Cell.Value == T> : Row<T, Cell>, NoValueDisplayTextConformance {
    
    public var options: [T] {
        get { return dataProvider?.arrayData ?? [] }
        set { dataProvider = DataProvider(arrayData: newValue) }
    }
    public var selectorTitle: String?
    public var noValueDisplayText: String?
    
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}