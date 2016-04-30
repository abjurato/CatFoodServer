//
//  PerfectHandlers.swift
//  CatFoodServer
//
//  Created by Anatoly Rosencrantz on 30.04.16.
//  Copyright © 2016 Anatoly Rosencrantz. All rights reserved.
//

import PerfectLib

// This function is required. The Perfect framework expects to find this function
// to do initialization
public func PerfectServerModuleInit() {

    PageHandlerRegistry.addPageHandler("CatName") {
        // This closure is called in order to create the handler object.
        // It is called once for each relevant request.
        // The supplied WebResponse object can be used to tailor the return value.
        // However, all request processing should take place in the `valuesForResponse` function.
        (r:WebResponse) -> PageHandler in
        
        return CatNameHandler()
    }
}