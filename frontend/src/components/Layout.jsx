import React, { useState } from 'react'
import { Link, useLocation } from 'react-router-dom'
import { Menu, X } from 'lucide-react'

function Layout({ children }) {
    const [isMenuOpen, setIsMenuOpen] = useState(false)
    const location = useLocation()

    const isActive = (path) => location.pathname === path

    const navLinks = [
        { path: '/', label: 'Home' },
        { path: '/documents', label: 'Documents' },
        { path: '/pricing', label: 'Pricing' },
        { path: '/about', label: 'About' }
    ]

    return (
        <div className="min-h-screen flex flex-col bg-gray-50">
            <header className="bg-white shadow-sm fixed w-full z-50">
                <nav className="container mx-auto px-4 py-4">
                    <div className="flex items-center justify-between">
                        <Link to="/" className="flex items-center space-x-2">
                            <span className="text-2xl font-bold bg-gradient-to-r from-primary-main to-primary-light bg-clip-text text-transparent">
                                iDocProc
                            </span>
                        </Link>

                        {/* Desktop Navigation */}
                        <div className="hidden md:flex items-center space-x-8">
                            {navLinks.map(({ path, label }) => (
                                <Link
                                    key={path}
                                    to={path}
                                    className={`${isActive(path)
                                            ? 'text-primary-main font-semibold'
                                            : 'text-gray-600 hover:text-primary-main'
                                        } transition-colors`}
                                >
                                    {label}
                                </Link>
                            ))}
                            <button className="btn-primary">Get Started</button>
                        </div>

                        {/* Mobile Menu Button */}
                        <button
                            className="md:hidden"
                            onClick={() => setIsMenuOpen(!isMenuOpen)}
                        >
                            {isMenuOpen ? (
                                <X className="h-6 w-6 text-gray-600" />
                            ) : (
                                <Menu className="h-6 w-6 text-gray-600" />
                            )}
                        </button>
                    </div>

                    {/* Mobile Navigation */}
                    {isMenuOpen && (
                        <div className="md:hidden mt-4 pb-4">
                            {navLinks.map(({ path, label }) => (
                                <Link
                                    key={path}
                                    to={path}
                                    className={`block py-2 ${isActive(path)
                                            ? 'text-primary-main font-semibold'
                                            : 'text-gray-600'
                                        }`}
                                    onClick={() => setIsMenuOpen(false)}
                                >
                                    {label}
                                </Link>
                            ))}
                            <button className="btn-primary w-full mt-4">
                                Get Started
                            </button>
                        </div>
                    )}
                </nav>
            </header>

            <main className="flex-grow pt-20">
                {children}
            </main>

            <footer className="bg-gray-900 text-white">
                <div className="container mx-auto px-4 py-12">
                    <div className="grid grid-cols-1 md:grid-cols-4 gap-8">
                        <div>
                            <h3 className="text-xl font-bold mb-4">iDocProc</h3>
                            <p className="text-gray-400">
                                Intelligent Document Processing made simple and efficient.
                            </p>
                        </div>
                        <div>
                            <h4 className="text-lg font-semibold mb-4">Product</h4>
                            <ul className="space-y-2 text-gray-400">
                                <li><Link to="/features" className="hover:text-white">Features</Link></li>
                                <li><Link to="/pricing" className="hover:text-white">Pricing</Link></li>
                                <li><Link to="/documentation" className="hover:text-white">Documentation</Link></li>
                            </ul>
                        </div>
                        <div>
                            <h4 className="text-lg font-semibold mb-4">Company</h4>
                            <ul className="space-y-2 text-gray-400">
                                <li><Link to="/about" className="hover:text-white">About</Link></li>
                                <li><Link to="/contact" className="hover:text-white">Contact</Link></li>
                                <li><Link to="/careers" className="hover:text-white">Careers</Link></li>
                            </ul>
                        </div>
                        <div>
                            <h4 className="text-lg font-semibold mb-4">Legal</h4>
                            <ul className="space-y-2 text-gray-400">
                                <li><Link to="/privacy" className="hover:text-white">Privacy Policy</Link></li>
                                <li><Link to="/terms" className="hover:text-white">Terms of Service</Link></li>
                            </ul>
                        </div>
                    </div>
                    <div className="border-t border-gray-800 mt-8 pt-8 text-center text-gray-400">
                        © 2024 iDocProc. All rights reserved.
                    </div>
                </div>
            </footer>
        </div>
    )
}

export default Layout 