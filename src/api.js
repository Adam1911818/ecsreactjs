// src/api.js
import axios from 'axios';

export const fetchData = async () => {
  try {
    const response = await axios.get('http://localhost:1337/api/posts');
    // Assuming Strapi returns data in response.data.data
    return response.data.data;
  } catch (error) {
    throw new Error('Error fetching data from Strapi');
  }
};
