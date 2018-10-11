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
                'websockets_demo1',
                'demo',
                'https://demo.fusedev.com/live-demos/demo-01/runme.cfm',
                this,
                this,
                true,
                null,
                'demo.fusedev.com',
                true
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
