# program3.py
# Dataframe using Pandas

import pandas as pd 

def main():
    print("Hi! this is my cool pandas program!")

    person_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    patient_df       = pd.read_csv(person_file_name)

    print(patient_df.describe())

    # select first 7 rows (all columns)
    print("first seven rows (all columns)")
    print(patient_df.iloc[7])
    #print(patient_df.iloc[:7])

    # retrieves race/eth concept_ids
    unique_race_concept_ids      = patient_df["race_concept_id"].unique()
    unique_ethnicity_concept_ids = patient_df["ethnicity_concept_id"].unique()

    # convert the unique values to sets
    race_set      = set(unique_race_concept_ids)
    ethnicity_set = set(unique_ethnicity_concept_ids)

    # take the union of the race and ethnicity sets
    race_ethnicity_set = race_set | ethnicity_set

    # print out set and their union
    print(f"race set:       {race_set}")
    print(f"ethnicity set:  {ethnicity_set}")
    print(f"union set:      {race_ethnicity_set}")

    # retrieve all unique values in birth month and load into a set
    unique_months = patient_df["month_of_birth"].unique()
    month_set     = set(unique_months)
    print(f"unique birth months: {month_set}")

    # report count patients born per month
    for month in month_set:
        month_df = patient_df[patient_df["month_of_birth"] == month]
        print(f"num patients in {month}: {len(month_df)}")

    # create dictionary to map month numbers to month names
    month_dict = {
        1: "Jan", 
        2: "Feb", 
        3: "Mar", 
        4: "Apr", 
        5: "May", 
        6: "Jun", 
        7: "Jul", 
        8: "Aug", 
        9: "Sep", 
        10: "Oct", 
        11: "Nov", 
        12: "Dec" 
    }

    # create report range
    month_array = range(6,9)

    # report count of patients per selected range month
    for month in month_array:
        month_df = patient_df[patient_df["month_of_birth"] == month]
        print(f"[SUM] num patients in {month_dict[month]}: {len(month_df)}")

    # find the top 3 months of birth
    top_months = patient_df.groupby("month_of_birth").size().reset_index(name="count")
    sorted_months = top_months.sort_values("count", ascending=False)

    # print out the top 7
    for _, row in sorted_months.head(7).iterrows():
        month = row["month_of_birth"]
        count = row["count"]
        print(f"For {month}: there are {count} patients")

main()