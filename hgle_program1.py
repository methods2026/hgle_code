# methods2026 program 1 in python!

def main():
    # greet user
    print("hello! welcome to SBP pop analyzer!!!")

    # get user's name
    user_name = input("what is your name? ")

    print(f"Thanks, {user_name}... let's get started")

    # get target SBP
    target_sbp = float(input("enter target SBP for population (mmHg): "))

    if target_sbp > 120:
        print(">>> OK. but note that is higher than the standard of 120...")

    # ask for allowable variance percentage 
    var_perc = float(input("enter allowable variance perc (%): "))

    # calculate hi and lo targets
    hi_target_sbp = target_sbp + (target_sbp *(var_perc/100))
    lo_target_sbp = target_sbp - (target_sbp *(var_perc/100))

    # indicate to the user what the range is
    print(f"target range is {lo_target_sbp} - {hi_target_sbp}")

    # define the file names
    measurement_file_name = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/measurement.csv"
    detail_output_file_name = "hgle_sbp_detail_results.txt"
    summary_output_file_name = "hgle_sbp_summary_results.txt"

    measurement_file    = open(measurement_file_name,    "r")
    detail_output_file  = open(detail_output_file_name,  "w")
    summary_output_file = open(summary_output_file_name, "a")

    # create counters
    hi_sbp_count = 0
    lo_sbp_count = 0
    in_sbp_count = 0

    for line in measurement_file:
        
        line = line.rstrip("\n")
        
        # split line by comma
        line_part_array = line.split(",")
        
        # pull pt id and concept id
        pt_id           = line_part_array[1]
        omop_concept_id = line_part_array[2]

        # process lines that have SBP (concept_id 3004249)
        if omop_concept_id == "3004249":

            # pull the value 
            value = float(line_part_array[8])

            # categorize the value
            if value >= hi_target_sbp:
                detail_output_file.write(f"{pt_id}|{value}|HI")
                hi_sbp_count += 1
            elif value <= lo_target_sbp:
                detail_output_file.write(f"{pt_id}|{value}|LO")
                lo_sbp_count += 1
            else:
                detail_output_file.write(f"{pt_id}|{value}|IN")
                in_sbp_count += 1    

    #print out summary
    print(f"--- Summary for {user_name}")
    print(f"sbp|{lo_sbp_count}-{hi_target_sbp}|{in_sbp_count}|{hi_sbp_count}|{lo_sbp_count}")

    summary_output_file.write(f"sbp|{lo_sbp_count}-{hi_target_sbp}|{in_sbp_count}|{hi_sbp_count}|{lo_sbp_count}\n")

    # close 
    measurement_file.close()
    detail_output_file.close()
    summary_output_file.close()

# call main function
main()