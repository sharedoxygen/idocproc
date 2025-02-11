#!/usr/bin/env bash
set -eo pipefail

SAMPLE_DOCS_DIR="../../data/sample_documents"

# Create directory structure
mkdir -p $SAMPLE_DOCS_DIR/{financial,hr,tech,finance,legal}

# Generate sample PDF documents
generate_pdf() {
    local output_file=$1
    local title=$2
    local content=$3
    
    convert -size 612x792 xc:white -font Helvetica -pointsize 24 \
        -draw "text 50,100 '$title'" \
        -pointsize 12 \
        -draw "text 50,150 '$content'" \
        "$output_file"
}

# Generate sample documents
generate_pdf "$SAMPLE_DOCS_DIR/financial/q4_report.pdf" \
    "Q4 Financial Report" \
    "This is a sample Q4 financial report for demonstration purposes."

generate_pdf "$SAMPLE_DOCS_DIR/hr/contract_template.pdf" \
    "Employment Contract" \
    "This is a sample employment contract template."

generate_pdf "$SAMPLE_DOCS_DIR/finance/inv1234.pdf" \
    "Invoice #1234" \
    "This is a sample invoice document."

generate_pdf "$SAMPLE_DOCS_DIR/legal/agreement.pdf" \
    "Legal Agreement" \
    "This is a sample legal agreement document."

# Generate sample Word document
cat > "$SAMPLE_DOCS_DIR/tech/spec_v1.docx" << EOL
Technical Specification Document
Version 1.0

This is a sample technical specification document.
EOL

echo "Sample documents generated successfully!" 