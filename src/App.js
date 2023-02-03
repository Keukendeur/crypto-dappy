import React from "react";

import Navbar from "./components/Navbar";
import Providers from "./providers/Providers.comp";
import Wallet from "./components/AccountDetails";
import "./config/config";
import { Routes, Route } from "react-router-dom";
import Home from "./pages/Home.page";
import Dappies from "./pages/Dappies.page";
import Collection from "./pages/Collection.page";
import Packs from "./pages/Packs.page";
import PackDetails from "./pages/PackDetails.page";
import Designer from "./pages/Designer.page";

export default function App() {
  return (
      <Providers>
        <Wallet />
        <Navbar />
        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/dappies" element={<Dappies />} />
          <Route path="/collection" element={<Collection />} />
          <Route path="/packs" element={<Packs />} />
          <Route path="/packs/:packID" element={<PackDetails />} />
          <Route path="/designer" element={<Designer />} />
        </Routes>
      </Providers>
  );
}
