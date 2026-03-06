"""
Employee Data Normalization Script
Handles data cleaning, validation, and normalization of employee CSV files.
"""

import pandas as pd
import re
import logging
from typing import Optional, Tuple, List
from datetime import datetime
import os

# Setup logging
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')
logger = logging.getLogger(__name__)

class EmployeeDataNormalizer:
    """
    A class to normalize and clean messy employee data from CSV files.
    """
    
    # Dictionary of US state abbreviations and full names
    STATE_MAPPING = {
        'AL': 'Alabama', 'AK': 'Alaska', 'AZ': 'Arizona', 'AR': 'Arkansas',
        'CA': 'California', 'CO': 'Colorado', 'CT': 'Connecticut', 'DE': 'Delaware',
        'FL': 'Florida', 'GA': 'Georgia', 'HI': 'Hawaii', 'ID': 'Idaho',
        'IL': 'Illinois', 'IN': 'Indiana', 'IA': 'Iowa', 'KS': 'Kansas',
        'KY': 'Kentucky', 'LA': 'Louisiana', 'ME': 'Maine', 'MD': 'Maryland',
        'MA': 'Massachusetts', 'MI': 'Michigan', 'MN': 'Minnesota', 'MS': 'Mississippi',
        'MO': 'Missouri', 'MT': 'Montana', 'NE': 'Nebraska', 'NV': 'Nevada',
        'NH': 'New Hampshire', 'NJ': 'New Jersey', 'NM': 'New Mexico', 'NY': 'New York',
        'NC': 'North Carolina', 'ND': 'North Dakota', 'OH': 'Ohio', 'OK': 'Oklahoma',
        'OR': 'Oregon', 'PA': 'Pennsylvania', 'RI': 'Rhode Island', 'SC': 'South Carolina',
        'SD': 'South Dakota', 'TN': 'Tennessee', 'TX': 'Texas', 'UT': 'Utah',
        'VT': 'Vermont', 'VA': 'Virginia', 'WA': 'Washington', 'WV': 'West Virginia',
        'WI': 'Wisconsin', 'WY': 'Wyoming'
    }
    
    # Reverse mapping for full names to abbreviations
    STATE_REVERSE_MAPPING = {v.lower(): k for k, v in STATE_MAPPING.items()}
    
    def __init__(self, input_file: str, output_file: Optional[str] = None):
        """
        Initialize the normalizer.
        
        Args:
            input_file: Path to the input CSV file
            output_file: Path to save the cleaned CSV file (optional)
        """
        self.input_file = input_file
        self.output_file = output_file or input_file.replace('.csv', '_cleaned.csv')
        self.df = None
        self.initial_row_count = 0
        self.final_row_count = 0
        
    def load_data(self) -> pd.DataFrame:
        """Load CSV file with error handling."""
        try:
            self.df = pd.read_csv(self.input_file)
            self.initial_row_count = len(self.df)
            logger.info(f"Loaded {self.initial_row_count} rows from {self.input_file}")
            return self.df
        except FileNotFoundError:
            logger.error(f"File not found: {self.input_file}")
            raise
        except Exception as e:
            logger.error(f"Error loading file: {e}")
            raise
    
    @staticmethod
    def normalize_name(name: str) -> Optional[str]:
        """
        Normalize names to proper case and handle missing values.
        
        Args:
            name: The name string to normalize
            
        Returns:
            Normalized name or None if empty
        """
        if pd.isna(name) or name == '':
            return None
        
        name = str(name).strip()
        if not name:
            return None
        
        # Title case the name (capitalize first letter of each word)
        name = name.title()
        return name
    
    @staticmethod
    def validate_email(email: str) -> bool:
        """
        Validate email format (must contain @ and valid structure).
        
        Args:
            email: Email string to validate
            
        Returns:
            True if valid, False otherwise
        """
        if pd.isna(email) or email == '':
            return False
        
        email = str(email).strip()
        # Basic email validation pattern
        pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$'
        return bool(re.match(pattern, email))
    
    @staticmethod
    def normalize_email(email: str) -> Optional[str]:
        """
        Normalize and clean email addresses.
        
        Args:
            email: The email string to normalize
            
        Returns:
            Normalized email or None if invalid
        """
        if pd.isna(email) or email == '':
            return None
        
        email = str(email).strip().lower()
        
        # Remove extra spaces
        email = re.sub(r'\s+', '', email)
        
        # Check if email is valid
        if EmployeeDataNormalizer.validate_email(email):
            return email
        
        return None
    
    @staticmethod
    def normalize_phone(phone: str) -> Optional[str]:
        """
        Normalize phone numbers to a consistent format (XXX-XXX-XXXX).
        
        Args:
            phone: The phone string to normalize
            
        Returns:
            Normalized phone number or None if invalid
        """
        if pd.isna(phone) or phone == '':
            return None
        
        phone = str(phone).strip()
        
        # Remove all non-digit characters
        digits_only = re.sub(r'\D', '', phone)
        
        # Check if we have exactly 10 digits (US format)
        if len(digits_only) == 10:
            # Format as XXX-XXX-XXXX
            return f"{digits_only[0:3]}-{digits_only[3:6]}-{digits_only[6:10]}"
        
        # If not 10 digits, consider it invalid
        return None
    
    @staticmethod
    def normalize_city(city: str) -> Optional[str]:
        """
        Normalize city names to title case.
        
        Args:
            city: The city string to normalize
            
        Returns:
            Normalized city or None if empty
        """
        if pd.isna(city) or city == '':
            return None
        
        city = str(city).strip().title()
        return city
    
    @staticmethod
    def normalize_state(state: str) -> Optional[str]:
        """
        Normalize state to 2-letter abbreviation.
        Accepts both full names and abbreviations.
        
        Args:
            state: The state string to normalize
            
        Returns:
            2-letter state abbreviation or None if invalid
        """
        if pd.isna(state) or state == '':
            return None
        
        state = str(state).strip().upper()
        
        # If it's already a 2-letter code and valid
        if len(state) == 2 and state in EmployeeDataNormalizer.STATE_MAPPING:
            return state
        
        # Try to find by full name
        state_lower = state.lower()
        if state_lower in EmployeeDataNormalizer.STATE_REVERSE_MAPPING:
            return EmployeeDataNormalizer.STATE_REVERSE_MAPPING[state_lower]
        
        return None
    
    @staticmethod
    def normalize_salary(salary) -> Optional[float]:
        """
        Normalize salary to float value.
        
        Args:
            salary: The salary value to normalize
            
        Returns:
            Salary as float or None if invalid
        """
        if pd.isna(salary) or salary == '':
            return None
        
        try:
            salary_float = float(salary)
            if salary_float < 0:
                return None
            return salary_float
        except (ValueError, TypeError):
            return None
    
    @staticmethod
    def normalize_date(date_str) -> Optional[str]:
        """
        Normalize dates to YYYY-MM-DD format.
        
        Args:
            date_str: The date string to normalize
            
        Returns:
            Date in YYYY-MM-DD format or None if invalid
        """
        if pd.isna(date_str) or date_str == '':
            return None
        
        date_str = str(date_str).strip()
        
        # Try common date formats
        common_formats = [
            '%Y-%m-%d', '%m/%d/%Y', '%d/%m/%Y', '%m-%d-%Y',
            '%Y/%m/%d', '%d-%m-%Y', '%B %d, %Y', '%b %d, %Y'
        ]
        
        for fmt in common_formats:
            try:
                date_obj = datetime.strptime(date_str, fmt)
                return date_obj.strftime('%Y-%m-%d')
            except ValueError:
                continue
        
        return None
    
    def remove_duplicates(self):
        """Remove completely duplicate rows."""
        initial_count = len(self.df)
        self.df = self.df.drop_duplicates()
        removed = initial_count - len(self.df)
        if removed > 0:
            logger.info(f"Removed {removed} duplicate rows")
    
    def normalize_data(self) -> pd.DataFrame:
        """
        Apply all normalization steps to the dataframe.
        
        Returns:
            Normalized dataframe
        """
        if self.df is None:
            raise ValueError("Data not loaded. Call load_data() first.")
        
        logger.info("Starting data normalization...")
        
        # Step 1: Remove duplicates
        self.remove_duplicates()
        
        # Step 2: Normalize individual columns
        if 'id' in self.df.columns:
            logger.info("Normalizing ID column...")
            # Ensure IDs are integers and handle duplicates
            self.df['id'] = pd.to_numeric(self.df['id'], errors='coerce')
            self.df['id'] = self.df['id'].astype('Int64')  # Nullable integer
        
        if 'name' in self.df.columns:
            logger.info("Normalizing name column...")
            self.df['name'] = self.df['name'].apply(self.normalize_name)
            # Remove rows with missing names
            initial_count = len(self.df)
            self.df = self.df.dropna(subset=['name'])
            if len(self.df) < initial_count:
                logger.warning(f"Removed {initial_count - len(self.df)} rows with missing names")
        
        if 'email' in self.df.columns:
            logger.info("Normalizing email column...")
            self.df['email'] = self.df['email'].apply(self.normalize_email)
            # Remove rows with invalid emails
            initial_count = len(self.df)
            self.df = self.df.dropna(subset=['email'])
            if len(self.df) < initial_count:
                logger.warning(f"Removed {initial_count - len(self.df)} rows with invalid emails")
        
        if 'phone' in self.df.columns:
            logger.info("Normalizing phone column...")
            self.df['phone'] = self.df['phone'].apply(self.normalize_phone)
        
        if 'city' in self.df.columns:
            logger.info("Normalizing city column...")
            self.df['city'] = self.df['city'].apply(self.normalize_city)
        
        if 'state' in self.df.columns:
            logger.info("Normalizing state column...")
            self.df['state'] = self.df['state'].apply(self.normalize_state)
        
        if 'salary' in self.df.columns:
            logger.info("Normalizing salary column...")
            self.df['salary'] = self.df['salary'].apply(self.normalize_salary)
        
        if 'hire_date' in self.df.columns:
            logger.info("Normalizing hire_date column...")
            self.df['hire_date'] = self.df['hire_date'].apply(self.normalize_date)
        
        # Step 3: Fill remaining NaN values with appropriate defaults
        logger.info("Handling missing values...")
        for col in self.df.columns:
            if self.df[col].isna().any():
                missing_count = self.df[col].isna().sum()
                logger.warning(f"Column '{col}' has {missing_count} missing values")
        
        self.final_row_count = len(self.df)
        logger.info(f"Normalization complete. Final row count: {self.final_row_count}")
        
        return self.df
    
    def save_cleaned_data(self) -> None:
        """Save the cleaned data to CSV file."""
        if self.df is None:
            raise ValueError("No data to save. Call normalize_data() first.")
        
        try:
            self.df.to_csv(self.output_file, index=False)
            logger.info(f"Cleaned data saved to {self.output_file}")
            logger.info(f"Rows removed: {self.initial_row_count - self.final_row_count}")
        except Exception as e:
            logger.error(f"Error saving file: {e}")
            raise
    
    def get_normalization_report(self) -> dict:
        """
        Generate a report of the normalization process.
        
        Returns:
            Dictionary with normalization statistics
        """
        return {
            'input_file': self.input_file,
            'output_file': self.output_file,
            'initial_rows': self.initial_row_count,
            'final_rows': self.final_row_count,
            'rows_removed': self.initial_row_count - self.final_row_count,
            'removal_percentage': f"{((self.initial_row_count - self.final_row_count) / self.initial_row_count * 100):.2f}%"
        }
    
    def print_report(self) -> None:
        """Print a formatted normalization report."""
        report = self.get_normalization_report()
        print("\n" + "="*50)
        print("EMPLOYEE DATA NORMALIZATION REPORT")
        print("="*50)
        for key, value in report.items():
            print(f"{key.replace('_', ' ').title()}: {value}")
        print("="*50 + "\n")


def normalize_employee_csv(input_file: str, output_file: Optional[str] = None) -> pd.DataFrame:
    """
    Main function to normalize employee CSV data.
    
    Args:
        input_file: Path to the input CSV file
        output_file: Path to save the cleaned CSV file (optional)
        
    Returns:
        Cleaned dataframe
    """
    normalizer = EmployeeDataNormalizer(input_file, output_file)
    normalizer.load_data()
    normalizer.normalize_data()
    normalizer.save_cleaned_data()
    normalizer.print_report()
    return normalizer.df


if __name__ == "__main__":
    # Example usage
    script_dir = os.path.dirname(os.path.abspath(__file__))
    input_csv = os.path.join(script_dir, 'employees_sample.csv')
    output_csv = os.path.join(script_dir, 'employees_production.csv')
    
    if os.path.exists(input_csv):
        cleaned_df = normalize_employee_csv(input_csv, output_csv)
        print("\nCleaned Data Preview:")
        print(cleaned_df.head(10))
    else:
        print(f"Input file not found: {input_csv}")
        print(f"Please place your employees.csv file in: {script_dir}")
