from fastapi import APIRouter, UploadFile
from langchain.document_loaders import UnstructuredFileLoader
from langchain.text_splitter import RecursiveCharacterTextSplitter
import logging

router = APIRouter()

async def process_document(file: UploadFile):
    """Process document with LangChain pipeline"""
    try:
        # Save uploaded file temporarily
        file_path = f"/tmp/{file.filename}"
        with open(file_path, "wb") as f:
            f.write(await file.read())
        
        # Load and split document
        loader = UnstructuredFileLoader(file_path)
        documents = loader.load()
        
        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=1000,
            chunk_overlap=200,
            length_function=len,
            add_start_index=True
        )
        chunks = text_splitter.split_documents(documents)
        
        # Process metadata
        metadata = {
            "filename": file.filename,
            "chunk_count": len(chunks),
            "content_type": file.content_type,
            "processing_time": datetime.utcnow().isoformat()
        }
        
        return {
            "chunks": [chunk.page_content for chunk in chunks],
            "metadata": metadata
        }
        
    except Exception as e:
        logging.error(f"Document processing failed: {str(e)}")
        raise HTTPException(status_code=500, detail="Processing error") 