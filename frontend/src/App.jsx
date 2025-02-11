import React from 'react'
import { Provider } from 'react-redux'
import { BrowserRouter as Router, Routes, Route } from 'react-router-dom'
import { ThemeProvider, CssBaseline } from '@mui/material'
import { store } from './store'
import { theme } from './theme'
import Layout from './components/Layout'
import Home from './pages/Home'
import Documents from './pages/Documents'

function App() {
    return (
        <Provider store={store}>
            <ThemeProvider theme={theme}>
                <CssBaseline />
                <Router>
                    <Layout>
                        <Routes>
                            <Route path="/" element={<Home />} />
                            <Route path="/documents" element={<Documents />} />
                        </Routes>
                    </Layout>
                </Router>
            </ThemeProvider>
        </Provider>
    )
}

export default App 