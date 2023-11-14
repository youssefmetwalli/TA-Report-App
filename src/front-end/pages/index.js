// pages/index.js
import { useState } from 'react';
import LoginForm from '../src/components/loginForm';
import Dashboard from './dasboard';
import 'tailwindcss/tailwind.css'


const Index = () => {
  const [loggedInUser, setLoggedInUser] = useState(null);

  const handleLogin = (username) => {
    // Add authentication logic here
    setLoggedInUser(username);
  };

  return (
    <div>
      {!loggedInUser ? (
        <LoginForm onLogin={handleLogin} />
      ) : (
        <>
          <Dashboard/>
        </>
      )}
    </div>
  );
};

export default Index;
