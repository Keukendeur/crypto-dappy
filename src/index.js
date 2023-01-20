import React from "react";
import {createRoot} from "react-dom/client";

import "./config/config";
import "./index.css";
import "./components/Atoms.css";
import App from "./App";

const container = document.getElementById('root');
const root = createRoot(container);
root.render(<App tab='home' />);