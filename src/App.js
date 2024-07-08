// src/App.js
import React, { useEffect, useState } from 'react';
import './App.css';
import { fetchData } from './api';

function App() {
  const [data, setData] = useState([]);
  const [error, setError] = useState(null);

  useEffect(() => {
    const getData = async () => {
      try {
        const articles = await fetchData();
        setData(articles);
      } catch (error) {
        console.error('Error fetching data', error);
        setError('Error fetching data. Please try again later.');
      }
    };
    getData();
  }, []);

  return (
    <div className="App">
      <header className="App-header">
        <h1>strapi and reactjs</h1>
        {error ? (
          <p>{error}</p>
        ) : (
          <ul>
            {data.map((item) => (
              <li key={item.id}>
                <h2>{item.attributes.title}</h2>
                <p>{item.attributes.content}</p>
              </li>
            ))}
          </ul>
        )}
      </header>
    </div>
  );
}

export default App;
