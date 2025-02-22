import React, { useState } from 'react';
import './PortfolioData.css'
function Portfolio() {
  const [portfolioData, setPortfolioData] = useState({
    totalSavings: 250000,
    investments: 150000,
    emergencyFund: 50000,
    otherFunds: 50000,
  });

  // Calculate the percentage of each category for the graph
  const totalAmount = Object.values(portfolioData).reduce((acc, val) => acc + val, 0);

  return (
    <div className="portfolio-container">
      <h2>Your Portfolio</h2>
      <p>Track your savings, investments, and emergency fund progress here!</p>

      <div className="portfolio-details">
        <p><strong>Total Savings:</strong> ₦{portfolioData.totalSavings}</p>
        <p><strong>Investments:</strong> ₦{portfolioData.investments}</p>
        <p><strong>Emergency Fund:</strong> ₦{portfolioData.emergencyFund}</p>
        <p><strong>Other Funds:</strong> ₦{portfolioData.otherFunds}</p>
      </div>

      {/* Simple Bar Graph */}
      <div className="portfolio-graph">
        <h3>Portfolio Breakdown</h3>
        <div className="bar-graph">
          {Object.entries(portfolioData).map(([category, amount], index) => {
            const percentage = (amount / totalAmount) * 100;
            return (
              <div key={index} className="bar" style={{ width: `${percentage}%` }}>
                <div className="bar-label">{category}</div>
                <div className="bar-value">₦{amount}</div>
              </div>
            );
          })}
        </div>
      </div>
    </div>
  );
}

export default Portfolio;
