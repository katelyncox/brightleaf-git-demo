# Brightleaf Coffee Co. — Git in Posit Workbench Demo

A deliberately **tiny** R and Python project for practicing Git workflows in
**Posit Workbench**: RStudio Pro, Positron Pro, VS Code, and JupyterLab.

Brightleaf Coffee Co. is a fictional, AI-generated coffee retailer with three stores and five drinks.
The analysis is intentionally simple, because the point is the **Git workflow**, not the data science.

👉 **Start here: [GIT-DEMO.md](GIT-DEMO.md)** for credential setup and a step-by-step guide for each IDE.

## Project structure

```
brightleaf-git-demo/
├── data/
│   ├── generate_data.R        # Creates data/synthetic-coffee-sales.csv (R)
│   └── generate_data.py       # Same data schema (Python)
├── eda.qmd                    # R analysis (Quarto), best in RStudio Pro / Positron
├── eda.ipynb                  # Python analysis (notebook), best in JupyterLab / VS Code / Positron
├── _brand.yml                 # Branding used by Quarto
├── GIT-DEMO.md                # Git walkthrough for each IDE
├── BrightleafCoffee.Rproj     # RStudio project (enables the Git pane)
├── renv.lock / .Rprofile      # R environment (renv)
├── pyproject.toml / uv.lock   # Python environment (uv)
└── .gitignore                 # Keeps data, rendered output, and credentials out of Git
```

## Setup

```bash
git clone https://github.com/katelyncox/brightleaf-git-demo.git
cd brightleaf-git-demo
```

**R** (requires R 4.6; the lockfile was built with R 4.6.1)

```r
renv::restore()                 # install R packages from renv.lock
```

```bash
quarto render eda.qmd           # data is generated automatically if missing
```

**Python**

```bash
uv sync                         # create .venv from uv.lock
uv run jupyter lab              # or open eda.ipynb in VS Code or Positron
```

### Synthetic data

The data file is **not** committed (see `.gitignore`). Both `eda.qmd` and `eda.ipynb` generate
it automatically on first run. To generate it manually:

```bash
Rscript data/generate_data.R          # or
uv run python data/generate_data.py
```

## Branding with `_brand.yml`

Quarto reads `_brand.yml` automatically, so you can change colors and fonts in one place and re-render.
This also makes a great **one-line commit** for showing collaboration (see GIT-DEMO.md, section 5).
Learn more at <https://posit-dev.github.io/brand-yml/>.

## Use this as inspiration

- Use this repo as a template to onboard teams to Git in Workbench.
- Add a branch-and-pull-request exercise: create a branch, change a chart, and open a PR.
- Replace the synthetic data with your own project and keep the same `.gitignore` habits:
  don't commit data, rendered output, or credentials.

## Important Disclaimer

**This project contains synthetic data and analysis created for demonstration purposes only.**

All data, insights, business scenarios, and analytics presented in this demonstration project have been artificially generated using AI. The data does not represent actual business information, performance metrics, customer data, or operational statistics.

### Key Points:

- **Synthetic Data**: All datasets are computer-generated and designed to illustrate analytical capabilities
- **Illustrative Analysis**: Insights and recommendations are examples of the types of analysis possible with Posit tools
- **No Actual Business Data**: No real business information or data was used or accessed in creating this demonstration
- **Educational Purpose**: This project serves as a technical demonstration of data science workflows and reporting capabilities
- **AI-Generated Content**: Analysis, commentary, and business scenarios were created by AI for illustration purposes
- **No Real-World Implications**: The scenarios and insights presented should not be interpreted as actual business advice or strategies

This demonstration showcases how Posit's data science platform and open-source tools can be applied to the coffee retail industry. The synthetic data and analysis provide a foundation for understanding the potential value of implementing similar analytical workflows with actual business data.

For questions about adapting these techniques to your real business scenarios, please contact your Posit representative.
---

*This demonstration was created using Posit's commercial data science tools and open-source packages. All synthetic data and analysis are provided for evaluation purposes only.*
