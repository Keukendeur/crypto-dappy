import React from 'react'
import { Routes ,Route } from 'react-router-dom';

import NotFound from '../pages/NotFound.page'

export default function AppRoutes({ routes }) {
  const renderRoutes = routes.map((route) => {
    const { path, component } = route;
    return <Route path={path} component={component} key={path} exact />
  })

  return (
    <Routes>
      {renderRoutes}
      <Route component={NotFound} />
    </Routes>
  )
}
