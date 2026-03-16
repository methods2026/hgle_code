# hgle_asg5.jl
# program for asg5 methods spring 2026
# 2026-03-15

function main()

    # greet user
    println("hello! I will count race for type 2 diabetus mellitus")

    # define file names
    condition_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/condition_occurrence.csv"
    person_file_name    = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    output_file_name    = "hgle_asg5_output.txt"

    # create file handles 
    condition_file    = open(condition_file_name, "r")
    person_file       = open(person_file_name, "r")
    output_count_file = open(output_file_name, "w")

    # define dx code for T2DM 
    dx_code = ["201826", "192279"]

    # create pt_id_set
    pt_id_set = Set()

    println("I am going to look up patients who have Dx codes $(dx_code[1]) or $(dx_code[2])")

    # read throught the condition file and store patient ids for where they have the Dx
    for condition_file_line in eachline(condition_file)
        
        # split line into an ARRAY
        line_part_array = split(condition_file_line, ",")

        condition_code = line_part_array[3]
        pt_id          = line_part_array[2]

        # if the condition code mathces the dx_code,
        # push the patient id into the set
        if condition_code in dx_code

            push!(pt_id_set, pt_id)

        end

    end

    #println(pt_id_set)
    number_patients = length(pt_id_set)
    println("I found $number_patients patients with T2DM!!!!!")

    # create lookup dictionaries
    race_dict = Dict()

    # add lookip values to dictionaries
    race_dict["8515"] = "Asian"
    race_dict["8516"] = "Black or African American"
    race_dict["8527"] = "White"
    race_dict["0"]    = "Unknown"

    race_count_dict = Dict()

    # read through the person file
    for person_file_line in eachline(person_file)
        
        # split the line 
        line_part_array = split(person_file_line, ",")

        # get pt id
        pt_id = line_part_array[1]
        
        if in(pt_id, pt_id_set)

            # pull the race codes
            # println(line_part_array[7])
            race_code = line_part_array[7]

            println("for patient $pt_id, the race_code is $race_code")

            race_string = race_dict[race_code]

            println("for patient $pt_id, the race_string is $race_string")
            
            # increment race dictionary counter accordingly
            if haskey(race_count_dict, race_string)
                race_count_dict[race_string] +=1
            else
                race_count_dict[race_string] = 1
            end

        end

    end

    for race in keys(race_count_dict)
        output_string = "$race|$(race_count_dict[race])\n"
        print(output_string)
        print(output_count_file, output_string)
    end

end

main()