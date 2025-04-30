import { useState } from 'react';
import reactLogo from './assets/react.svg';
import viteLogo from '/vite.svg';
import './App.css';

function App() {
  const [message, setMessage] = useState('Hello from Front End!');

  function hello() {
    const baseUrl = import.meta.env.API_URL || 'https://localhost/api';

    fetch(baseUrl + '/hello').then(async (res) => {
      const data = await res.json();

      setMessage(data.message);
    });
  }

  return (
    <>
      <div>
        <a href="https://vite.dev" target="_blank">
          <img src={viteLogo} className="logo" alt="Vite logo" />
        </a>
        <a href="https://react.dev" target="_blank">
          <img src={reactLogo} className="logo react" alt="React logo" />
        </a>
      </div>
      <div className="card">
        <h1>Docker VSCode</h1>
        <p className="message">{message}</p>
        <button onClick={hello}>Click Me</button>
        <p>
          Edit <code>src/App.tsx</code> and save to test HMR
        </p>

        <p className="read-the-docs">
          <a href="https://github.com/VienDinhCom/docker-vscode-fullstack" target="_blank">
            Learn More About Docker VSCode
          </a>
        </p>
      </div>
    </>
  );
}

export default App;
