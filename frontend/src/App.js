import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import './App.css';

const CONTRACTS = {
  RPI: '0xYourRPIAddress',
  DEX: '0xYourDEXAddress',
  FARM: '0xYourFarmAddress'
};

function App() {
  const [account, setAccount] = useState(null);
  const [rpiBalance, setRpiBalance] = useState('0');

  useEffect(() => {
    if (window.pi) connectPi();
  }, []);

  const connectPi = async () => {
    try {
      const pi = await window.Pi.authenticate(['payments', 'profile'], onIncompletePaymentFound);
      setAccount(pi.user.uid);
      updateBalance(pi);
    } catch (err) {
      console.error('Pi connect failed:', err);
    }
  };

  const updateBalance = async (pi) => {
    const provider = new ethers.BrowserProvider(pi);
    const signer = await provider.getSigner();
    const rpiContract = new ethers.Contract(CONTRACTS.RPI, ['function balanceOf(address) view returns (uint256)'], signer);
    const balance = await rpiContract.balanceOf(await signer.getAddress());
    setRpiBalance(ethers.formatEther(balance));
  };

  const swapTokens = async () => {
    const pi = window.pi;
    const provider = new ethers.BrowserProvider(pi);
    const signer = await provider.getSigner();
    const dex = new ethers.Contract(CONTRACTS.DEX, ['function swap(address,address,uint256)'], signer);
    
    const tx = await dex.swap('0xRPI', '0xWETH', ethers.parseEther('1'));
    await tx.wait();
    alert('Swap success! 🎉');
  };

  return (
    <div className="App">
      <header className="App-header">
        <h1>🔥 revoluter.pi</h1>
        <p>Pi Network DeFi Revolution</p>
        
        {!account ? (
          <button className="connect-btn" onClick={connectPi}>
            Connect Pi Wallet
          </button>
        ) : (
          <div className="dashboard">
            <p>👋 Welcome! RPI Balance: {rpiBalance}</p>
            <div className="actions">
              <button onClick={swapTokens}>⚡ Swap RPI</button>
              <button>Farm →</button>
              <button>Stake LP</button>
            </div>
          </div>
        )}
      </header>
    </div>
  );
}

export default App;
