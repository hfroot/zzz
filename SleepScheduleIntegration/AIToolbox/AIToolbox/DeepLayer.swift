//
//  DeepLayer.swift
//  AIToolbox
//
//  Created by Kevin Coble on 6/25/16.
//  Copyright © 2016 Kevin Coble. All rights reserved.
//

import Foundation
import Accelerate

///  Class for a single layer of a deep network
///  A deep layer contains multiple data channels - all of which can be computed synchronously
final public class DeepLayer : DeepNetworkInputSource, DeepNetworkOutputDestination, MLPersistence
{
    var channels : [DeepChannel] = []
    
    public init() {
    }
    
    public init?(fromDictionary: [String: AnyObject])
    {
        //  Get the array of channels
        let channelArray = fromDictionary["channels"] as? NSArray
        if (channelArray == nil)  { return nil }
        for item in channelArray! {
            let element = item as? [String: AnyObject]
            if (element == nil)  { return nil }
            let channel = DeepChannel(fromDictionary: element!)
            if (channel == nil)  { return nil }
            channels.append(channel!)
        }
    }
    
    ///  Function to get the number of defined channels
    public var numChannels: Int {
        get { return channels.count }
    }
    
    ///  Function to get the channel for the specified index
    public func getChannel(atIndex: Int) -> DeepChannel
    {
        return channels[atIndex]
    }
    
    ///  Function to add a channel to the layer
    public func addChannel(_ newChannel: DeepChannel)
    {
        channels.append(newChannel)
    }
    
    ///  Functions to remove a channel from the layer
    public func removeChannel(_ channelIndex: Int)
    {
        if (channelIndex >= 0 && channelIndex < channels.count) {
            channels.remove(at: channelIndex)
        }
    }
    public func removeChannel(_ channelID: String)
    {
        if let index = getChannelIndex(channelID) {
            removeChannel(index)
        }
    }
    
    ///  Function to get the size of an channel output (as input for next layer
    public func getInputDataSize(_ inputID : String) -> DeepChannelSize?
    {
        //  Get the index
        if let index = getChannelIndex(inputID) {
            return channels[index].resultSize
        }
        return nil
    }
    
    ///  Function to add a network operator to a channel in the layer
    public func addNetworkOperator(_ channelIndex: Int, newOperator: DeepNetworkOperator)
    {
        if (channelIndex >= 0 && channelIndex < channels.count) {
            channels[channelIndex].addNetworkOperator(newOperator)
        }
    }
    
    ///  Function to get a network operator at the specified index
    public func getNetworkOperator(_ channelIndex: Int, operatorIndex: Int) ->DeepNetworkOperator?
    {
        if (channelIndex >= 0 && channelIndex < channels.count) {
            return channels[channelIndex].getNetworkOperator(operatorIndex)
        }
        
        return nil
    }
    
    ///  Function to get a replace operator at the specified index
    public func replaceNetworkOperator(_ channelIndex: Int, operatorIndex: Int, newOperator: DeepNetworkOperator)
    {
        if (channelIndex >= 0 && channelIndex < channels.count) {
            return channels[channelIndex].replaceNetworkOperator(operatorIndex, newOperator: newOperator)
        }
    }

    ///  Function to remove a network operator from a channel in the layer
    public func removeNetworkOperator(_ channelIndex: Int, operatorIndex: Int)
    {
        if (channelIndex >= 0 && channelIndex < channels.count) {
            channels[channelIndex].removeNetworkOperator(operatorIndex)
        }
    }
    
    ///  Function to find a channel index from an ID
    public func getChannelIndex(_ channelID: String) -> Int?
    {
        for index in 0..<channels.count {
            if (channels[index].idString == channelID) { return index }
        }
        return nil
    }
    
    func validateAgainstPreviousLayer(_ prevLayer: DeepNetworkInputSource, layerIndex: Int) ->[String]
    {
        var errors : [String] = []
        
        //  Check each channel
        for channel in channels {
            //  Get the channel from the previous layer that has our source
            if let inputSize = prevLayer.getInputDataSize(channel.sourceChannelID) {
                //  We have the input, update the output size of the channel
                channel.updateOutputSize(inputSize)
            }
            else {
                //  Source channel not found
                errors.append("Layer \(layerIndex), channel \(channel.idString) uses input \(channel.sourceChannelID), which does not exist")
            }
            
        }
        
        return errors
    }
    
