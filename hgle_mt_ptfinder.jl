function main()
    person_file_name        = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    output_file_name        = "hgle_mt_ptset.csv"
    person_file             = open(person_file_name, "r") 
    output_file             = open(output_file_name, "w")
    write(output_file, "person_id,age \n")

    readline(person_file)  # skips header

    for line in eachline(person_file) 
        line_part_array = split(line, ",")

        pt_id             = line_part_array[1]
        year_of_birth     = parse(Int, line_part_array[3])

        #println(year_of_birth)
        pt_age = 2026 - year_of_birth

        #println(pt_age)

        if pt_age == 42
            write(output_file, "$pt_id, $pt_age \n")
        end
    end

    close(person_file)
    close(output_file)

end

main()