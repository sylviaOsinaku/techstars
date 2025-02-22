import React, { useState, useEffect, useContext } from 'react';
import styles from './MedicationReminder.module.css';
import PageContext from "../page/PageContext";

// Reusable ReminderCard Component
const ReminderCard = ({ medication, schedule, days, onMarkAsTaken }) => (
  <div className={styles.reminderCard}>
    <h3>{medication}</h3>
    <p><strong>Time:</strong> {schedule}</p>
    <p><strong>Days:</strong> {days.join(", ")}</p>
    <button onClick={() => onMarkAsTaken(medication)}>Mark as Taken</button>
  </div>
);

const MedicationReminder = () => {
  const ctx = useContext(PageContext);
  const { changePage } = ctx;

  const [medications, setMedications] = useState([]);
  const [showPopup, setShowPopup] = useState(false);
  const [selectedMedication, setSelectedMedication] = useState(null);

  useEffect(() => {
    // Simulate fetching data
    const fetchedMedications = [
      {
        userId: 1,
        medication: "Prenatal Vitamins",
        schedule: "08:00 AM",
        days: ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday"]
      },
      {
        userId: 1,
        medication: "Iron Supplements",
        schedule: "02:00 PM",
        days: ["Monday", "Wednesday", "Friday"]
      }
    ];
    setMedications(fetchedMedications);
  }, []);

  const handleMarkAsTaken = (medication) => {
    setSelectedMedication(medication);
    setShowPopup(true);
  };

  const closePopup = () => {
    setShowPopup(false);
  };

  return (
    <div className={styles.container}>
      <h2>Your Medication Reminders</h2>
      <div className={styles.reminders}>
        {medications.length === 0 ? (
          <p>No medication reminders available.</p>
        ) : (
          medications.map((med, index) => (
            <ReminderCard
              key={index}
              medication={med.medication}
              schedule={med.schedule}
              days={med.days}
              onMarkAsTaken={handleMarkAsTaken}
            />
          ))
        )}
      </div>

      {/* Popup */}
      {showPopup && selectedMedication && (
        <div className={styles.popupOverlay}>
          <div className={styles.popupContent}>
            <h3>Good Job, Mama! 🎉</h3>
            <p>You've taken your <strong>{selectedMedication}</strong> for today.</p>
            <p>Remember, every little step counts towards a healthy journey for you and your baby. 💕</p>
            <button className={styles.closeButton} onClick={closePopup}>Close</button>
          </div>
        </div>
      )}

      {/* Back Button */}
      <button onClick={() => changePage("dashboard")} className={styles.backButton}>Back</button>
    </div>
  );
};

export default MedicationReminder;
