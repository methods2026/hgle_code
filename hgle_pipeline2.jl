# second program in pipeline -- create the dataset in a single file

using DataFrames, CSV

function main()
    println("pipeline 2")

    vocab_file_name = "/oscar/data/shared/ursa/synthetic_ri/vocab_omop_subset/demo_concept_updated.csv"
    vocab_file      = open(vocab_file_name, "r")

    concept_lookup_dict = Dict()

    # create dictionary where key is id and concept_stringis value
    for line in Iterators.drop(eachline(vocab_file), 1)

        concept_id, concept_string, concept_domain = split(line, ",")
        concept_lookup_dict[concept_id]            = concept_string

    end

    #value = 8507
    #println("the value for 8507 is: $(concept_lookup_dict[value])")

    # define the three input files
    pt_extract_file_name = "hgle_t2dm_patient_extract.csv"
    rx_extract_file_name = "hgle_t2dm_rx_extract.csv"
    dx_extract_file_name = "hgle_t2dm_dx_extract.csv"

    pt_df = DataFrame(CSV.File(pt_extract_file_name))
    rx_df = DataFrame(CSV.File(rx_extract_file_name))
    dx_df = DataFrame(CSV.File(dx_extract_file_name))

    dx_counts = combine(groupby(dx_df, :dx_id), nrow => :count)
    rx_counts = combine(groupby(rx_df, :rx_id), nrow => :count)

    top_5_dx = sort(dx_counts, :count, rev=true)[1:5, :]
    top_5_rx = sort(rx_counts, :count, rev=true)[1:5, :]

    println("top 5 dx: ")
    println(top_5_dx)
    println("top 5 rx: ")
    println(top_5_rx)

    output_patient_analytic_file_name = "hgle_t2dm_analytic_dataset.csv"
    output_patient_analytic_file      = open(output_patient_analytic_file_name, "w")

    print(output_patient_analytic_file, "pt_id,yob,gender,ethnicity,race")
    
    for dx_id in top_5_dx.dx_id
        print(output_patient_analytic_file, ",$dx_id")
    end

    for rx_id in top_5_rx.rx_id
        print(output_patient_analytic_file, ",$rx_id")
    end

    println(output_patient_analytic_file)

    for row in eachrow(pt_df)
        print(output_patient_analytic_file, "$(row.pt_id),$(row.pt_yob),$(concept_lookup_dict[string(row.pt_gender_cid)]),$(concept_lookup_dict[string(row.pt_race_cid)]),$(concept_lookup_dict[string(row.pt_eth_cid)])")

        for dx_id in top_5_dx.dx_id 
            if row.pt_id in dx_df.pt_id[dx_df.dx_id .== dx_id]
                print(output_patient_analytic_file, ",1")
            else
                print(output_patient_analytic_file, ",0")
            end

        end

        for rx_id in top_5_rx.rx_id 
            if row.pt_id in rx_df.pt_id[rx_df.rx_id .== rx_id]
                print(output_patient_analytic_file, ",1")
            else
                print(output_patient_analytic_file, ",0")
            end

        end

        println(output_patient_analytic_file)

    end

end

main()