-- Users
CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Documents
CREATE TABLE IF NOT EXISTS documents (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content_type VARCHAR(50) NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    user_id INTEGER REFERENCES users(id),
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Tags
CREATE TABLE IF NOT EXISTS tags (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Document Tags
CREATE TABLE IF NOT EXISTS document_tags (
    document_id INTEGER REFERENCES documents(id),
    tag_id INTEGER REFERENCES tags(id),
    PRIMARY KEY (document_id, tag_id)
);

-- Insert sample users
INSERT INTO users (email, name) VALUES
('john.doe@example.com', 'John Doe'),
('jane.smith@example.com', 'Jane Smith'),
('bob.wilson@example.com', 'Bob Wilson');

-- Insert sample tags
INSERT INTO tags (name) VALUES
('Invoice'),
('Contract'),
('Report'),
('Legal'),
('Financial'),
('HR'),
('Technical');

-- Insert sample documents
INSERT INTO documents (title, content_type, file_path, user_id, status) VALUES
('Q4 Financial Report', 'application/pdf', '/documents/financial/q4_report.pdf', 1, 'processed'),
('Employment Contract', 'application/pdf', '/documents/hr/contract_template.pdf', 2, 'processed'),
('Technical Specification', 'application/msword', '/documents/tech/spec_v1.docx', 3, 'pending'),
('Invoice #1234', 'application/pdf', '/documents/finance/inv1234.pdf', 1, 'processed'),
('Legal Agreement', 'application/pdf', '/documents/legal/agreement.pdf', 2, 'processing');

-- Link documents with tags
INSERT INTO document_tags (document_id, tag_id) VALUES
(1, 3), -- Q4 Report -> Report
(1, 5), -- Q4 Report -> Financial
(2, 2), -- Employment Contract -> Contract
(2, 6), -- Employment Contract -> HR
(3, 7), -- Technical Specification -> Technical
(4, 1), -- Invoice -> Invoice
(4, 5), -- Invoice -> Financial
(5, 4); -- Legal Agreement -> Legal 