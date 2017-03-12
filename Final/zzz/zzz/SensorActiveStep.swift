//
//  SensorActiveTask.swift
//  zzz
//
//  Created by Pierre Azalbert on 10/03/2017.
//  Copyright © 2017 Pierre Azalbert. All rights reserved.
//


import UIKit
import ResearchKit
import RealmSwift
import CoreBluetooth

class SensorStepViewController : ORKActiveStepViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    // define scanning interval times
    let timerPauseInterval:TimeInterval = 10.0
    let timerScanInterval:TimeInterval = 2.0
    
    // UI-related
    var keepScanning = false
    
    // Core Bluetooth properties
    var centralManager:CBCentralManager!
    var sensorTag:CBPeripheral?
    var temperatureCharacteristic:CBCharacteristic?
    var humidityCharacteristic:CBCharacteristic?
    var lightCharacteristic:CBCharacteristic?
    var accCharacteristic:CBCharacteristic?
    
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
    
    // Instantiate custom sensor view
    let sensorView = Bundle.main.loadNibNamed("SensorView", owner: self, options: nil)?.first as? SensorView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Insert custom sensor view inside exisiting view controller
        sensorView?.translatesAutoresizingMaskIntoConstraints = false
        self.customView = sensorView
        self.customView?.superview!.translatesAutoresizingMaskIntoConstraints = false
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[sensorView]-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: ["sensorView": sensorView!]))
        
        // configure initial UI
        sensorView?.statusLabel?.text = "Idle"
        sensorView?.temperatureLabel?.text = "Temperature: N/A"
        sensorView?.humidityLabel?.text = "Humidity: N/A"
        sensorView?.lightLabel?.text = "Light: N/A"
        sensorView?.accXLabel?.text = "Acc X: N/A"
        sensorView?.accYLabel?.text = "Acc Y: N/A"
        sensorView?.accZLabel?.text = "Acc Z: N/A"
        //sensorView?.disconnectButton?.setTitle("Connect SensorTag", for: .normal)
        sensorView?.disconnectButton?.isHidden = true
        
        // Launch CBCentral Manager
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        centralManager.cancelPeripheralConnection(sensorTag!)
        centralManager.stopScan()
        print("Finished Sensor Recording Task - Disconnected SensorTag")
        
    }
    
    @IBAction func handleDisconnectButtonTapped(_ sender: AnyObject) {
        // if we don't have a sensor tag, start scanning for one...
        if sensorTag == nil {
            keepScanning = true
            resumeScan()
            return
        } else {
            disconnect()
            sensorView?.disconnectButton?.setTitle("Connect SensorTag", for: .normal)
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
        sensorView?.disconnectButton?.isEnabled = true
    }
    
    func resumeScan() {
        if keepScanning {
            // Start scanning again...
            print("*** RESUMING SCAN!")
            sensorView?.disconnectButton?.isEnabled = false
            sensorView?.statusLabel?.text = "Searching"
            _ = Timer(timeInterval: timerScanInterval, target: self, selector: #selector(pauseScan), userInfo: nil, repeats: false)
            centralManager.scanForPeripherals(withServices: nil, options: nil)
        } else {
            sensorView?.disconnectButton?.isEnabled = true
        }
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
                sensorView?.disconnectButton?.isEnabled = true
                
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
        
        sensorView?.statusLabel?.text = "Connected"
        sensorView?.disconnectButton?.setTitle("Disconnect SensorTag", for: .normal)
        
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
        sensorView?.statusLabel?.text = "Tap to search"
        sensorView?.temperatureLabel?.text = "Temperature: N/A"
        sensorView?.humidityLabel?.text = "Humidity: N/A"
        sensorView?.lightLabel?.text = "Light: N/A"
        sensorView?.accXLabel?.text = "Acc X: N/A"
        sensorView?.accYLabel?.text = "Acc Y: N/A"
        sensorView?.accZLabel?.text = "Acc Z: N/A"
        sensorView?.disconnectButton?.setTitle("Connect SensorTag", for: .normal)
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
            
            for characteristic in characteristics {
                
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
        
        // 1) extract the data from the characteristic's value property
        // 2) update the UI with the new value
        // 3) prepare the value for writing to database
        
        if let dataBytes = characteristic.value {

            if characteristic.uuid == CBUUID(string: Device.TemperatureDataUUID) {
                
                let temp = getTemperature(dataBytes)
                sensorView?.temperatureLabel?.text = String(format: "Temperature: %.01f%°C", temp)
                sampleTemp = Float(temp)
                
            } else if characteristic.uuid == CBUUID(string: Device.HumidityDataUUID) {
                
                let humi = getHumidity(dataBytes)
                sensorView?.humidityLabel?.text = String(format: "Humidity: %.01f%%", humi)
                sampleHumi = Float(humi)
                
            } else if characteristic.uuid == CBUUID(string: Device.LightDataUUID) {
                
                let light = getLight(dataBytes)
                sensorView?.lightLabel?.text = String(format: "Light: %.01f% LuLux", light)
                sampleLight = Float(light)
                
            } else if characteristic.uuid == CBUUID(string: Device.AccDataUUID) {
                
                let accel = getAccel(dataBytes)
                sensorView?.accXLabel?.text = String(format: "Acc X: %.01f%", accel[0])
                sensorView?.accYLabel?.text = String(format: "Acc Y: %.01f%", accel[1])
                sensorView?.accZLabel?.text = String(format: "Acc Z: %.01f%", accel[2])
                sampleAccX = Float(accel[0])
                sampleAccY = Float(accel[1])
                sampleAccZ = Float(accel[2])
                
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

class SensorActiveStep : ORKActiveStep {

    static func stepViewControllerClass() -> SensorStepViewController.Type {
        return SensorStepViewController.self
    }
    
}
