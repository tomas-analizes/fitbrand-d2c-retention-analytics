# FitBrand Co. — D2C Retention & Growth Analytics

![Power BI Dashboard](powerbi/screenshots/dashboard_preview.png)

A full-stack analytics case study on a direct-to-consumer supplement brand: synthetic data generation, SQL modeling, and a Power BI dashboard, built to answer one question — why does customer lifetime value differ so sharply by acquisition channel, and what should the business do about it.

---

## 1. Business Overview & Problem Statement

FitBrand Co. acquires customers through four channels — Ambassador, Organic, Instagram, and TikTok — and each one produces a different quality of customer, not just a different cost per acquisition. Marketing budgets are usually allocated by CAC alone, which rewards the cheapest channel regardless of whether that channel's customers ever come back.

This project traces 1,807 transactions from 1,000 unique clients (**$71,175 in total sales**, average LTV **$71.18**, global retention rate **40.10%**) to determine which channel actually generates the most profit per customer once retention and CAC are priced in, and where the recurring-revenue drop-off is coming from. The output is a reallocation decision backed by unit economics, not a dashboard for its own sake.

## 2. Tech Stack & Repository Structure

**Stack:** Python (Pandas, Faker) for data generation · SQLite for relational modeling and window functions · Power BI + DAX for the executive dashboard.

```
fitbrand-retention-analytics/
├── 01_etl_and_eda_fitbrand.ipynb        # Data generation, SQLite load, SQL analysis
├── fitbrand_transactions.csv            # Raw transaction-level output
├── fitbrand.db                          # SQLite database (transactions table)
├── powerbi/
│   ├── FitBrand_Dashboard.pbix          # Power BI file (model + DAX measures)
│   └── screenshots/dashboard_preview.png
├── FitBrand_Executive_Report_ES.docx    # Full write-up (Spanish)
├── requirements.txt
└── README.md
```

| File | What it's for |
|---|---|
| `01_etl_and_eda_fitbrand.ipynb` | Generates the synthetic dataset with Faker, applies channel-based retention probabilities and product depletion cycles, loads it into SQLite, and runs the retention/LTV and repurchase-velocity queries. |
| `fitbrand_transactions.csv` | One row per transaction — the raw layer both SQL and Power BI read from. |
| `fitbrand.db` | SQLite database with the `transactions` table used for all SQL work. |
| `powerbi/FitBrand_Dashboard.pbix` | The relational model and DAX measures behind the executive dashboard. |
| `FitBrand_Executive_Report_ES.docx` | The complete narrative report — methodology, assumptions, and recommendations. |

## 3. Key Findings & Unit Economics

Revenue by channel doesn't tell you much on its own. Once retention, gross margin (65% industry assumption for D2C supplements), and estimated CAC are factored in, the gap between channels stops being marginal:

| Channel | Retention % | LTV | Gross Margin | CAC | Net Profit / Client |
|---|---|---|---|---|---|
| **Ambassador** | 54.83% | $84.29 | $54.79 | $8.00 | $46.79 |
| Organic | 52.94% | $83.38 | $54.20 | $0.00 | $54.20 |
| Instagram | 30.48% | $62.42 | $40.57 | $12.00 | $28.57 |
| **TikTok** | 21.79% | $54.32 | $35.31 | $15.00 | $20.31 |

Organic — with no acquisition cost at all — is the single most profitable channel on a per-customer basis. Ambassador is the strongest paid channel, with net profit more than double TikTok's. TikTok isn't unprofitable, but it trails on every metric that matters after CAC.

**Repurchase cycles**, pulled from a SQL `LAG()` window function measuring actual days between consecutive purchases, run longer than each product's nominal depletion cycle:

| Product | Nominal Cycle | Empirical Avg. Days to Repurchase |
|---|---|---|
| Whey Protein | 30 days | 35 days |
| Pre-Workout | 45 days | 51 days |
| Creatine | 60 days | 65 days |
| Multivitamin | 90 days | 95 days |

That consistent ~5–6 day lag is the window retargeting needs to close — customers aren't repurchasing late by accident, they're repurchasing late by default.

## 4. Deep Dive: Blended vs. Retained LTV Analysis

The blended LTV numbers above mix first-time buyers with repeat customers, and that mix hides where TikTok is actually losing money. On a blended basis, Ambassador outperforms TikTok by **$29.97** ($84.29 vs. $54.32) — a 55% gap that looks like TikTok customers are simply worth less.

Isolating only customers who made a second purchase (`purchase_number > 1`) tells a different story:

| Channel | Retained-Only LTV |
|---|---|
| Ambassador | ~$123.91 |
| TikTok | ~$111.08 |

Once a TikTok customer repurchases, their value sits within **~$12.83** of Ambassador's — an 11% gap, not 55%. TikTok's problem isn't customer quality; it's first-purchase churn. Most TikTok customers never make it to a second order, but the ones who do behave almost like everyone else. That distinction changes the fix: this isn't a "TikTok traffic is bad" problem, it's a "TikTok's first 30 days have no retention mechanism" problem.

## 5. Strategic Action Plan

1. **Reallocate 30% of TikTok's paid media budget to the Ambassador commission program.** Ambassador already delivers more than double TikTok's net profit per client, and Organic's $0 CAC means it should be defended with more owned-content investment, not touched by the reallocation.
2. **A first-30-day retention sequence specifically for TikTok**, since the retained-LTV gap shows the value loss is concentrated at the first-to-second-purchase transition, not in the long-term value of customers who do come back.
3. **Retargeting triggers timed to the empirical repurchase cycle, not the nominal one.** Whey Protein customers should be re-engaged around day 30–32 — the `LAG()` output shows the real median lands at 35 days, and a day-25 trigger would try to sell a customer who hasn't run out yet.
4. **Checkout cross-sell bundles** for single-SKU TikTok orders, to raise the odds a customer's first order includes something with a shorter depletion cycle, giving retargeting an earlier, more natural touchpoint.

## 6. Instructions to Run Locally

```bash
# 1. Clone the repository
git clone https://github.com/your-username/fitbrand-retention-analytics.git
cd fitbrand-retention-analytics

# 2. Create a virtual environment and install dependencies
python -m venv venv
source venv/bin/activate      # Windows: venv\Scripts\activate
pip install -r requirements.txt

# 3. Run the notebook to regenerate the dataset and SQL analysis
jupyter notebook 01_etl_and_eda_fitbrand.ipynb
# This produces fitbrand_transactions.csv and fitbrand.db

# 4. Open the dashboard
# Requires Power BI Desktop (Windows) — open powerbi/FitBrand_Dashboard.pbix
# and point the data source at fitbrand.db or the CSV.
```

`requirements.txt`:
```
pandas
faker
jupyter
```

---

*Full methodology, stated assumptions, and the SQL/DAX detail behind every number above are documented in [`FitBrand_Executive_Report_ES.docx`](./FitBrand_Executive_Report_ES.docx).*
