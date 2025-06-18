const express = require('express');

const app = express();

const port = process.env.PORT || 3000;

app.get('/', (req, res) => {
    res.send('Welcome To LENS Corporation');
});


app.listen(port, () => {
    console.log(`running port is ${port}`);
});