    func getResultRange() ->(minimum: Float, maximum: Float)
    {
        if let lastChannel = channels.last {
            return lastChannel.getResultRange()
        }
        return (minimum: 0.0, maximum: 1.0)
    }
    
    public func initializeParameters()
    {
        for channel in channels {
            channel.initializeParameters()
        }
    }
    
    //  Method to feed values forward through the layer
    func feedForward(_ prevLayer: DeepNetworkInputSource)
    {
        //  Get a concurrent GCD queue to run this all in
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        //  Get a GCD group so we can know when all channels are done
        let group = DispatchGroup();
        
        //  Process each channel concurrently
        for channel in channels {
            queue.async(group: group) {
                channel.feedForward(prevLayer)
            }
        }
        
        //  Wait for the channels to finish calculating before the next layer is allowed to start
        group.wait()
    }
    
    //  Function to clear weight-change accumulations for the start of a batch
    public func startBatch()
    {
        //  Get a concurrent GCD queue to run this all in
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        //  Get a GCD group so we can know when all channels are done
        let group = DispatchGroup();
        
        //  Process each channel concurrently
        for channel in channels {
            queue.async(group: group) {
                channel.startBatch()
            }
        }
        
        //  Wait for the channels to finish calculating before the next layer is allowed to start
        group.wait()
    }
    
    func backPropagate(_ gradientSource: DeepNetworkOutputDestination)
    {
        //  Get a concurrent GCD queue to run this all in
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        //  Get a GCD group so we can know when all channels are done
        let group = DispatchGroup();
        
        //  Process each channel concurrently
        for channel in channels {
            queue.async(group: group) {
                channel.backPropagate(gradientSource)
            }
        }
        
        //  Wait for the channels to finish calculating before the previous layer is allowed to start
        group.wait()
    }
    
    public func updateWeights(_ trainingRate : Float, weightDecay: Float)
    {
        //  Get a concurrent GCD queue to run this all in
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.default)
        
        //  Get a GCD group so we can know when all channels are done
        let group = DispatchGroup();
        
        //  Process each channel concurrently
        for channel in channels {
            queue.async(group: group) {
                channel.updateWeights(trainingRate, weightDecay: weightDecay)
            }
        }
        
        //  Wait for the channels to finish calculating before the previous layer is allowed to start
        group.wait()
    }
    
    public func gradientCheck(ε: Float, Δ: Float, network: DeepNetwork) -> Bool
    {
        //  Have each channel check - we can't do this concurrently, as the result values for the whole network must be used for each check
        var result = true
        for channel in 0..<channels.count {
            if (!channels[channel].gradientCheck(ε: ε, Δ: Δ, network: network)) { result = false }
        }
        return result
    }
    
    public func getValuesForID(_ inputID : String) -> [Float]
    {
        //  Get the index
        if let index = getChannelIndex(inputID) {
            return channels[index].getFinalResult()
        }
        return []
    }
    
    public func getAllValues() -> [Float]
    {
        var result : [Float] = []
        for channel in channels {
            result += channel.getFinalResult()
        }
        return result
    }
    
    func getGradientForSource(_ sourceID : String) -> [Float]
    {
        //  Sum the gradient from each channel that uses the source
        var result : [Float] = []
        for channel in channels {
            if (channel.sourceChannelID == sourceID) {
                let channelGradient = channel.getGradient()
                if (result.count == 0) {
                    result = channelGradient
                }
                else {
                    vDSP_vadd(result, 1, channelGradient, 1, &result, 1, vDSP_Length(result.count))
                }
            }
        }
        return result
    }

    
    public func getResultOfItem(_ channelIndex: Int, operatorIndex: Int) ->(values : [Float], size: DeepChannelSize)?
    {
        if (channelIndex >= 0 && channelIndex < channels.count) {
            return channels[channelIndex].getResultOfItem(operatorIndex)
        }
        return nil
    }
    
    public func getPersistenceDictionary() -> [String: AnyObject]
    {
        var resultDictionary : [String: AnyObject] = [:]
        
        //  Set the array of channels
        var channelArray : [[String: AnyObject]] = []
        for channel in channels {
            channelArray.append(channel.getPersistenceDictionary())
        }
        resultDictionary["channels"] = channelArray as AnyObject?
        
        return resultDictionary
    }
}
