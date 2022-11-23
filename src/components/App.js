import { useEffect } from "react";
import config from "../config.json";

import { useDispatch } from "react-redux";
import {
  loadProvider,
  loadNetwork,
  loadAccount,
  loadTokens,
  loadExchange,
} from "../store/interactions";

import Navbar from "./Navbar";
import Markets from "./Markets";

function App() {
  const dispatch = useDispatch();

  const loadBlockchainData = async () => {
    // Connect ethers to the blockchain
    const provider = loadProvider(dispatch);
    const chainId = await loadNetwork(provider, dispatch);

    // Reload page when network changed
    window.ethereum.on('chainChanged', () => {
      window.location.reload()
    })


    // Function from metamask
    window.ethereum.on('accountsChanged', () => {
      loadAccount(provider, dispatch)
    })

    // Token Smart Contract
    const ntst = config[chainId].NTST;
    const weth = config[chainId].wETH;
    await loadTokens(provider, [ntst.address, weth.address], dispatch);

    // Exchange
    const exchange = config[chainId].exchange;
    await loadExchange(provider, exchange.address, dispatch);
  };

  useEffect(() => {
    loadBlockchainData();
  });

  return (
    <div>
      {/* Navbar */}
      <Navbar></Navbar>
      <main className="exchange grid">
        <section className="exchange__section--left grid">
          <Markets></Markets>
          {/* Markets */}
          {/* Balance */}
          {/* Order */}
        </section>
        <section className="exchange__section--right grid">
          {/* PriceChart */}
          {/* Transaction  */}
          {/* Trades  */}
          {/* OrderBook  */}
        </section>
      </main>
    </div>
  );
}

export default App;
