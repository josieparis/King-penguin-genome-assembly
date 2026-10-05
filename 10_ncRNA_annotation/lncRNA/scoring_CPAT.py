#!/usr/bin/env python3
# [original] local: <path>/scoring_CPAT.python - majority rule over the ORFs of each transcript (CPAT coding probability < 0.4 = non-coding ORF)
import pandas as pd

# Load the data
df = pd.read_csv("CPAT_PLEK_CPC2_file.tsv", sep="\t")

# Count occurrences of "yes" and "no" for each ID
coding_counts = df.groupby("ID")["coding prob < 0.4"].value_counts().unstack(fill_value=0)

# Determine whether "coding" or "non-coding" based on majority rule
df["coding_status"] = df["ID"].map(lambda x: "coding" if coding_counts.loc[x, "no"] > coding_counts.loc[x, "yes"] else "non-coding")

# Save the modified dataframe
df.to_csv("output.tsv", sep="\t", index=False)

print(df)
