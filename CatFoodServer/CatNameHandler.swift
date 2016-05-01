//
//  CatNameHandler.swift
//  CatFoodServer
//
//  Created by Anatoly Rosencrantz on 30.04.16.
//  Copyright © 2016 Anatoly Rosencrantz. All rights reserved.
//

import PerfectLib

class CatNameHandler: PageHandler {
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        let dict:MustacheEvaluationContext.MapType = ["name": "Sasha"]
        
        return dict
    }
}
