import { useState, useEffect } from 'react';
import { ethers } from 'ethers';
import { CONTRACTS } from './config';
import { RPI_ABI } from './abi';
import './App.css';

function App() {
  const [account, setAccount] = useState(null);
  const [balance, setBalance] = useState('0');

  const connectPi = async () => {
    try {
      const pi = await window.Pi.authenticate(['payments'], () => {});
      setAccount(pi.user.uid);
      
      const provider = new ethers.BrowserProvider(pi);
      const signer = await provider.getSigner();
      const address = await signer.getAddress();
      
      const rpi = new ethers.Contract(CONTRACTS.RPI, RPI_ABI, signer);
      const bal = await rpi.balanceOf(address);
      setBalance(ethers.formatEther(bal));
    } catch (e) {
      console.error(e);
    }
  };

  const getRPI = async () => {
    const pi = window.Pi;
    const provider = new ethers.BrowserProvider(pi);
    const signer = await provider.getSigner();
    const rpi = new ethers.Contract(CONTRACTS.RPI, RPI_ABI, signer);
    
    const tx = await rpi.mint(await signer.getAddress(), ethers.parseEther('100'));
    await tx.wait();
    alert('100 RPI minted! Refresh balance.');
  };

  return (
    <div className="App">
      <header>
        <h1>🔥 revoluter.pi</h1>
        <p>Pi DeFi Live on Testnet</p>
        <div className="stats">
          RPI Balance: <strong>{balance}</strong>
        </div>
        
        {!account ? (
          <button onClick={connectPi}>Connect Pi</button>
        ) : (
          <div>
            <button onClick={getRPI}>💰 Mint Test RPI</button>
            <button>⚡ DEX Swap</button>
            <button>🌾 Farm</button>
          </div>
        )}
      </header>
    </div>
  );
}

export default App;
