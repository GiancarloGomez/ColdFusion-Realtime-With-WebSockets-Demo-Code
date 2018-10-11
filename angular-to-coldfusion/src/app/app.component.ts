import { Component } from '@angular/core';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.css']
})
export class AppComponent {
    title = 'WebSockets'
    message = '...'
    cfwebsocket:any;
    user_message:string = ''

    constructor() {
        if (typeof window['cfwebsocket'] === 'function'){
            this.cfwebsocket = new window['cfwebsocket'](
                'websockets_demo1', // appName
                'demo', // channel
                'http://localhost:50320/live-demos/demo-01/runme/', // appStartPath
                this, // onMessage
                this, // onSubscribe
                false, // isProxy
                8581, // wsPort
                'localhost', // server
                false // secure
            )
        }
    }

    parseMessage(msg){
        if (msg.data)
            this.message = msg.data;
    }

    subscribed(){
        this.message = 'We are subscribed!'
    }

    publish(){
        if (this.cfwebsocket.publish(this.user_message.trim()))
            this.user_message = '';
    }
}
