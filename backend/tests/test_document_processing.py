import pytest
from fastapi.testclient import TestClient
from services.document_processor import process_document

def test_document_processing():
    client = TestClient(app)
    
    # Test valid PDF processing
    with open("tests/sample.pdf", "rb") as f:
        response = client.post(
            "/api/v1/process",
            files={"file": ("sample.pdf", f, "application/pdf")}
        )
        assert response.status_code == 200
        data = response.json()
        assert len(data['chunks']) > 0
        assert 'metadata' in data
        
    # Test invalid file type
    with open("tests/invalid.exe", "rb") as f:
        response = client.post(
            "/api/v1/process",
            files={"file": ("invalid.exe", f, "application/exe")}
        )
        assert response.status_code == 400 