# Employee Data Normalizer

A Python script to clean, validate, and normalize messy employee CSV data.

## 📋 Overview

This tool handles common data quality issues in employee data including:
- ✅ Missing or invalid email addresses
- ✅ Inconsistent phone number formats
- ✅ Improperly formatted city/state information
- ✅ Duplicate records
- ✅ Inconsistent name capitalization
- ✅ Date format normalization
- ✅ Data validation

## 🚀 Quick Start

### 1. Install Dependencies

```bash
pip install -r requirements.txt
```

**Requirements:**
- pandas >= 1.3.0
- Python 3.7+

### 2. Run the Script

#### Option A: Run with Sample Data (Quick Test)
```bash
python employee_data_normalizer.py
```

This will:
- Load `employees_sample.csv`
- Clean and normalize the data
- Output to `employees_production.csv`
- Display a normalization report

#### Option B: Run with Your Own CSV File

Edit the script's main block and change the input file:

```python
if __name__ == "__main__":
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_csv = os.path.join(script_dir, 'YOUR_FILE.csv')  # ← Change this
    output_csv = os.path.join(script_dir, 'employees_production.csv')
    
    if os.path.exists(input_csv):
        cleaned_df = normalize_employee_csv(input_csv, output_csv)
```

Then run:
```bash
python employee_data_normalizer.py
```

#### Option C: Use the Example Script

```bash
python example_usage.py
```

This shows more advanced usage examples.

## 📁 File Structure

```
PYTHON_NORMALIZATION/
├── employee_data_normalizer.py    # Main normalizer class
├── employees_sample.csv           # Sample messy data (for testing)
├── employees_production.csv       # Output cleaned data
├── example_usage.py               # Usage examples
├── requirements.txt               # Dependencies
└── README.md                      # This file
```

## 📊 Data Processing Details

### Input CSV Requirements
Your CSV should have these columns (or similar):
- `id` - Employee ID
- `name` - Employee name
- `email` - Email address
- `phone` - Phone number
- `city` - City name
- `state` - State abbreviation or full name
- `salary` - Salary amount
- `hire_date` - Hire date

### What Gets Cleaned

| Field | Cleaning Rules |
|-------|---|
| **Name** | Title case, removes empty values |
| **Email** | Must contain @, lowercase, removes extra spaces |
| **Phone** | Converts to XXX-XXX-XXXX (US 10-digit only) |
| **City** | Title case |
| **State** | Converts to 2-letter abbreviation (accepts full names or abbrev) |
| **Salary** | Numeric validation, removes negative values |
| **Hire Date** | Converts to YYYY-MM-DD format |
| **Duplicates** | Removes complete duplicate rows |

## 📈 Output Report

After running, you'll see a report like:

```
==================================================
EMPLOYEE DATA NORMALIZATION REPORT
==================================================
Input File: employees_sample.csv
Output File: employees_production.csv
Initial Rows: 15
Final Rows: 8
Rows Removed: 7
Removal Percentage: 46.67%
==================================================
```

## 🔧 Python Usage

### Method 1: Simple Function Call

```python
from employee_data_normalizer import normalize_employee_csv

cleaned_df = normalize_employee_csv('input.csv', 'output.csv')
print(cleaned_df)
```

### Method 2: Using the Class

```python
from employee_data_normalizer import EmployeeDataNormalizer

# Create normalizer
normalizer = EmployeeDataNormalizer('input.csv', 'output.csv')

# Load data
normalizer.load_data()

# Normalize
cleaned_data = normalizer.normalize_data()

# Save
normalizer.save_cleaned_data()

# Get report
normalizer.print_report()

# Access cleaned dataframe
print(cleaned_data)
```

## 📝 Example Output

**Before:**
```
id,name,email,phone,city,state,salary,hire_date
1,John Doe,john.doe@gmail.com,555-1234,New York,NY,50000,2020-01-15
2,jane smith,janesmith.com,5551234567,new york,new york,55000,2019-03-22
3,Bob Johnson,bob@,555-9999,los angeles,CA,60000,2021-06-10
```

**After:**
```
id,name,email,phone,city,state,salary,hire_date
1,John Doe,john.doe@gmail.com,555-1234,New York,NY,50000.0,2020-01-15
5,Alice Williams,alice.williams@yahoo.com,,Los Angeles,CA,62000.0,2020-11-30
8,Edward Norton,edward@norton.com,555-2468,New York,NY,61000.0,2019-05-12
```

## 🎯 Common Tasks

### Task 1: Clean Multiple Files
```bash
# Copy file
copy input1.csv employees_sample.csv
python employee_data_normalizer.py

# Rename output
move employees_production.csv employees_cleaned_1.csv

# Repeat for other files...
```

### Task 2: View Cleaned Data
```bash
python example_usage.py
```

### Task 3: Check What Was Removed
The report shows how many rows were removed and why:
- Missing required fields (name, valid email)
- Invalid phone numbers
- Data format issues

## ⚠️ Important Notes

1. **Data Loss**: Invalid records are removed. Review the report to understand what was filtered out.
2. **Backups**: Always keep original CSV files before processing.
3. **Email Validation**: Must contain @ and valid domain structure.
4. **Phone**: Only 10-digit US numbers are valid.
5. **State**: Accepts both abbreviations (NY) and full names (New York).

## 📋 Logging

The script logs all operations. Check the console output for:
- ✓ Successfully loaded rows
- ⚠ Warnings about removed data
- ❌ Errors during processing

## 🐛 Troubleshooting

**Problem**: "File not found"
- **Solution**: Make sure your CSV is in the same directory as the script, or provide the full path.

**Problem**: "No module named 'pandas'"
- **Solution**: Run `pip install -r requirements.txt`

**Problem**: All rows were removed
- **Solution**: Check your email and name columns - they must be valid/non-empty.

## 📞 Support

For issues with:
- Missing columns: Ensure your CSV has the expected column names
- Data validation: Review the warning messages in the output
- Format issues: Check the cleaning rules in the table above

---

**Created**: January 2026  
**Version**: 1.0  
**Author**: Python Normalization Team
