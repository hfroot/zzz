//
//  SensorViewController.swift
//  zzz
//
//  Created by Pierre Azalbert on 08/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//

import UIKit
import CoreBluetooth
import RealmSwift

class SensorViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @IBOutlet weak var controlContainerView: UIView!
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var userLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var lightLabel: UILabel?
    @IBOutlet weak var accXLabel: UILabel?
    @IBOutlet weak var accYLabel: UILabel?
    @IBOutlet weak var accZLabel: UILabel?
    //@IBOutlet weak var totalaccLabel: UILabel?
    @IBOutlet weak var disconnectButton: UIButton?
    
    // define scanning interval times
    let timerPauseInterval:TimeInterval = 10.0
    let timerScanInterval:TimeInterval = 2.0
    
    // UI-related
    var keepScanning = false
    //var isScanning = false
    
    // Core Bluetooth properties
    var centralManager:CBCentralManager!
    var sensorTag:CBPeripheral?
    var temperatureCharacteristic:CBCharacteristic?
    var humidityCharacteristic:CBCharacteristic?
    var lightCharacteristic:CBCharacteristic?
    var accCharacteristic:CBCharacteristic?
    
    // This could be simplified to "SensorTag" and check if it's a substring.
    // (Probably a good idea to do that if you're using a different model of
    // the SensorTag, or if you don't know what model it is...)
    let sensorTagName = "CC2650 SensorTag"
    
    // Realm variables initialisation
    var sensorData = List<sensorDataObject>()
    var sampleTimestamp:Date?
    var lastTimestamp:Date? = Date()
    var sampleTemp:Float?
    var sampleHumi:Float?
    var sampleLight:Float?
    var sampleAccX:Float?
    var sampleAccY:Float?
    var sampleAccZ:Float?
    // var sampletotalacc:Float?
    
    //Definition of accel parameters
    var ACC_RANGE_2G = 0
    var ACC_RANGE_4G = 1
    var ACC_RANGE_8G = 2
    var ACC_RANGE_16G = 3
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create our CBCentral Manager
        // delegate: The delegate that will receive central role events. Typically self.
        // queue:    The dispatch queue to use to dispatch the central role events.
        //           If the value is nil, the central manager dispatches central role events using the main queue.
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Central Manager Initialization Options (Apple Developer Docs): http://tinyurl.com/zzvsgjh
        //  CBCentralManagerOptionShowPowerAlertKey
        //  CBCentralManagerOptionRestoreIdentifierKey
        //      To opt in to state preservation and restoration in an app that uses only one instance of a
        //      CBCentralManager object to implement the central role, specify this initialization option and provide
        //      a restoration identifier for the central manager when you allocate and initialize it.
        //centralManager = CBCentralManager(delegate: self, queue: nil, options: nil)
        
        // configure initial UI
        userLabel?.text = "User: \(currentUser.firstName)"
        statusLabel?.text = "Idle"
        temperatureLabel?.text = "Temperature: N/A"
        humidityLabel?.text = "Humidity: N/A"
        lightLabel?.text = "Light: N/A"
        accXLabel?.text = "Acc X: N/A"
        accYLabel?.text = "Acc Y: N/A"
        accZLabel?.text = "Acc Z: N/A"
        //totalaccLabel?.text = "Acc:"
        disconnectButton?.setTitle("Connect SensorTag", for: .normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Handling User Interaction
    
    @IBAction public func handleDisconnectButtonTapped(_ sender: AnyObject) {
        // if we don't have a sensor tag, start scanning for one...
        if sensorTag == nil {
            keepScanning = true
            resumeScan()
            return
        } else {
            disconnect()
            disconnectButton?.setTitle("Connect SensorTag", for: .normal)
        }
    }
    
    func disconnect() {
        if let sensorTag = self.sensorTag {
            if let tc = self.temperatureCharacteristic {
                sensorTag.setNotifyValue(false, for: tc)
            }
            if let hc = self.humidityCharacteristic {
                sensorTag.setNotifyValue(false, for: hc)
            }
            if let lc = self.lightCharacteristic {
                sensorTag.setNotifyValue(false, for: lc)
            }
            
            if let ac = self.accCharacteristic {
                sensorTag.setNotifyValue(false, for: ac)
            }
            
            /*
             NOTE: The cancelPeripheralConnection: method is nonblocking, and any CBPeripheral class commands
             that are still pending to the peripheral you’re trying to disconnect may or may not finish executing.
             Because other apps may still have a connection to the peripheral, canceling a local connection
             does not guarantee that the underlying physical link is immediately disconnected.
             
             From your app’s perspective, however, the peripheral is considered disconnected, and the central manager
             object calls the centralManager:didDisconnectPeripheral:error: method of its delegate object.
             */
            centralManager.cancelPeripheralConnection(sensorTag)
        }
        temperatureCharacteristic = nil
        humidityCharacteristic = nil
        lightCharacteristic = nil
        accCharacteristic = nil
    }
    
    
    // MARK: - Bluetooth scanning
    
    func pauseScan() {
        // Scanning uses up battery on phone, so pause the scan process for the designated interval.
        print("*** PAUSING SCAN...")
        _ = Timer(timeInterval: timerPauseInterval, target: self, selector: #selector(resumeScan), userInfo: nil, repeats: false)
        centralManager.stopScan()
        disconnectButton?.isEnabled = true
    }
    
    func resumeScan() {
        if keepScanning {
            // Start scanning again...
            print("*** RESUMING SCAN!")
            disconnectButton?.isEnabled = false
            statusLabel?.text = "Searching"
            _ = Timer(timeInterval: timerScanInterval, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            disconnectButton?.isEnabled = true
        }
    }
    
    
    // MARK: - Updating UI
    
    func displayTemperature(_ data:Data) {
        // We'll get four bytes of data back, so we divide the byte count by two
        // because we're creating an array that holds two 16-bit (two-byte) values
        let dataLength = data.count / MemoryLayout<UInt16>.size
        var dataArray = [UInt16](repeating: 0, count: dataLength)
        (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
        
        let rawAmbientTemp:UInt16 = dataArray[Device.SensorDataIndexTempAmbient]
        let ambientTempC = Double(rawAmbientTemp) / 128.0
        //print("*** TEMPERATURE: \(ambientTempC)° C")
        
        temperatureLabel?.text = String(format: "Temperature: %.01f%°C", ambientTempC)
        sampleTemp = Float(ambientTempC)
    }
    
    func displayHumidity(_ data:Data) {
        let dataLength = data.count / MemoryLayout<UInt16>.size
        var dataArray = [UInt16](repeating: 0, count: dataLength)
        (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
        
        let rawHumidity:UInt16 = dataArray[Device.SensorDataIndexHumidity]
        let calculatedHumidity = calculateRelativeHumidity(rawHumidity)
        //        print("*** HUMIDITY: \(calculatedHumidity)");
        
        humidityLabel?.text = String(format: "Humidity: %.01f%%", calculatedHumidity)
        sampleHumi = Float(calculatedHumidity)
    }
    
    func displayLight(_ data:Data) {
        let dataLength = data.count / MemoryLayout<UInt16>.size
        var dataArray = [UInt16](repeating: 0, count: dataLength)
        (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
        
        let rawLight:UInt16 = dataArray[Device.SensorDataIndexLight]
        let calculatedLight = calculateLightIntensity(rawLight)
        //        print("*** LIGHT: \(calculatedLight)");
        
        lightLabel?.text = String(format: "Light: %.01f% LuLux", calculatedLight)
        sampleLight = Float(calculatedLight)
    }
    
    func displayAcc(_ data:Data) {
        let dataLength = data.count / MemoryLayout<UInt16>.size
        var dataArray = [UInt16](repeating: 0, count: dataLength)
        (data as NSData).getBytes(&dataArray, length: dataLength * MemoryLayout<Int16>.size)
        
        let rawAccX:UInt16 = dataArray[Device.SensorDataIndexAccX]
        let rawAccY:UInt16 = dataArray[Device.SensorDataIndexAccY]
        let rawAccZ:UInt16 = dataArray[Device.SensorDataIndexAccZ]
        
        let calculatedAccX = calculateAcc(rawAccX)
        let calculatedAccY = calculateAcc(rawAccY)
        let calculatedAccZ = calculateAcc(rawAccZ)
        
        sampleAccX = Float(calculatedAccX)
        sampleAccY = Float(calculatedAccY)
        sampleAccZ = Float(calculatedAccZ)
        //sampletotalacc = sqrt(pow(sampleAccX!,2) + pow(sampleAccY!,2) + pow(sampleAccZ!,2))
        accXLabel?.text = String(format: "Acc X: %.01f%", sampleAccX!)
        accYLabel?.text = String(format: "Acc Y: %.01f%", sampleAccY!)
        accZLabel?.text = String(format: "Acc Z: %.01f%", sampleAccZ!)
        //totalaccLabel?.text = String(format: "Acc: %.01f%", sampletotalacc!)
    }
    
    // MARK: - CBCentralManagerDelegate methods
    
    // Invoked when the central manager’s state is updated.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        var showAlert = true
        var message = ""
        
        switch central.state {
        case .poweredOff:
            message = "Bluetooth on this device is currently powered off."
        case .unsupported:
            message = "This device does not support Bluetooth Low Energy."
        case .unauthorized:
            message = "This app is not authorized to use Bluetooth Low Energy."
        case .resetting:
            message = "The BLE Manager is resetting; a state update is pending."
        case .unknown:
            message = "The state of the BLE Manager is unknown."
        case .poweredOn:
            showAlert = false
            message = "Bluetooth LE is turned on and ready for communication."
            
            print(message)
            keepScanning = true
            _ = Timer(timeInterval: timerScanInterval, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
            
            // Initiate Scan for Peripherals
            // Option 1: Scan for all devices
            centralManager.scanForPeripherals(withServices: nil, options: nil)
            
            // Option 2: Scan for devices that have the service you're interested in...
            //let sensorTagAdvertisingUUID = CBUUID(string: Device.SensorTagAdvertisingUUID)
            //print("Scanning for SensorTag adverstising with UUID: \(sensorTagAdvertisingUUID)")
            //centralManager.scanForPeripheralsWithServices([sensorTagAdvertisingUUID], options: nil)
            
        }
        
        if showAlert {
            let alert = UIAlertController(title: "Central Manager State", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    /*
     Invoked when the central manager discovers a peripheral while scanning.
     
     The advertisement data can be accessed through the keys listed in Advertisement Data Retrieval Keys.
     You must retain a local copy of the peripheral if any command is to be performed on it.
     In use cases where it makes sense for your app to automatically connect to a peripheral that is
     located within a certain range, you can use RSSI data to determine the proximity of a discovered
     peripheral device.
     
     central - The central manager providing the update.
     peripheral - The discovered peripheral.
     advertisementData - A dictionary containing any advertisement data.
     RSSI - The current received signal strength indicator (RSSI) of the peripheral, in decibels.
     
     */
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        //print("centralManager didDiscoverPeripheral - CBAdvertisementDataLocalNameKey is \"\(CBAdvertisementDataLocalNameKey)\"")
        
        // Retrieve the peripheral name from the advertisement data using the "kCBAdvDataLocalName" key
        if let peripheralName = advertisementData[CBAdvertisementDataLocalNameKey] as? String {
            //print("NEXT PERIPHERAL NAME: \(peripheralName)")
            //print("NEXT PERIPHERAL UUID: \(peripheral.identifier.uuidString)")
            
            if peripheralName == sensorTagName {
                print("**** SENSOR TAG FOUND! ADDING NOW!!!")
                // to save power, stop scanning for other devices
                keepScanning = false
                disconnectButton?.isEnabled = true
                
                // save a reference to the sensor tag
                sensorTag = peripheral
                sensorTag!.delegate = self
                
                // Request a connection to the peripheral
                centralManager.connect(sensorTag!, options: nil)
            }
        }
    }
    
    /*
     Invoked when a connection is successfully created with a peripheral.
     
     This method is invoked when a call to connectPeripheral:options: is successful.
     You typically implement this method to set the peripheral’s delegate and to discover its services.
     */
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        print("**** SUCCESSFULLY CONNECTED TO SENSOR TAG!!!")
        
        statusLabel?.text = "Connected"
        disconnectButton?.setTitle("Disconnect SensorTag", for: .normal)
        
        // Now that we've successfully connected to the SensorTag, let's discover the services.
        // - NOTE:  we pass nil here to request ALL services be discovered.
        //          If there was a subset of services we were interested in, we could pass the UUIDs here.
        //          Doing so saves battery life and saves time.
        peripheral.discoverServices(nil)
    }
    
    /*
     Invoked when the central manager fails to create a connection with a peripheral.
     
     This method is invoked when a connection initiated via the connectPeripheral:options: method fails to complete.
     Because connection attempts do not time out, a failed connection usually indicates a transient issue,
     in which case you may attempt to connect to the peripheral again.
     */
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        print("**** CONNECTION TO SENSOR TAG FAILED!!!")
    }
    
    /*
     Invoked when an existing connection with a peripheral is torn down.
     
     This method is invoked when a peripheral connected via the connectPeripheral:options: method is disconnected.
     If the disconnection was not initiated by cancelPeripheralConnection:, the cause is detailed in error.
     After this method is called, no more methods are invoked on the peripheral device’s CBPeripheralDelegate object.
     
     Note that when a peripheral is disconnected, all of its services, characteristics, and characteristic descriptors are invalidated.
     */
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        print("**** DISCONNECTED FROM SENSOR TAG!!!")
        statusLabel?.text = "Tap to search"
        temperatureLabel?.text = "Temperature: N/A"
        humidityLabel?.text = "Humidity: N/A"
        lightLabel?.text = "Light: N/A"
        accXLabel?.text = "Acc X: N/A"
        accYLabel?.text = "Acc Y: N/A"
        accZLabel?.text = "Acc Z: N/A"
        //totalaccLabel?.text = "Acc: N/A"
        disconnectButton?.setTitle("Connect SensorTag", for: .normal)
        if error != nil {
            print("****** DISCONNECTION DETAILS: \(error!.localizedDescription)")
        }
        sensorTag = nil
    }
    
    //MARK: - CBPeripheralDelegate methods
    
    /*
     Invoked when you discover the peripheral’s available services.
     
     This method is invoked when your app calls the discoverServices: method.
     If the services of the peripheral are successfully discovered, you can access them
     through the peripheral’s services property.
     
     If successful, the error parameter is nil.
     If unsuccessful, the error parameter returns the cause of the failure.
     */
    // When the specified services are discovered, the peripheral calls the peripheral:didDiscoverServices: method of its delegate object.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if error != nil {
            print("ERROR DISCOVERING SERVICES: \(error?.localizedDescription)")
            return
        }
        
        // Core Bluetooth creates an array of CBService objects —- one for each service that is discovered on the peripheral.
        if let services = peripheral.services {
            for service in services {
                //print("Discovered service \(service)")
                // If we found either the temperature, the humidity, light intensity or service, discover the characteristics for those services.
                if (service.uuid == CBUUID(string: Device.TemperatureServiceUUID)) ||
                    (service.uuid == CBUUID(string: Device.HumidityServiceUUID)) ||
                    (service.uuid == CBUUID(string: Device.LightServiceUUID)) ||
                    (service.uuid == CBUUID(string: Device.AccServiceUUID)) {
                    //                        print(service.uuid)
                    peripheral.discoverCharacteristics(nil, for: service)
                }
            }
        }
    }
    
    /*
     Invoked when you discover the characteristics of a specified service.
     
     If the characteristics of the specified service are successfully discovered, you can access
     them through the service's characteristics property.
     
     If successful, the error parameter is nil.
     If unsuccessful, the error parameter returns the cause of the failure.
     */
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if error != nil {
            print("ERROR DISCOVERING CHARACTERISTICS: \(error?.localizedDescription)")
            return
        }
        
        if let characteristics = service.characteristics {
            
            let enableValue:UInt8 = 1
            let enableBytes = Data(bytes: [enableValue])
            let accEnableValue:[UInt8] = [0x7F, 0x00]
            let accEnableBytes:Data = Data.init(bytes: accEnableValue)
            //let accEnableValue:UInt8 = 0xFF //bits 3,4,5
            //let accEnableBytes = Data(bytes: [accEnableValue])
            
            for characteristic in characteristics {
                
                //                print(characteristic.uuid)
                
                // Temperature Data Characteristic
                if characteristic.uuid == CBUUID(string: Device.TemperatureDataUUID) {
                    // Enable the IR Temperature Sensor notifications
                    temperatureCharacteristic = characteristic
                    sensorTag?.setNotifyValue(true, for: characteristic)
                }
                
                // Temperature Configuration Characteristic
                if characteristic.uuid == CBUUID(string: Device.TemperatureConfig) {
                    // Enable IR Temperature Sensor
                    sensorTag?.writeValue(enableBytes, for: characteristic, type: .withResponse)
                }
                
                // Humidity Data Characteristic
                if characteristic.uuid == CBUUID(string: Device.HumidityDataUUID) {
                    // Enable Humidity Sensor notifications
                    humidityCharacteristic = characteristic
                    sensorTag?.setNotifyValue(true, for: characteristic)
                }
                
                // Humidity Configuration Characteristic
                if characteristic.uuid == CBUUID(string: Device.HumidityConfig) {
                    // Enable Humidity Sensor
                    sensorTag?.writeValue(enableBytes, for: characteristic, type: .withResponse)
                }
                
                // Light Data Characteristic
                if characteristic.uuid == CBUUID(string: Device.LightDataUUID) {
                    // Enable Light Sensor notifications
                    lightCharacteristic = characteristic
                    sensorTag?.setNotifyValue(true, for: characteristic)
                }
                
                // Light Configuration Characteristic
                if characteristic.uuid == CBUUID(string: Device.LightConfig) {
                    // Enable Light Sensor
                    sensorTag?.writeValue(enableBytes, for: characteristic, type: .withResponse)
                }
                
                // Acc Data Characteristic
                if characteristic.uuid == CBUUID(string: Device.AccDataUUID) {
                    // Enable Acc Sensor notifications
                    
                    sensorTag?.setNotifyValue(true, for: characteristic)
                }
                
                // Acc Configuration Characteristic
                // need to enable each accelerometer axis individually
                if characteristic.uuid == CBUUID(string: Device.AccConfig) {
                    // Enable Acc Sensor
                    sensorTag?.writeValue(accEnableBytes, for: characteristic, type: .withResponse)
                }
            }
        }
    }
    
    /*
     Invoked when you retrieve a specified characteristic’s value,
     or when the peripheral device notifies your app that the characteristic’s value has changed.
     
     This method is invoked when your app calls the readValueForCharacteristic: method,
     or when the peripheral notifies your app that the value of the characteristic for
     which notifications and indications are enabled has changed.
     
     If successful, the error parameter is nil.
     If unsuccessful, the error parameter returns the cause of the failure.
     */
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        if error != nil {
            print("ERROR ON UPDATING VALUE FOR CHARACTERISTIC: \(characteristic) - \(error?.localizedDescription)")
            return
        }
        
        // extract the data from the characteristic's value property and display the value based on the characteristic type
        
        
        if let dataBytes = characteristic.value {
            //            print(characteristic.uuid)
            if characteristic.uuid == CBUUID(string: Device.TemperatureDataUUID) {
                displayTemperature(dataBytes)
            } else if characteristic.uuid == CBUUID(string: Device.HumidityDataUUID) {
                displayHumidity(dataBytes)
            } else if characteristic.uuid == CBUUID(string: Device.LightDataUUID) {
                displayLight(dataBytes)
            } else if characteristic.uuid == CBUUID(string: Device.AccDataUUID) {
                displayAcc(dataBytes)
            }
            
            // Save timestamp just after reading data, then save sensorDataObject in Realm database
            let formatter = DateFormatter()
            formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

            sampleTimestamp = Date()
            
            if (currentUser.email != "") {
                if (sampleTemp != nil &&
                    sampleHumi != nil &&
                    sensorTag != nil &&
                    sampleLight != nil &&
                    sampleAccX != nil &&
                    sampleAccY != nil &&
                    sampleAccZ != nil &&
                    
                    formatter.string(from: sampleTimestamp!) != formatter.string(from: lastTimestamp!))  {
                
                    saveSample(sampleTemp:sampleTemp!,
                               sampleHumi:sampleHumi!,
                               sensorTag:sensorTag!.identifier.uuidString,
                               sampleLight:sampleLight!,
                               sampleAccX:sampleAccX!,
                               sampleAccY:sampleAccY!,
                               sampleAccZ:sampleAccZ!,
                               sampleTimestamp:sampleTimestamp!,
                               currentUser:currentUser)
                        
                    lastTimestamp = sampleTimestamp
                }
            
            }
            else {
                print("You are not logged in! Data will not be saved.")
            }
        }
    }
    
    
    
    
}
