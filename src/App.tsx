import React from "react";
import "./App.css";
import { PropertiesPanel } from "./PropertiesPanel.gen";
import { HomePanel } from "./HomePanel.gen";

function App() {
  return (
    <div className="App">
      <PropertiesPanel />
      <HomePanel />

    </div>
  );
}

export default App;
