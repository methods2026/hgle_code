# methods program 2 -- data structures! (in python)

def main():

    # greet user
    print(f"hello! I will count ethnicity and gener for anemia")

    # define file names
    condition_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/condition_occurrence.csv"
    person_file_name    = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/person.csv"
    output_file_name    = "hgle_dx_counts-py.txt"

    # create file handles 
    condition_file    = open(condition_file_name, "r")
    person_file       = open(person_file_name, "r")
    output_count_file = open(output_file_name, "w")

    # define dx code for anemia 
    dx_code = "439777" 

    # create pt_id_set
    pt_id_set = set()

    print(f"I am going to look up patients who have Dx code {dx_code}")

    # read throught ht econdition file and store patient ids for where they have the Dx
    for line in condition_file:

        line = line.rstrip("\n")
        
        # split line by comma
        line_part_array = line.split(",")
        
        # pull pt id and concept id
        pt_id           = line_part_array[1]
        condition_code = line_part_array[2]

        # if the condition code mathces the dx_code,
        # add the patient id into the set
        if condition_code == dx_code:
            pt_id_set.add(pt_id)


    #print(pt_id_set)
    number_patients = len(pt_id_set)
    print(f"I found {number_patients} patients with anemia!!!!!")

    # create lookup dictionaries
    gender_dict    = {}
    ethnicity_dict = {}

    # add lookip values to dictionaries
    gender_dict["8507"] = "Male"
    gender_dict["8532"] = "Female"

    ethnicity_dict["38003563"] = "Hispanic"
    ethnicity_dict["38003564"] = "Non-Hispanic"

    gender_count_dict    = {}
    ethnicity_count_dict = {}

    # read through the person file
    for line in person_file:
        
        line = line.rstrip("\n")
        
        # split line by comma
        line_part_array = line.split(",")

        # get pt id
        pt_id = line_part_array[0]

        if pt_id in pt_id_set:

            # pull the gender & ethnicity codes
            gender_code    = line_part_array[1]
            ethnicity_code = line_part_array[7]

            print(f"for patient {pt_id}, the gender code is {gender_code} and eth_code is {ethnicity_code}")

            gender_string    = gender_dict[gender_code]
            ethnicity_string = ethnicity_dict[ethnicity_code]

            print(f"for patient {pt_id}, the gender code is {gender_string} and eth_string is {ethnicity_string}")
            
            # increment gender dictionary counter accordingly
            if gender_string not in gender_count_dict.keys():
                gender_count_dict[gender_string] = 1
            else:
                gender_count_dict[gender_string] +=1
            
            if ethnicity_string in ethnicity_count_dict.keys():
                ethnicity_count_dict[ethnicity_string] +=1
            else:
                ethnicity_count_dict[ethnicity_string] = 1

    for gender in gender_count_dict.keys():
        output_string = f"{gender}|{gender_count_dict[gender]}\n"
        print(output_string)
        output_count_file.write(output_string)

    for ethnicity in ethnicity_count_dict.keys():
        output_string = f"{ethnicity}|{ethnicity_count_dict[ethnicity]}\n"
        print(output_string)
        output_count_file.write(output_string)

main()