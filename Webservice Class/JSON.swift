//
//  JSON.swift
//  Woodpecker
//
//  Created by Arun Kumar on 3/9/16.
//  Copyright © 2016 Arun. All rights reserved.
//

import UIKit

// MARK : Initializers
public struct JSON
{
    public let object : AnyObject?
    
    
    public init(_ object : AnyObject?)
    {
        self.init(object : object)
    }
    
    public init(_ data : NSData?)
    {
        self.init(object : JSON.objectWithData(data))
    }
    
    private init(object : AnyObject?)
    {
        self.object = object
    }
}

// MARK : Subscript

extension JSON
{
    public subscript(key : String) -> JSON
        {
        
            if object == nil {return self}
            if let jsonDict = jsonDictionary
            {
                return JSON(jsonDict[key])
            }
            return JSON(object: nil)
    }
    
    public subscript(index : Int) -> JSON
        {
        if object == nil {return self}
           
            if let jsonArr = jsonArray
            {
                return JSON(jsonArr[prevent : index])
            }
            return JSON(object: nil)
            
    }
}

// MARK : String Convertible

extension JSON
{
    public var string : String? {return object as? String}
    public var stringValue : String { return string ?? ""}
}

// MARK : Int Convertible

extension JSON
{
    public var int : Int? {return object as? Int}
    public var intValue : Int { return int ?? 0}
}

// MARK : Float & Double Convertible

extension JSON
{
    public var double : Double? {return object as? Double}
    public var doubleValue : Double { return double ?? 0.00}
    
    public var float : Float? {return object as? Float}
    public var floatValue : Float { return float ?? 0.00}
}

// MARK : Bool Convertible

extension JSON
{
    public var bool : Bool? {return object as? Bool}
    public var boolValue : Bool { return bool ?? false}
}

// MARK : Dictionary Convertible

extension JSON
{
    public var dictionary : [String : AnyObject]? {return object as? [String : AnyObject]}
    public var dictionaryValue : [String : AnyObject] { return dictionary ?? [:]}
}

extension JSON
{
    public var JSONdict : [String : JSON]? {return dictionary?.reduceValues{JSON($0)}}
    
    public var JSONDictValue : [String : JSON] {return JSONdict ?? [:]}
}


// MARK: Array

extension JSON
{
    public var array : [AnyObject]? {return object as? [AnyObject]}
    public var arrayValue : [AnyObject] {return array ?? []}
}


extension JSON
{
    public var JSONArray : [JSON]? {return array?.map{JSON($0)}}
    
    public var JSONArrayValue : [JSON]? {return JSONArray ?? []}
}
private extension JSON
{
    var jsonDictionary : NSDictionary? { return object as? NSDictionary}
}
private extension JSON
{
    var jsonArray : NSArray? {return object as? NSArray}
}
private extension NSArray
{
    subscript(prevent index:Int) -> AnyObject?
        {
            guard index >= 0 && index < count else {return nil}
            return self[index]
    }
}
private extension Dictionary
{
    func reduceValues <T: Any>(transform : (value : Value) -> T) -> [Key : T]
    {
        return reduce([Key : T]()){(cDict , kv) in
            var curDict = cDict
            curDict[kv.0] = transform(value: kv.1)
            return curDict
        }
    }
}

// MARK: Operators

infix operator <|
{
associativity right
precedence 90
}

public func <| <T: Any>(inout lhs: T , json : JSON)
{
    if let value = json.object as? T{
        lhs = value
    }
}

public func <| <T: Any>(inout lhs: T? , json : JSON)
{
    if let value = json.object as? T{
        lhs = value
    }
}

public func <| <T: Any>(inout lhs: T! , json : JSON)
{
    if let value = json.object as? T{
        lhs = value
    }
}


infix operator <?
{
associativity right
precedence 90
}

public func <? <T:Any>(inout lhs : T? , json : JSON)
{
    lhs = json.object as? T
}
public func <? <T:Any>(inout lhs : T! , json : JSON)
{
    lhs = json.object as? T
}

infix operator <!
{
associativity right
precedence 90
}

public func <! <T:Any>(inout lhs : T , json : JSON)
{
    if let value = json.object as? T ?? JSON.defaultValueFor(T.self)
    {
        lhs = value
    }
   
}
public func <! <T:Any>(inout lhs : T? , json : JSON)
{
    if let value = json.object as? T ?? JSON.defaultValueFor(T.self)
    {
        lhs = value
    }
}
public func <! <T:Any>(inout lhs : T! , json : JSON)
{
    if let value = json.object as? T ?? JSON.defaultValueFor(T.self)
    {
        lhs = value
    }
}

private extension JSON
{
    
    static func objectWithData(data : NSData?) -> AnyObject?
    {
        if let data = data
        {
            do {
                
                return try NSJSONSerialization.JSONObjectWithData(data, options: [])
            }
            catch _{
               return nil
            }
        }
        return nil
    }
    
    static func defaultValueFor<T:Any>(type : T.Type) -> T?
    {
        switch type
        {
        case is String.Type:
            return "" as? T
        case is Int.Type:
            return 0 as? T
        case is Double.Type:
            return 0.0 as? T
        case is Float.Type:
            return Float(0) as? T
        case is Bool.Type:
            return false as? T
        case is [String : AnyObject].Type:
            return [:] as? T
        case is [AnyObject].Type:
            return [] as? T
            
        default :
            return nil
        }
    }
}

// MARK : Sequence Type

extension JSON : SequenceType
{
    public func generate() -> AnyGenerator<JSON> {
        
        guard let array = jsonArray else {return AnyGenerator{nil} }
        
        var index = 0
        
        
        return AnyGenerator
            {
                if index < array.count
                {
                    index = index+1
                    return JSON(array[index])
                }
                else
                {
                    return nil
                }
        }
    }
}

// MARK: LiteralConvertible

extension JSON : StringLiteralConvertible
{


    public init(stringLiteral value: StringLiteralType)
    {
        self.init(value)
    }
    
    public init(extendedGraphemeClusterLiteral value: StringLiteralType) {
        self.init(value)
    }
    
    public init(unicodeScalarLiteral value: StringLiteralType) {
        self.init(value)
    }
    
}

extension JSON : IntegerLiteralConvertible
{
     public init(integerLiteral value: IntegerLiteralType)
     {
        self.init(value)
    }
}
extension JSON : FloatLiteralConvertible
{
     public init(floatLiteral value: FloatLiteralType)
{
        self.init(value)
}
}
extension JSON : BooleanLiteralConvertible
{
     public init(booleanLiteral value: BooleanLiteralType)
{
self.init(value)
}
}

extension JSON : DictionaryLiteralConvertible
{
    public init(dictionaryLiteral elements: (String, AnyObject)...)
    {
        var dictionary = [String:AnyObject]()
        for (key , value) in elements
        {
            dictionary[key] = value
        }
        self.init(dictionary)
    }
}

extension JSON: ArrayLiteralConvertible
{
    public init(arrayLiteral elements: AnyObject...)
{
self.init(elements)
}
}

extension JSON : NilLiteralConvertible
{
    public init(nilLiteral: ())
    {
        self.init(object : nil)
    }
}
