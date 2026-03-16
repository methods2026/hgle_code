# program 3 - Dataframes!!'

# include packages
using CSV, DataFrames

function main()
    println("This is going to be an aswesome use of DataFrames... REALY!!!")

    person_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"

    patient_df = DataFrame(CSV.File(person_file_name))

    println(describe(patient_df))
end

main()
