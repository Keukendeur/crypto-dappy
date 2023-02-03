import React, { useState } from 'react'
import { useNavigate } from 'react-router-dom';

import { NAV_ROUTES } from '../config/routes.config'
import "./Navbar.css"

export default function Navbar() {
  const [mobileMenu, setMobileMenu] = useState(false)
  const navigate = useNavigate();

  const NavItem = ({ route }) => (
    <div className="navbar__item">
      <div className="btn" onClick={() => navigate(route.path)}>
        {route.name}
      </div>
    </div>
  )

  return (
    <>
      <div className="navbar">
        {NAV_ROUTES.map(item => <NavItem route={item} key={item.path} />)}
      </div>
      <div className="btn btn-bg navbar__mobile__trigger mobile_only" onClick={() => setMobileMenu(prev => !prev)}>Menu</div>
      {mobileMenu &&
        <div className="navbar__mobile">
          {NAV_ROUTES.map(item => <NavItem route={item} key={item.path} />)}
        </div>
      }

    </>
  )
}
