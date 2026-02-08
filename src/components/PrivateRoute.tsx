import { ReactNode } from 'react';
import { useAuth } from "@/contexts/AuthContext";
import { Navigate } from "react-router-dom";

interface PrivateRouteProps {
  children: ReactNode;
}

const PrivateRoute = ({ children }: PrivateRouteProps) => {
  const { user } = useAuth();
  const isLoggedIn = user?.authenticated;

  // TEMPORARY: Bypass authentication for testing
  // TODO: Remove this and implement proper authentication
  const bypassAuth = import.meta.env.VITE_BYPASS_AUTH === 'true';

  return (isLoggedIn || bypassAuth) ? children : <Navigate to="/error" />;
};

export default PrivateRoute;