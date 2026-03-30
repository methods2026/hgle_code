# pipeline 1 : create data extracts

function main()
    println("program start!")

    # create dx and rx sets
    dxid_set = Set(["192289", "201826"])
    rxid_set = Set(["40163924", "19009384"])

    # create sets to keep track of patients
    ptid_dx_set = Set()
    ptid_rx_set = Set()

    # file names for dx and rx
    condition_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/condition_occurrence.csv"
    drug_file_name      = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/drug_exposure.csv"

    # file handles for dx and rx
    condition_file = open(condition_file_name, "r")
    drug_file      = open(drug_file_name, "r")

    for line in Iterators.drop(eachline(condition_file), 1) # skips first line of file
        line_part_array = split(line, ",")

        pt_id = line_part_array[2]
        dx_id = line_part_array[3]

        if dx_id in dxid_set
            push!(ptid_dx_set, pt_id)
        end

    end

    # report the number of patients with dx
    println("number of pts with dx: $(length(ptid_dx_set))")

    for line in Iterators.drop(eachline(drug_file),1)
        line_part_array = split(line, ",")
        
        pt_id = line_part_array[2]
        rx_id = line_part_array[3]

        if rx_id in rxid_set
            push!(ptid_rx_set, pt_id)
        end

    end

    println("number of pts with rx is: $(length(ptid_rx_set))")

    # take intersection of dx and rx
    intersection_pt_set = intersect(ptid_dx_set, ptid_rx_set)

    println("number in the intersection is: $(length(intersection_pt_set))")

    # create patient data extract files
    output_patient_extract_file_name = "hgle_t2dm_patient_extract.csv"
    output_patient_extract_file      = open(output_patient_extract_file_name, "w")

    # define and open person file
    patient_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    patient_file      = open(patient_file_name, "r")

    println(output_patient_extract_file, "pt_id,pt_yob,pt_gender_cid,pt_race_cid,pt_eth_cid")

    for line in Iterators.drop(eachline(patient_file),1)
        line_part_array = split(line, ",")

        pt_id         = line_part_array[1]
        pt_yob        = line_part_array[3]
        pt_gender_cid = line_part_array[2]
        pt_race_cid   = line_part_array[7]
        pt_eth_cid    = line_part_array[8]

        if pt_id in intersection_pt_set
            println(output_patient_extract_file, "$pt_id,$pt_yob,$pt_gender_cid,$pt_race_cid,$pt_eth_cid")
        end

    end

    close(patient_file)
    close(output_patient_extract_file)

    output_dx_extract_file_name = "hgle_t2dm_dx_extract.csv"
    output_dx_extract_file      = open(output_dx_extract_file_name, "w")

    # resets condition_file handle
    condition_file = open(condition_file_name, "r")

    println(output_dx_extract_file, "pt_id,dx_year,dx_id")

    for line in Iterators.drop(eachline(condition_file),1)
        line_part_array = split(line, ",")

        pt_id = line_part_array[2]
        dx_id = line_part_array[3]
        dx_year = split(line_part_array[4], "-")[1]

        if pt_id in intersection_pt_set
            println(output_dx_extract_file, "$pt_id,$dx_year,$dx_id")
        end
    end
    close(condition_file)
    close(output_dx_extract_file)

    output_rx_extract_file_name = "hgle_t2dm_rx_extract.csv"
    output_rx_extract_file      = open(output_rx_extract_file_name, "w")

    # resets condition_file handle
    drug_file = open(drug_file_name, "r")

    println(output_rx_extract_file, "pt_id,rx_year,rx_id")

    for line in Iterators.drop(eachline(drug_file),1)
        line_part_array = split(line, ",")

        pt_id = line_part_array[2]
        rx_id = line_part_array[3]
        rx_year = split(line_part_array[4], "-")[1]

        if pt_id in intersection_pt_set
            println(output_rx_extract_file, "$pt_id,$rx_year,$rx_id")
        end
    end
    close(drug_file)
    close(output_rx_extract_file)

end

main()