const express = require('express');
const app = express();
const port = 3000;

app.use(express.json());

app.post('/calculate', (req, res) => {
  const { operation, values } = req.body;

  let result;

  switch (operation) {
    case 'addition':
      result = values.reduce((a, b) => a + b);
      break;
    case 'subtraction':
      result = values.reduce((a, b) => a - b);
      break;
    case 'division':
      result = values.reduce((a, b) => a / b);
      break;
    case 'multiplication':
      result = values.reduce((a, b) => a * b);
      break;
    case 'root':
      result = Math.sqrt(values[0]);
      break;
    case 'percent':
      result = (values[0] * values[1]) / 100;
      break;
    case 'pythagoras':
      result = Math.sqrt(Math.pow(values[0], 2) + Math.pow(values[1], 2));
      break;
    case 'area_of_circle':
      result = Math.PI * Math.pow(values[0], 2);
      break;
    case 'volume_of_cylinder':
      result = Math.PI * Math.pow(values[0], 2) * values[1];
      break;
    default:
      return res.status(400).json({ error: 'Invalid operation' });
  }

  res.json({ result });
  console.log(`${result}`);
});

app.listen(port, () => {
  console.log(`Server running at http://localhost:${port}`);
});
