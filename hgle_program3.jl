# program 3 - Dataframes!!'

# include packages
using CSV, DataFrames

function main()
    println("This is going to be an aswesome use of DataFrames... REALY!!!")

    person_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"

    patient_df = DataFrame(CSV.File(person_file_name))

    # println(describe(patient_df))

    # print out the first 7 rows (all columns)
    #println("print out the first 7 rows")
    #println(patient_df[1:7,:])
    #println(first(patient_df, 7))

    #=
    unique_race_concept_ids = unique(patient_df.race_concept_id)
    unique_ethnicity_concept_ids = unique(patient_df.ethnicity_concept_id)

    race_set = Set(unique_race_concept_ids)
    ethnicity_set = Set(unique_ethnicity_concept_ids)

    race_ethnicity_set = union(race_set, ethnicity_set)

    println("race set: $race_set")
    println("ethnicity set: $ethnicity_set")
    println("union set: $race_ethnicity_set")
    =#
    
    # retrieves all the unique calues of brith month into a set
    unique_months = unique(patient_df.month_of_birth)
    println(unique_months)

    #=
    # report count of patients per month
    for month in unique_months

        month_df = patient_df[patient_df.month_of_birth .== month, :]
        println("number of patients in $month: $(nrow(month_df))")
        
    end
    =#

        month_dict = Dict(1 => "Jan", 
                          2 => "Feb", 
                          3 => "Mar", 
                          4 => "Apr", 
                          5 => "May", 
                          6 => "Jun", 
                          7 => "Jul", 
                          8 => "Aug", 
                          9 => "Sep", 
                          10 => "Oct", 
                          11 => "Nov", 
                          12 => "Dec")

    for month in unique_months

        month_df = patient_df[patient_df.month_of_birth .== month, :]
        println("number of patients in $(month_dict[month]): $(nrow(month_df))")

    end

    month_array = 1:12

    for month in month_array

        month_df = patient_df[patient_df.month_of_birth .== month, :]
        println("number of patients in $(month_dict[month]): $(nrow(month_df))")

    end

    # report top 5 months of birth
    top_months = combine(groupby(patient_df, :month_of_birth), nrow => :count)
    sorted_months = sort(top_months, :count, rev=true)
    
    for row in eachrow(first(sorted_months, 5))
        month = row.month_of_birth
        count = row.count

        println("For $month, there are $count patients")
    end

end

main()
