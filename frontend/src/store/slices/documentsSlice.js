import { createSlice } from '@reduxjs/toolkit'

const initialState = {
    documents: [
        {
            id: 1,
            title: 'Q4 Financial Report',
            type: 'application/pdf',
            status: 'processed',
            tags: ['Report', 'Financial'],
            createdAt: '2024-02-11T20:00:00Z',
            updatedAt: '2024-02-11T20:30:00Z'
        },
        {
            id: 2,
            title: 'Employment Contract',
            type: 'application/pdf',
            status: 'processed',
            tags: ['Contract', 'HR'],
            createdAt: '2024-02-11T19:00:00Z',
            updatedAt: '2024-02-11T19:15:00Z'
        },
        // Add more sample documents...
    ],
    tags: ['Invoice', 'Contract', 'Report', 'Legal', 'Financial', 'HR', 'Technical'],
    status: 'idle',
    error: null
}

const documentsSlice = createSlice({
    name: 'documents',
    initialState,
    reducers: {
        // Add reducers here
    }
})

export default documentsSlice.reducer 