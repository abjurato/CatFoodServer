//
//  FoodListHandler.swift
//  CatFoodServer
//
//  Created by vixi on 01.05.16.
//  Copyright © 2016 Anatoly Rosencrantz. All rights reserved.
//

import PerfectLib
import PostgreSQL

class FoodListHandler: PageHandler {
    let dbHost = "localhost"
    let dbName = "cat_food"
    let dbUsername = ""//PUT YOUR SYSTEM USERNAME HERE!
    let dbPassword = ""
    
    func valuesForResponse(context: MustacheEvaluationContext, collector: MustacheEvaluationOutputCollector) throws -> MustacheEvaluationContext.MapType {
        
        //open postgre db
        let pgsl = PostgreSQL.PGConnection()
        
        pgsl.connectdb("host='\(dbHost)' dbname='\(dbName)' user='\(dbUsername)' password='\(dbPassword)'")
        
        defer {
            pgsl.close()
        }
        
        guard pgsl.status() != .Bad else {
            throw PerfectError.FileError(500, "Internal Server Error - failed to connect to db")
        }
        
        //execute query
        let queryResult = pgsl.exec("SELECT * FROM food;")
        
        guard queryResult.status() == .CommandOK || queryResult.status() == .TuplesOK else {
            throw PerfectError.FileError(500, "Internal Server Error - db query error")
        }
        
        guard case let numberOfFields = queryResult.numFields() where numberOfFields != 0 else {
            throw PerfectError.FileError(500, "Internal Server Error - db returned nothing")
        }
        
        guard case let numberOfRows = queryResult.numTuples() where numberOfRows != 0 else {
            throw PerfectError.FileError(204, "Internal Server Error - query returned empty result")
        }
        
        //parse from db names and types to something we want to work with
        var parameters: [[String:Any]] = []
        0.stride(to: numberOfRows, by: 1).forEach { indexOfRow in
            var parameter = [String:Any]()
            
            0.stride(to: numberOfFields, by: 1).forEach { indexOfField in
                guard let fieldName = queryResult.fieldName(indexOfField) else {
                    return
                }
                
                switch fieldName {
                case "name":
                    parameter["name"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "brand":
                    parameter["brand"] = queryResult.getFieldString(indexOfRow, fieldIndex: indexOfField)
                case "with_glutein":
                    parameter["contains glutein"] = queryResult.getFieldBool(indexOfRow, fieldIndex: indexOfField)
                case "price":
                    parameter["price"] = queryResult.getFieldInt(indexOfRow, fieldIndex: indexOfField)
                default: break
                }
            }
            
            //last row does not need comma, so we're setting flag
            if indexOfRow == numberOfRows-1 {
                parameter["last"] = true
            }
            
            parameters.append(parameter)
        }
        
        //and wrap this into MustacheEvaluationContext.MapType with approreate key
        let dict: MustacheEvaluationContext.MapType = ["whole list":parameters]
        
        return dict
    }
}
