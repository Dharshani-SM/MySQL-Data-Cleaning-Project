# 🧹 MySQL Data Cleaning Project: Layoffs Dataset (2020–2023)

## 📌 Project Overview

This project demonstrates the end-to-end **data cleaning process using MySQL** on a real-world "Layoffs" dataset (2020–2023). The dataset includes company-wise layoff information such as industry, location, total laid-off employees, and more.

The goal was to clean and prepare the data for further analysis by:
- Removing duplicates
- Standardizing inconsistent formats
- Fixing data types
- Handling null values
- Cleaning text fields like industry, country, and company names

---

## 🛠️ Tools Used

- **MySQL**
- SQL functions: `ROW_NUMBER()`, `JOIN`, `TRIM()`, `STR_TO_DATE()`, `IS NULL`, `DELETE`, `ALTER`, etc.

---

## 🧾 Key Steps Performed

### 1. 🗂️ Table Preparation
- Created a staging table to work without affecting the raw data.
- Used `INSERT INTO` and `LIKE` to clone data.

### 2. 🔍 Duplicate Removal
- Used `ROW_NUMBER()` window function with a CTE to identify duplicates.
- Deleted rows with `row_num > 1`.

### 3. 🧽 Data Standardization
- Cleaned up white spaces using `TRIM()`.
- Fixed inconsistent industry names (e.g., `'crypto'`, `'Crypto'`, `'crypto currency'` → `Crypto`).
- Removed trailing dots from country names.
- Converted `date` column from `TEXT` to `DATE` format using `STR_TO_DATE()` and `ALTER`.

### 4. 🚮 Null Handling
- Removed rows with both `total_laid_off` and `percentage_laid_off` as null.
- Updated missing industries using self `JOIN` based on company name.

### 5. 🧹 Final Cleanup
- Removed temporary columns like `row_num`.

---

## 🧠 Insights Gained

This project helped in:
- Understanding the importance of clean, reliable data
- Practicing real-world data cleaning logic using SQL only
- Preparing data for further analysis or visualization


---

## 📊 Future Scope

This cleaned dataset can now be used to:
- Create visual dashboards using Power BI or Tableau
- Perform deeper analysis on layoffs trend, funding, or industry impact

---

## 🙋‍♀️ Author

**Dharshani**  
Aspiring Data Analyst 
www.linkedin.com/in/dharshani-srinivasan-4278ab283 
