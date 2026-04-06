# midterm for Methods_2026 spring (python)

import pandas as pd

def main():
    print("Hi! this is my code for the midterm python section")

    # define file names
    condition_file_name     = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/condition_occurrence.csv"
    person_file_name        = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    output_season_file_name = "hgle_midterm_py_season_counts.txt"

    # create file handles 
    condition_file     = open(condition_file_name, "r")
    person_file        = open(person_file_name, "r")
    output_season_file = open(output_season_file_name, "w")

    # define gender_concept_id code for male and female 
    male_code   = "8507" 
    female_code = "8532" 

    # create dictionary for individuals per season
    group_dict = {} 

    print(f"I am going to look up patients who have gen codes {male_code, female_code} for each season")

    person_file.readline() # skips the first line of the file

    # read throught the condition file and store patient ids for where they match the gender_concept_id
    # with the associated season the month is in
    for line in person_file:

        line = line.rstrip("\n")
        
        # split line by comma
        line_part_array = line.split(",")
        
        # pull pt id, gender, and month of birth
        pt_id             = line_part_array[0]
        gender_concept_id = line_part_array[1]
        month_of_birth    = line_part_array[3]

        # maps the gender codes to male or female
        if gender_concept_id == male_code:
            gender = "male"
        else:
            gender = "female"

        # checks the season each associated month_of_birth is in
        if month_of_birth in ("12", "1", "2"):
            season = "Winter"
        elif month_of_birth in ("3", "4", "5"):
            season = "Spring"
        elif month_of_birth in ("6", "7", "8"):
            season = "Summer"
        else: 
            season = "Fall"

        # creates an empty set if the season|gender pairing is not in the dict already,
        # otherwise adds person to the season|gender pairing
        gender_season_key = season + "|" + gender

        if gender_season_key not in group_dict:
            group_dict[gender_season_key] = set()

        group_dict[gender_season_key].add(pt_id)
    
    person_file.close()

    print("Season|{M,F,M+F}|Count")

    # loops through all seasons and outputs the gender counts per sesaon
    for season in ["Winter", "Spring", "Summer", "Fall"]:
        male_key   = season + "|" + "male"
        female_key = season + "|" + "female"

        male_count    = len(group_dict.get(male_key, dict()))
        females_count = len(group_dict.get(female_key, dict()))

        output_season_file.write(f"{season}|M|{male_count}\n")
        output_season_file.write(f"{season}|F|{females_count}\n")
        output_season_file.write(f"{season}|M+F|{male_count + females_count}\n")

    output_season_file.close()
    
    # --------------------------------------------------
    # this section finds the top 5 conditions per season
    output_condition_file_name = "hgle_midterm_py_season_counts_dx.txt"
    output_condition_file = open(output_condition_file_name, "w")

    # opens the condition file as a df
    condition_df = pd.read_csv(condition_file)
    condition_df["person_id"] = condition_df["person_id"].astype(str) # converts person_id to str

    # b/c of how season|gender keys are coded, they need to be split to count the total 
    # conditions per season for both genders
    season_conditions_dict = {}
    for key in group_dict:
        season, gender = key.split("|")

        # adds the season into the season dict if not already
        if season not in season_conditions_dict:
            season_conditions_dict[season] = set()

        season_conditions_dict[season].update(group_dict[key])    
    
    # loops through all seasons and finds the person_ids associated with them,
    # and finds the rows associated with them and then counts the top 5 conditions
    for season in season_conditions_dict:
        person_ids = season_conditions_dict[season]

        # ensures row is assoicated with persons of interest
        condition_subdict = condition_df[condition_df["person_id"].isin(person_ids)]

        # counts the top 5 condition_concept_ids
        top_5_conditions = condition_subdict["condition_concept_id"].value_counts().head(5)

        # takes the rows in the condition df and formats it into a printable version 
        lines = [
            f"{season}|{cond_id}|{count}"
            for cond_id, count in top_5_conditions.items()
        ]

        # outputs lines to file
        for line in lines:
            output_condition_file.write(f"{line}\n")

    condition_file.close()
    output_condition_file.close()

main()