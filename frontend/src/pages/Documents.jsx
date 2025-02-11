import React from 'react'

function Documents() {
    return (
        <div className="container mx-auto px-4 py-8">
            <div className="card">
                <h1 className="text-3xl font-bold text-primary-main mb-6">
                    Documents
                </h1>
                <div className="mb-6">
                    <input
                        type="text"
                        placeholder="Search documents..."
                        className="input w-full"
                    />
                </div>
                <div className="grid gap-4">
                    <div className="p-4 border rounded-lg hover:shadow-md transition-shadow">
                        <p className="text-gray-600">No documents found. Upload one to get started.</p>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default Documents 