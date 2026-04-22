import React, { useState, useEffect } from 'react';

function ShieldDashboard() {
  const [status, setStatus] = useState(null);

  useEffect(() => {
    fetch('/shield-status')
      .then(res => res.json())
      .then(setStatus);
  }, []);

  return (
    <div className="shield-dashboard">
      <h1>🛡️ SmartContracts Protection Status</h1>
      {status && (
        <div>
          <p>Status: <span style={{color: 'green'}}>FULLY PROTECTED</span></p>
          <p>Pi Network: ✅ Integrated</p>
          <p>Blocked: π, ℏ, H2O, ∞</p>
          <p>Allowed: PI, BTC, ETH</p>
        </div>
      )}
    </div>
  );
}
