# Quan-Simu
# Quantium Virtual Internship – Retail Strategy & Analytics  
**Data-Driven Insights for Business Growth**

---

## Overview

This project completely implements the **Quantium Virtual Internship (QVI)**, delivered two tasks using real-world retail transaction data. It covers exploratory data analysis, customer segmentation, brand insights, and statistical evaluation of trial store performance — culminating in business-ready recommendations.

---

## Tasks Summary

### **Task 1: Customer, Brand & Life Stage Segmentation**
- Performed exploratory analysis on:
  - Popular brands across customer segments
  - Differences in customer behavior by **life stage** (Midage single/couple, new families, older families, retirees, young families, and young single/couple) and **premium status** (Budget, Mainstream, Premium)
  - Trends in product quantity, average price, and total sales
- Used bar plots, groupby summaries, and statistical tests (t-tests) to uncover insights
- **Key findings:**
  - **Older singles/couples, and retirees** are strong spenders on chips
  - **Kettle**, **Doritos**, and **Pringles** are popular brands across segments
  - **New Families** are the *least engaged* customer group
  - **Young single/couples, and midage single/couples** spent the highest average price per packet of chips across all customer segments.
  - **Young single/couples, and midage single/couples** prefer **Kettle and Doris** though these brands have the highest average prices.

#### Example Outputs:
- Total sales by customer group
  ![image](https://github.com/user-attachments/assets/00e5278f-3852-4fae-9bc1-57628604a182)
- Customer number by customer segment
  ![image](https://github.com/user-attachments/assets/95c38b18-f5cc-4f1c-a8d9-51458ed6b701)
- Average spend per unit by customer group
![image](https://github.com/user-attachments/assets/16956179-534b-4f2b-8e9a-3831be2715e7)
- Brand preference by young singles and couples
![image](https://github.com/user-attachments/assets/703584e8-e85c-49b0-be1a-03ac617901c7)

- Statistically significant differences in purchase behavior across segments

---

### **Task 2: Trial Store Performance Evaluation**
- **Objective:** Assess the effectiveness of a **product trial in 3 stores**
- Selected **control stores** using:
  - Correlation on pre-trial trends (sales, customer count)
  - Standardised **magnitude distance** scoring

| Trial Store | Control Store |
|-------------|----------------|
| 77          | 233            |
| 86          | 155            |
| 88          | 237            |

- Conducted rigorous analysis using:
  - **Scaled sales comparisons**
  - **Percentage uplift calculations**
  - **T-statistics and confidence intervals**

**Final Conclusion:**
- **Stores 77 and 88** showed **statistically significant uplift**
- **Store 86** did not
- **Overall**, the trial shows a significant increase in sales. 

---

## 🛠️ Tools Used

- **Python**: `pandas`, `numpy`, `matplotlib`, `seaborn`, `scipy`
- **Jupyter Notebook**: step-by-step walkthrough and visualisation
- **Statistical Methods**: t-tests, percent difference, control matching

