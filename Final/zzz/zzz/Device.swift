//
//  Device.swift
//  zzz
//
//  Created by Pierre Azalbert on 08/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

//------------------------------------------------------------------------
// Information about Texas Instruments SensorTag UUIDs can be found at:
// http://processors.wiki.ti.com/index.php/CC2650_SensorTag_User's_Guide
//------------------------------------------------------------------------
// From the TI documentation:
//  The TI Base 128-bit UUID is: F0000000-0451-4000-B000-000000000000.
//
//  All sensor services use 128-bit UUIDs, but for practical reasons only
//  the 16-bit part is listed in this document.
//
//  It is embedded in the 128-bit UUID as shown by example below.
//
//          Base 128-bit UUID:  F0000000-0451-4000-B000-000000000000
//          "0xAA01" maps as:   F000AA01-0451-4000-B000-000000000000
//                                  ^--^
//------------------------------------------------------------------------

struct Device {
    
    static let SensorTagAdvertisingUUID = "AA10"
    
    static let TemperatureServiceUUID = "F000AA00-0451-4000-B000-000000000000"
    static let TemperatureDataUUID = "F000AA01-0451-4000-B000-000000000000"
    static let TemperatureConfig = "F000AA02-0451-4000-B000-000000000000"
    
    static let HumidityServiceUUID = "F000AA20-0451-4000-B000-000000000000"
    static let HumidityDataUUID = "F000AA21-0451-4000-B000-000000000000"
    static let HumidityConfig = "F000AA22-0451-4000-B000-000000000000"
    
    static let AccServiceUUID = "F000AA80-0451-4000-B000-000000000000"
    static let AccDataUUID = "F000AA81-0451-4000-B000-000000000000"
    static let AccConfig = "F000AA82-0451-4000-B000-000000000000"
    
    static let LightServiceUUID = "F000AA70-0451-4000-B000-000000000000"
    static let LightDataUUID = "F000AA71-0451-4000-B000-000000000000"
    static let LightConfig = "F000AA72-0451-4000-B000-000000000000"

    static let SensorDataIndexTempInfrared = 0
    static let SensorDataIndexTempAmbient = 1
    static let SensorDataIndexHumidityTemp = 0
    static let SensorDataIndexHumidity = 1
    static let SensorDataIndexLight = 0
    static let SensorDataIndexAccX = 3
    static let SensorDataIndexAccY = 4
    static let SensorDataIndexAccZ = 5
    
}

// Globlal variables for samples
public var sampleTimestamp:Date?
public var sampleTemp:Float?
public var sampleHumi:Float?
public var sampleLight:Float?
public var sampleAccX:Float?
public var sampleAccY:Float?
public var sampleAccZ:Float?

// MARK: - TI Sensor Tag Utility Methods

func getTemperature(_ data:Data) -> Float {
    
    // We'll get four bytes of data back, so we divide the byte count by two
    // because we're creating an array that holds two 16-bit (two-byte) values
    let dataLength = data.count / MemoryLayout<UInt16>.size
    var dataArray = [UInt16](repeating: 0, count: dataLength)
    (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
    
    let rawAmbientTemp:UInt16 = dataArray[Device.SensorDataIndexTempAmbient]
    let ambientTempC = Float(rawAmbientTemp) / 128.0
    //print("*** TEMPERATURE: \(ambientTempC)° C")
    
    return ambientTempC
}

func getHumidity(_ data:Data) -> Float {
    
    let dataLength = data.count / MemoryLayout<UInt16>.size
    var dataArray = [UInt16](repeating: 0, count: dataLength)
    (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
    
    let rawHumidity:UInt16 = dataArray[Device.SensorDataIndexHumidity]
    let calculatedHumidity = Float(calculateRelativeHumidity(rawHumidity))
    //        print("*** HUMIDITY: \(calculatedHumidity)");
    
    return calculatedHumidity
}

func getLight(_ data:Data) -> Float {
    
    let dataLength = data.count / MemoryLayout<UInt16>.size
    var dataArray = [UInt16](repeating: 0, count: dataLength)
    (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
    
    let rawLight:UInt16 = dataArray[Device.SensorDataIndexLight]
    let calculatedLight = calculateLightIntensity(rawLight)
    //        print("*** LIGHT: \(calculatedLight)");
    
    return Float(calculatedLight)
}

func getAccel(_ data:Data) -> [Float] {
    
    let dataLength = data.count / MemoryLayout<UInt16>.size
    var dataArray = [UInt16](repeating: 0, count: dataLength)
    (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
    
    let rawAccX:UInt16 = dataArray[Device.SensorDataIndexAccX]
    let rawAccY:UInt16 = dataArray[Device.SensorDataIndexAccY]
    let rawAccZ:UInt16 = dataArray[Device.SensorDataIndexAccZ]
    
    let calculatedAccX:Float = Float(calculateAcc(rawAccX))
    let calculatedAccY:Float = Float(calculateAcc(rawAccY))
    let calculatedAccZ:Float = Float(calculateAcc(rawAccZ))
    
    return [calculatedAccX, calculatedAccY, calculatedAccZ]
}

func calculateRelativeHumidity(_ rawH:UInt16) -> Double {
    // clear status bits [1..0]
    let clearedH = rawH & ~0x003
    
    //-- calculate relative humidity [%RH] --
    // RH= -6 + 125 * SRH/2^16
    let relativeHumidity:Double = -6.0 + 125.0/65536 * Double(clearedH)
    return relativeHumidity
}

func calculateLightIntensity(_ rawL:UInt16) -> Double {
    let m = rawL & 0x0FFF
    let e = (rawL & 0xF000) >> 12
    let LightIntensity:Double = Double(m) * (0.01 * pow(2.0, Double(e)))
    return LightIntensity
}

func calculateAcc(_ rawAcc:UInt16) -> Double {
    let calculatedAcc:Double = (Double(rawAcc) * 1.0) / (32768/8);
    return calculatedAcc
}
