def main():
    drug_exposure_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/drug_exposure.csv"
    drug_exposure_file      = open(drug_exposure_file_name, "r")

    pt_set_file_name = "/oscar/data/class/biol1555_2555/hgle/code/hgle_mt_ptset.csv"
    pt_set_file      = open(pt_set_file_name, "r")

    output_file_name = "hgle_mt_rxset.csv"
    output_file      = open(output_file_name, "w")

    pt_set = set()

    pt_set_file.readline()
    for line in pt_set_file:

        line = line.rstrip("\n")
        
        # split line by comma
        line_part_array = line.split(",")
        
        # pull pt id and age
        pt_id  = line_part_array[0]

        pt_set.add(pt_id)

    output_file.write(f"person_id,drug_concept_id,drug_exposure_start_date,drug_exposure_end_date\n")

    drug_exposure_file.readline()
    for line in drug_exposure_file: 
        
        line = line.rstrip("\n")
        
        # split line by comma
        line_part_array = line.split(",")

        drug_exposure_id = line_part_array[0]
        person_id        = line_part_array[1]
        drug_concept_id  = line_part_array[2]
        drug_exposure_start_date = line_part_array[3]
        drug_exposure_end_date = line_part_array[5]

        if person_id in pt_set:
            output_file.write(f"{person_id},{drug_concept_id},{drug_exposure_start_date},{drug_exposure_end_date}\n")

    drug_exposure_file.close()
    pt_set_file.close()
    output_file.close()

main()