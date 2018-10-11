//
//  ViewController.swift
//  WebSockets
//
//  Created by Giancarlo Gomez on 9/29/18.
//  Copyright © 2018 Giancarlo Gomez. All rights reserved.
//

import UIKit
import Starscream


final class ViewController: UIViewController{
    var socket: WebSocket!
    var _subscribe = "{\"ns\":\"coldfusion.websocket.channels\",\"type\":\"subscribe\",\"channel\":\"demo\",\"appName\":\"websockets_demo1\"}";

    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var messageBox: UITextField!
    @IBOutlet weak var sendButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        var request = URLRequest(url: URL(string: "ws://localhost:8581/cfusion/cfusion")!)
        request.timeoutInterval = 5
        socket = WebSocket(request: request)
        socket.delegate = self
        socket.connect()
    }

    // MARK: Write Text Action

    @IBAction func write(_ sender: UIButton) {
        if (messageBox.text != ""){
            let message = "{\"ns\":\"coldfusion.websocket.channels\",\"type\":\"publish\",\"channel\":\"demo\",\"appName\":\"websockets_demo1\",\"data\":\"\(messageBox.text ?? "")\"}";
            sendMessage(message: message)
            messageBox.text = ""
        }
    }

}

// MARK: - WebSocketDelegate
extension ViewController : WebSocketDelegate {

    func sendMessage(message: String){
        socket.write(string: message)
    }

    func websocketDidConnect(socket: WebSocketClient) {
        sendMessage(message: _subscribe)
    }

    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
            print("websocket is disconnected: \(e.message)")
        } else if let e = error {
            print("websocket is disconnected: \(e.localizedDescription)")
        } else {
            print("websocket disconnected")
        }
        message.text = "WebSocket Server Disconnected"
    }

    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        // let try and parse received JSON
        guard let data = text.data(using: .utf16),
            let jsonData = try? JSONSerialization.jsonObject(with: data),
            let jsonDict = jsonData as? [String: Any],
            let messageType = jsonDict["type"] as? String else {
                return
        }
        // If we are receiving a data type then lets update the text message
        if messageType == "data",
            let messageData = jsonDict["data"] as? String{
            message.text = messageData
        }
        // when we subscribe
        else if messageType == "response",
            let reqType = jsonDict["reqType"] as? String{
            if (reqType == "subscribe"){
                message.text = "WebSocket Server Connected and Subscribed"
            }
        }
        // log the full response
        print(text);
    }

    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
        print("Received data: \(data.count)")
    }
}

