import { Component, OnInit } from '@angular/core';

@Component({
  selector: 'app-servers',
  templateUrl: './servers.component.html',
  styleUrls: ['./servers.component.css']
})
export class ServersComponent implements OnInit {
  allowNewServer = false;
  serverCreationStatus = 'No server was created!';
  serverName = 'Test';
  serverCreated = false;
  servers = [
    'Test1',
    'Test2'
  ];
  isDetailsBtnClicked = false;
  detailsBtnClickLogs = [];

  constructor() {
    setTimeout(() => {
      this.allowNewServer = true;
    }, 2000);
  }

  ngOnInit() {
  }

  onCreateServer () {
    this.serverCreationStatus = 'Server was created! Name is ' + this.serverName;
    this.serverCreated = true;
    this.servers.push(this.serverName);
  }

  onUpdateServerName (event: any) {
    this.serverName = (<HTMLInputElement>event.target).value;
  }

  toggleDetailsBtn () {
    this.isDetailsBtnClicked = !this.isDetailsBtnClicked;

    this.detailsBtnClickLogs.push(new Date());
  }
}
