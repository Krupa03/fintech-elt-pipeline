# Databricks notebook source
# ============================================================
# 01_ingest_raw_data
# Read CSVs from Unity Catalog Volume → create Delta tables
# ============================================================

# Paths
VOLUME_PATH = "/Volumes/workspace/default/fintech_raw"

# Read transactions
df_transactions = spark.read.format("csv") \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .load(f"{VOLUME_PATH}/train_transaction.csv")

# Read identity
df_identity = spark.read.format("csv") \
    .option("header", "true") \
    .option("inferSchema", "true") \
    .load(f"{VOLUME_PATH}/train_identity.csv")

print(f"Transactions: {df_transactions.count()} rows")
print(f"Identity: {df_identity.count()} rows")

# COMMAND ----------

# ============================================================
# Write to Delta tables in Unity Catalog
# ============================================================

# Create schema
spark.sql("CREATE SCHEMA IF NOT EXISTS workspace.fintech")

# Write transactions
df_transactions.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.fintech.raw_transactions")

# Write identity
df_identity.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("workspace.fintech.raw_identity")

print("Delta tables created successfully")
spark.sql("SHOW TABLES IN workspace.fintech").show()