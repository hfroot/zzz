//
//  SensorViewController.swift
//  ZZZ
//
//  Created by Simon Ng on 2/2/15.
//  Copyright (c) 2015 AppCoda. All rights reserved.
//

import UIKit
import CoreBluetooth
import RealmSwift

class SensorViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    @IBOutlet weak var menuButton:UIBarButtonItem!
    
    @IBOutlet weak var controlContainerView: UIView!
    @IBOutlet weak var statusLabel: UILabel?
    @IBOutlet weak var temperatureLabel: UILabel?
    @IBOutlet weak var humidityLabel: UILabel?
    @IBOutlet weak var disconnectButton: UIButton?
    
    // define scanning interval times
    let timerPauseInterval:TimeInterval = 10.0
    let timerScanInterval:TimeInterval = 2.0
    
    // counter to save 1 out of 3 samples
    var sampleCounter = 0
    let countMax = 3
    
    // UI-related
    var keepScanning = false
    //var isScanning = false
    
    // Core Bluetooth properties
    var centralManager:CBCentralManager!
    var sensorTag:CBPeripheral?
    var temperatureCharacteristic:CBCharacteristic?
    var humidityCharacteristic:CBCharacteristic?
    
    // This could be simplified to "SensorTag" and check if it's a substring.
    // (Probably a good idea to do that if you're using a different model of
    // the SensorTag, or if you don't know what model it is...)
    let sensorTagName = "CC2650 SensorTag"
    
    
    // Realm variables initialisation
    let currentUser = User()
    var sensorData = List<sensorDataObject>()
    var sampleTimestamp:String?
    var sampleTemp:Float?
    var sampleHumi:Float?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
//        try! realm.write {
//            realm.deleteAll()
//            print("DELETED ALL OBJECTS IN REALM");
//        }
        
        currentUser.name = "Pierre"
        
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
        statusLabel?.text = "Searching"
        temperatureLabel?.text = "Temperature: N/A"
        humidityLabel?.text = "Humidity: N/A"
        disconnectButton?.setTitle("Connect SensorTag", for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Handling User Interaction
    
    @IBAction func handleDisconnectButtonTapped(_ sender: AnyObject) {
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
        //print("*** HUMIDITY: \(calculatedHumidity)");
        
        humidityLabel?.text = String(format: "Humidity: %.01f%%", calculatedHumidity)
        sampleHumi = Float(calculatedHumidity)
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
                // print("Discovered service \(service)")
                // If we found either the temperature or the humidity service, discover the characteristics for those services.
                if (service.uuid == CBUUID(string: Device.TemperatureServiceUUID)) ||
                    (service.uuid == CBUUID(string: Device.HumidityServiceUUID)) {
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
//            let periodValue:UInt8 = 255
//            let periodBytes = Data(bytes: [periodValue])
            
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
                
//                // Temperature Period Characteristic
//                if characteristic.uuid == CBUUID(string: Device.TemperaturePeriod) {
//                    // Set Temperature Period
//                    sensorTag?.writeValue(periodBytes, for: characteristic, type: .withResponse)
//                }
                
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
                
//                // Humidity Period Characteristic
//                if characteristic.uuid == CBUUID(string: Device.HumidityPeriod) {
//                    // Set Humidity Period
//                    sensorTag?.writeValue(periodBytes, for: characteristic, type: .withResponse)
//                }
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
            if characteristic.uuid == CBUUID(string: Device.TemperatureDataUUID) {
                displayTemperature(dataBytes)
            } else if characteristic.uuid == CBUUID(string: Device.HumidityDataUUID) {
                displayHumidity(dataBytes)
            }
            
            // Save timestamp just after reading data, then save sensorDataObject in Realm database
            
            if (sampleCounter == countMax){
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                sampleTimestamp = formatter.string(from: Date())
                
                saveSample()
                sampleCounter = 0
            }
            else {sampleCounter += 1}
            
            //DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2.0) {}
        }
    }
    
    
    // MARK: - TI Sensor Tag Utility Methods
    
    func calculateRelativeHumidity(_ rawH:UInt16) -> Double {
        // clear status bits [1..0]
        let clearedH = rawH & ~0x003
        
        //-- calculate relative humidity [%RH] --
        // RH= -6 + 125 * SRH/2^16
        let relativeHumidity:Double = -6.0 + 125.0/65536 * Double(clearedH)
        return relativeHumidity
    }
    
    // MARK: - Realm Functions
    
    func saveSample(){
        if (sampleTemp != nil && sampleHumi != nil && sensorTag != nil)  {
            try! realm.write {
                let newData = sensorDataObject(value: ["sensorID": sensorTag!.identifier.uuidString, "sensorTemp": sampleTemp!, "sensorHumi": sampleHumi!, "sensorTimestamp": sampleTimestamp!])
                currentUser.sensorData.append(newData)
                realm.add(currentUser, update: true)
                print("Added object to database: \(newData)")
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
