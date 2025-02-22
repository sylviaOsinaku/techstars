import React, { useState, useContext } from 'react';
import './EmergencyFund.css';
import PageContext from "../page/PageContext";

function EmergencyFund() {
  const ctx = useContext(PageContext);
  const { changePage } = ctx;

  // Predefined data for Kemi
  const userData = {
    name: 'Kemi',
    bankCardLinked: true,
    totalSavings: 45000, // Total saved across all plans
    targetSavings: 100000, // Total target savings
    savingsPlans: [
      { name: 'Emergency Fund', amountSaved: 45000, target: 100000 },
      { name: 'Surgery Fund', amountSaved: 15000, target: 50000 },
      { name: 'Baby Fund', amountSaved: 10000, target: 30000 },
    ],
  };

  const [isCardLinked, setIsCardLinked] = useState(userData.bankCardLinked);
  const [totalSavings, setTotalSavings] = useState(userData.totalSavings);
  const [savingsPlans, setSavingsPlans] = useState(userData.savingsPlans);

  // Function to add cash to a savings plan
  const addCashToPlan = (planIndex, amount) => {
    const updatedPlans = [...savingsPlans];
    updatedPlans[planIndex].amountSaved += amount;
    setSavingsPlans(updatedPlans);
    setTotalSavings(prev => prev + amount);
  };

  // Function to simulate milestone progress
  const simulateSaving = () => {
    setInterval(() => {
      const updatedPlans = savingsPlans.map(plan => ({
        ...plan,
        amountSaved: Math.min(plan.amountSaved + 500, plan.target),
      }));
      setSavingsPlans(updatedPlans);
      setTotalSavings(updatedPlans.reduce((acc, plan) => acc + plan.amountSaved, 0));
    }, 30000); // Simulate adding 500 every 30 seconds
  };

  // Function to handle withdrawal
  const handleWithdrawal = (planIndex) => {
    alert(`You have successfully withdrawn ₦${savingsPlans[planIndex].amountSaved} from your ${savingsPlans[planIndex].name} plan.`);
    setSavingsPlans(prevPlans =>
      prevPlans.map((plan, index) => 
        index === planIndex ? { ...plan, amountSaved: 0 } : plan
      )
    );
  };

  return (
    <div className="emergency-fund-container">
      <h2 className="emergency-fund-heading">Total Savings Dashboard</h2>
      
      <div className="welcome-message">
        <h3>Welcome, {userData.name}!</h3>
        <p>Your trusted savings companion for all your goals!</p>
      </div>

      <div className="card-link-section">
        {!isCardLinked ? (
          <button className="link-card-button" onClick={() => setIsCardLinked(true)}>Link Bank Card</button>
        ) : (
          <div className="card-linked-message">
            <p>Your bank card is successfully linked!</p>
          </div>
        )}
      </div>

      <div className="total-savings">
        <h3>Total Savings</h3>
        <p>₦{totalSavings} saved of ₦{userData.targetSavings}</p>
      </div>

      <div className="savings-plans">
        <h3>Savings Plans</h3>
        {savingsPlans.map((plan, index) => (
          <div key={index} className="savings-plan">
            <h4>{plan.name}</h4>
            <div className="progress-bar">
              <div className="progress-bar-filled" style={{ width: `${(plan.amountSaved / plan.target) * 100}%` }}></div>
            </div>
            <p>Saved: ₦{plan.amountSaved} | Target: ₦{plan.target}</p>
            <button onClick={() => addCashToPlan(index, 5000)}>Add ₦5000</button>
            <button onClick={() => handleWithdrawal(index)}>Withdraw Funds</button>
          </div>
        ))}
      </div>

      <div className="portfolio">
        <h3>Your Portfolio</h3>
        <button onClick={() => changePage("portfolio")}>View Portfolio</button>
      </div>
      
      {/* Start auto-saving once the card is linked */}
      {isCardLinked && simulateSaving()}

      <button type="submit" onClick={() => changePage("dashboard")}>Next ➜</button>
    </div>
  );
}

export default EmergencyFund;
