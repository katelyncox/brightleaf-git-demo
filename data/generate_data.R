# =============================================================================
# generate_data.R
# Synthetic data generator for Brightleaf Coffee Co. (fictional company)
#
# This project contains synthetic data and analysis created for demonstration
# purposes only. All data is AI-generated and does not represent any real
# business.
#
# Output: data/synthetic-coffee-sales.csv
# Usage:  Rscript data/generate_data.R   (run from the project root)
# =============================================================================

set.seed(2026)

stores <- c("Downtown Kiosk", "Riverside Cafe", "Campus Corner")
drinks <- data.frame(
  drink = c("Latte", "Cold Brew", "Drip Coffee", "Cappuccino", "Chai Latte"),
  price = c(5.25, 4.75, 3.00, 4.95, 5.00)
)
store_traffic <- c("Downtown Kiosk" = 1.2, "Riverside Cafe" = 1.0, "Campus Corner" = 0.8)

dates <- seq(as.Date("2026-01-01"), as.Date("2026-06-30"), by = "day")

# Every combination of date x store x drink
sales <- expand.grid(
  date = dates, store = stores, drink = drinks$drink,
  stringsAsFactors = FALSE
)
sales <- merge(sales, drinks, by = "drink")

# Simple, explainable patterns:
#  - weekends are busier
#  - cold brew grows as the weather warms (Jan -> Jun)
#  - each store has its own traffic level
month_num <- as.integer(format(sales$date, "%m"))
weekday   <- format(sales$date, "%u") %in% c("6", "7")
base      <- 40 * store_traffic[sales$store] * ifelse(weekday, 1.3, 1.0)
seasonal  <- ifelse(sales$drink == "Cold Brew", 0.5 + month_num * 0.15, 1.0)

sales$cups_sold <- rpois(nrow(sales), lambda = base * seasonal)
sales$revenue   <- round(sales$cups_sold * sales$price, 2)

sales <- sales[order(sales$date, sales$store, sales$drink),
               c("date", "store", "drink", "price", "cups_sold", "revenue")]

# Write with a comment header flagging the data as synthetic
out_file <- file.path("data", "synthetic-coffee-sales.csv")
con <- file(out_file, "w")
writeLines(
  "# SYNTHETIC DATA - AI-generated for demonstration purposes only (Brightleaf Coffee Co. is fictional)",
  con
)
write.csv(sales, con, row.names = FALSE)
close(con)

message("Wrote ", nrow(sales), " rows to ", out_file)
