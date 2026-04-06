# midterm for Methods_2026 spring (julia)

using CSV
using DataFrames

function main()
    println("Hi! this is my code for the midterm julia section")

    # define file names
    condition_file_name     = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/condition_occurrence.csv"
    person_file_name        = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    output_season_file_name = "hgle_midterm_jl_season_counts.txt"

    # define gender_concept_id codes
    male_code   = "8507"
    female_code = "8532"

    group_dict = Dict()

    println("I am going to look up patients who have gen codes $(male_code), $(female_code) for each season")

    person_file = open(person_file_name, "r") 
    readline(person_file)  # skips header

    # read throught the condition file and store patient ids for where they match the gender_concept_id
    # with the associated season the month is in
    for line in eachline(person_file) 
        line_part_array = split(line, ",")

        pt_id             = line_part_array[1]
        gender_concept_id = line_part_array[2]
        month_of_birth    = line_part_array[4]
        
        # maps gender codes to strings
        if gender_concept_id == male_code
            gender = "male"
        else
            gender = "female"
        end

        # maps month numbers to season string
        if month_of_birth in ("12", "1", "2")
            season = "Winter"
        elseif month_of_birth in ("3", "4", "5")
            season = "Spring"
        elseif month_of_birth in ("6", "7", "8")
            season = "Summer"
        else
            season = "Fall"
        end

        key = season * "|" * gender

        # creates set if season doesnt exist in dict, otherwise pushes pt_id into nested set
        if !haskey(group_dict, key)
            group_dict[key] = Set()
        end

        push!(group_dict[key], pt_id)
    end

    close(person_file)

    output_season_file = open(output_season_file_name, "w") 
    println("Season|{M,F,M+F}|Count")

    # loops through all seasons and outputs the gender counts per sesaon
    for season in ["Winter", "Spring", "Summer", "Fall"]
        male_key   = season * "|male"
        female_key = season * "|female"

        male_count   = length(get(group_dict, male_key, Set()))
        female_count = length(get(group_dict, female_key, Set()))

        write(output_season_file, "$season|M|$male_count\n")
        write(output_season_file, "$season|F|$female_count\n")
        write(output_season_file, "$season|M+F|$(male_count + female_count)\n")
    end

    close(output_season_file)

    # --------------------------------------------------
    # this section finds the top 5 conditions per season
    output_condition_file_name = "hgle_midterm_jl_season_counts_dx.txt"

    # reads in condition file as a dataframe and converts person_id into string (breaks pt lookup if not done)
    condition_df           =  DataFrame(CSV.File(condition_file_name))
    condition_df.person_id = string.(condition_df.person_id)

    # season => Set of person_ids
    season_conditions_dict = Dict()
    
    # b/c of how season|gender keys are coded, they need to be split to count the total 
    # conditions per season for both genders
    for (key, ids) in group_dict
        season, _ = split(key, "|")

        # adds the season into the season dict if not already
        if !haskey(season_conditions_dict, season)
            season_conditions_dict[season] = Set()
        end

        union!(season_conditions_dict[season], ids)
    end

    output_season_dx_file = open(output_condition_file_name, "w")

    # loops through all seasons and finds the person_ids associated with them,
    # and finds the rows associated with them and then counts the top 5 conditions
    for (season, person_ids) in season_conditions_dict
        # creates a mask to identify condition rows associated with wanted person_ids and subsets df
        mask   = in.(condition_df.person_id, Ref(person_ids))
        sub_df = condition_df[mask, :]

        # groups subset df by condition_concept_id to make it easier to count them
        grouped = groupby(sub_df, :condition_concept_id)

        # counts and sorts condition_concept_ids so largest is at the top
        condition_counts        = combine(grouped, nrow => :count)
        sorted_condition_counts = sort(condition_counts, :count, rev=true)

        # takes top 5 conditions in subset df
        n                = min(5, nrow(sorted_condition_counts))
        top_5_conditions = sorted_condition_counts[1:n, :]

        # writes top 5 conditions to file
        for row in eachrow(top_5_conditions)
            println(output_season_dx_file, "$season|$(row.condition_concept_id)|$(row.count)")
        end

    end

    close(output_season_dx_file)

end

main()