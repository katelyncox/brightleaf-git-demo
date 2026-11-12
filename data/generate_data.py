"""
generate_data.py
Synthetic data generator for Brightleaf Coffee Co. (fictional company).

This project contains synthetic data and analysis created for demonstration
purposes only. All data is AI-generated and does not represent any real business.

Output: data/synthetic-coffee-sales.csv  (same schema as generate_data.R)
Usage:  uv run python data/generate_data.py   (run from the project root)
"""

from datetime import date, timedelta
from pathlib import Path

import numpy as np
import polars as pl

rng = np.random.default_rng(2026)

STORES = {"Downtown Kiosk": 1.2, "Riverside Cafe": 1.0, "Campus Corner": 0.8}
DRINKS = {"Latte": 5.25, "Cold Brew": 4.75, "Drip Coffee": 3.00,
          "Cappuccino": 4.95, "Chai Latte": 5.00}

start, end = date(2026, 1, 1), date(2026, 6, 30)
dates = [start + timedelta(days=i) for i in range((end - start).days + 1)]

rows = []
for d in dates:
    weekend = d.isoweekday() >= 6
    for store, traffic in STORES.items():
        for drink, price in DRINKS.items():
            # Same simple patterns as the R generator
            base = 40 * traffic * (1.3 if weekend else 1.0)
            seasonal = 0.5 + d.month * 0.15 if drink == "Cold Brew" else 1.0
            cups = int(rng.poisson(base * seasonal))
            rows.append((d, store, drink, price, cups, round(cups * price, 2)))

sales = pl.DataFrame(
    rows,
    schema=["date", "store", "drink", "price", "cups_sold", "revenue"],
    orient="row",
)

out_file = Path(__file__).parent / "synthetic-coffee-sales.csv"
with open(out_file, "w") as f:
    f.write("# SYNTHETIC DATA - AI-generated for demonstration purposes only "
            "(Brightleaf Coffee Co. is fictional)\n")
    sales.write_csv(f)

print(f"Wrote {sales.height} rows to {out_file}")
