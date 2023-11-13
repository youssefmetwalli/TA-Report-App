// pages/index.js
import { useState } from 'react';
import LoginForm from '../src/components/loginForm';

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
        <a href="/Dashboard">Go to Dashboard</a>
      )}
    </div>
  );
};

export default Index;
