# program 2 -- data structures!

function main()

    # greet user
    println("hello! I will count ethnicity and gener for anemia")

    # define file names
    condition_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/condition_occurrence.csv"
    person_file_name    = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    output_file_name    = "hgle_dx_counts.txt"

    # create file handles 
    condition_file    = open(condition_file_name, "r")
    person_file       = open(person_file_name, "r")
    output_count_file = open(output_file_name, "w")

    # define dx code for anemia 
    dx_code = "439777" 

    # create pt_id_set
    pt_id_set = Set()

    println("I am going to look up patients who have Dx code $dx_code")

    # read throught ht econdition file and store patient ids for where they have the Dx
    for condition_file_line in eachline(condition_file)
        
        # split line into an ARRAY
        line_part_array = split(condition_file_line, ",")

        condition_code = line_part_array[3]
        pt_id          = line_part_array[2]

        # if the condition code mathces the dx_code,
        # push the patient id into the set
        if condition_code == dx_code

            push!(pt_id_set, pt_id)

        end

    end

    #println(pt_id_set)
    number_patients = length(pt_id_set)
    println("I found $number_patients patients with anemia!!!!!")

    # create lookup dictionaries
    gender_dict    = Dict()
    ethnicity_dict = Dict()

    # add lookip values to dictionaries
    gender_dict["8507"] = "Male"
    gender_dict["8532"] = "Female"

    ethnicity_dict["38003563"] = "Hispanic"
    ethnicity_dict["38003564"] = "Non-Hispanic"

    gender_count_dict    = Dict()
    ethnicity_count_dict = Dict()

    # read through the person file
    for person_file_line in eachline(person_file)
        
        # split the line 
        line_part_array = split(person_file_line, ",")

        # get pt id
        pt_id = line_part_array[1]

        if in(pt_id, pt_id_set)

            # pull the gender & ethnicity codes
            gender_code    = line_part_array[2]
            ethnicity_code = line_part_array[8]

            println("for patient $pt_id, the gender code is $gender_code and eth_code is $ethnicity_code")

            gender_string    = gender_dict[gender_code]
            ethnicity_string = ethnicity_dict[ethnicity_code]

            println("for patient $pt_id, the gender code is $gender_string and eth_code is $ethnicity_string")
            
            # increment gender dictionary counter accordingly
            if !haskey(gender_count_dict, gender_string)
                gender_count_dict[gender_string] = 1
            else
                gender_count_dict[gender_string] +=1
            end

            if haskey(ethnicity_count_dict, ethnicity_string)
                ethnicity_count_dict[ethnicity_string] +=1
            else
                ethnicity_count_dict[ethnicity_string] = 1
            end
        end

    end

    for gender in keys(gender_count_dict)
        output_string = "$gender|$(gender_count_dict[gender])\n"
        print(output_string)
        print(output_count_file, output_string)
    end

    for ethnicity in keys(ethnicity_count_dict)
        output_string = "$ethnicity|$(ethnicity_count_dict[ethnicity])\n"
        print(output_string)
        print(output_count_file, output_string)
    end
end

main()