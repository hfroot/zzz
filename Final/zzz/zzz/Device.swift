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
    static let SensorDataIndexAccX = 0
    static let SensorDataIndexAccY = 0
    static let SensorDataIndexAccZ = 0
}
