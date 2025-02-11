import React from 'react'
import { Link } from 'react-router-dom'
import { FileText, Zap, Shield, BarChart } from 'lucide-react'

function Home() {
    const features = [
        {
            icon: <FileText className="h-8 w-8 text-primary-main" />,
            title: 'Smart Document Processing',
            description: 'Advanced AI-powered document analysis and data extraction.'
        },
        {
            icon: <Zap className="h-8 w-8 text-primary-main" />,
            title: 'Lightning Fast',
            description: 'Process thousands of documents in minutes, not hours.'
        },
        {
            icon: <Shield className="h-8 w-8 text-primary-main" />,
            title: 'Secure by Design',
            description: 'Enterprise-grade security with end-to-end encryption.'
        },
        {
            icon: <BarChart className="h-8 w-8 text-primary-main" />,
            title: 'Advanced Analytics',
            description: 'Gain insights with comprehensive reporting and analytics.'
        }
    ]

    return (
        <>
            {/* Hero Section */}
            <section className="bg-gradient-to-r from-primary-dark via-primary-main to-primary-light text-white py-20">
                <div className="container mx-auto px-4">
                    <div className="max-w-3xl mx-auto text-center">
                        <h1 className="text-5xl font-bold mb-6">
                            Transform Your Document Workflow
                        </h1>
                        <p className="text-xl mb-8 text-gray-100">
                            Automate document processing with AI-powered intelligence.
                            Extract, analyze, and manage your documents effortlessly.
                        </p>
                        <div className="flex flex-col sm:flex-row justify-center gap-4">
                            <Link to="/documents" className="btn-secondary">
                                Get Started Free
                            </Link>
                            <Link to="/demo" className="btn-outline-white">
                                Request Demo
                            </Link>
                        </div>
                    </div>
                </div>
            </section>

            {/* Features Section */}
            <section className="py-20 bg-white">
                <div className="container mx-auto px-4">
                    <h2 className="text-3xl font-bold text-center mb-12">
                        Why Choose iDocProc?
                    </h2>
                    <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-8">
                        {features.map((feature, index) => (
                            <div key={index} className="p-6 bg-white rounded-xl shadow-sm hover:shadow-md transition-shadow">
                                <div className="mb-4">{feature.icon}</div>
                                <h3 className="text-xl font-semibold mb-2">
                                    {feature.title}
                                </h3>
                                <p className="text-gray-600">
                                    {feature.description}
                                </p>
                            </div>
                        ))}
                    </div>
                </div>
            </section>

            {/* CTA Section */}
            <section className="bg-gray-50 py-20">
                <div className="container mx-auto px-4 text-center">
                    <h2 className="text-3xl font-bold mb-4">
                        Ready to Get Started?
                    </h2>
                    <p className="text-gray-600 mb-8 max-w-2xl mx-auto">
                        Join thousands of companies that trust iDocProc for their document processing needs.
                    </p>
                    <Link to="/signup" className="btn-primary">
                        Start Free Trial
                    </Link>
                </div>
            </section>
        </>
    )
}

export default Home 