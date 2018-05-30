import React, { Component } from 'react';
import Elm from 'react-elm-components';
import logo from './logo.svg';
import { Main } from './main';
import './App.css';

class App extends Component {
  render() {
    return (
      <div className="App">
        <header className="App-header">
          <img src={logo} className="App-logo" alt="logo" />
          <h1 className="App-title">Welcome to React</h1>
        </header>
        <p className="App-intro">
          To get started, edit <code>src/App.js</code> and save to reload.
        </p>
        <Elm src={Main} ></Elm>
      </div>
    );
  }
}

export default App;
