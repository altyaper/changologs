document.addEventListener('DOMContentLoaded', function() {
  const switchElement = document.getElementById('sentiment-switch');
  const logCards = document.querySelectorAll('.log-card');

  switchElement.addEventListener('change', function() {
    if (switchElement.checked) {
      // Show sentiment colors
      logCards.forEach(card => {
        const sentiment = card.getAttribute('data-sentiment');
        if (sentiment === 'positive') {
          card.style.backgroundColor = '#F0FFF0';  // Light green
        } else if (sentiment === 'negative') {
          card.style.backgroundColor = '#FFF0F0';  // Light red
        } else {
          card.style.backgroundColor = '#F5F5F5';  // Light gray for neutral
        }
      });
    } else {
      // Show default color
      logCards.forEach(card => {
        card.style.backgroundColor = '';  // Reset to default color
      });
    }
  });
});