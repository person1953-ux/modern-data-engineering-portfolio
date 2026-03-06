"""
Usage examples for the Employee Data Normalizer
"""

from employee_data_normalizer import EmployeeDataNormalizer, normalize_employee_csv
import os

# Example 1: Basic usage with the main function
print("Example 1: Using the main normalize_employee_csv function\n")
print("-" * 60)

script_dir = os.path.dirname(os.path.abspath(__file__))
input_file = os.path.join(script_dir, 'employees_sample.csv')
output_file = os.path.join(script_dir, 'employees_cleaned.csv')

if os.path.exists(input_file):
    cleaned_df = normalize_employee_csv(input_file, output_file)
    print("First 5 rows of cleaned data:")
    print(cleaned_df.head())
else:
    print(f"Input file not found: {input_file}")
    print("Make sure you have a CSV file to process")

# Example 2: Using the EmployeeDataNormalizer class directly for more control
print("\n" + "="*60)
print("Example 2: Using EmployeeDataNormalizer class for custom processing\n")
print("-" * 60)

# Create normalizer instance
normalizer = EmployeeDataNormalizer(
    input_file=input_file,
    output_file=os.path.join(script_dir, 'employees_custom_output.csv')
)

# Step-by-step processing
print("Step 1: Loading data...")
normalizer.load_data()

print("Step 2: Normalizing data...")
cleaned_data = normalizer.normalize_data()

print("\nStep 3: Checking data quality...")
print(f"Total columns: {len(cleaned_data.columns)}")
print(f"Column names: {list(cleaned_data.columns)}")
print(f"\nMissing values per column:")
print(cleaned_data.isnull().sum())

print("Step 4: Saving cleaned data...")
normalizer.save_cleaned_data()

print("\nStep 5: Displaying normalization report...")
normalizer.print_report()

print("\nCleaned Data Sample:")
print(cleaned_data.head(10).to_string())

print("\n" + "="*60)
print("Data types of cleaned data:")
print(cleaned_data.dtypes)
print("="*60)
