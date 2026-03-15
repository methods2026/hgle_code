# hgle _asg5.py
# program for asg5 methods spring 2026
# 2026-03-15
def main():

    print("Hi and welcome to the BMI population analyzer!")

    units = input("Please choose Metric or Imperial to begin: ")

    if units == "Metric":
      # ask user for a metric weight value 
      weight = float(input("Give me a weight in kilograms: "))

      # ask user for a metric height value 
      height = float(input("Give me a height in cm: "))

      # convert cm height to m height
      height = height/100

      # calculate bmi using metric units
      bmi_val = (weight / height ** 2) 

      # prints bmi value
      print(f"bmi is {bmi_val}")
    elif units == "Imperial":
      # ask user for a imperial weight value 
      weight = float(input("Give me a weight in pounds: "))

      # ask user for a imperial height value 
      height = float(input("Give me a height in inches: "))

      # calculate bmi using imperial units
      bmi_val = (weight / height ** 2) * 703

      # prints bmi value
      print(f"bmi is {bmi_val}")
    
    # determine weight status
    if bmi_val >= 40.0:
        upper_bound = float('inf')
        lower_bound = 40.0

        weight_status = "extreme or high risk obesity"
    elif bmi_val <= 39.9 and bmi_val > 30.0:
        upper_bound = 40.0
        lower_bound = 30.0

        weight_status = "obese"
    elif bmi_val <= 30.0 and bmi_val > 25.0:
        upper_bound = 30.0
        lower_bound = 25.0

        weight_status = "overweight"
    elif bmi_val <= 25.0 and bmi_val > 18.5:
        upper_bound = 25.0
        lower_bound = 18.5

        weight_status = "normal"
    else: 
        upper_bound = 18.5
        lower_bound = -float('inf')

        weight_status = "underweight"
    
    # prints weight status
    print(f"weight status is {weight_status}")

    # define file names
    measurement_file_name    = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/measurement.csv"
    detail_output_file_name  = "hgle_asg5_detail_results.txt"
    summary_output_file_name = "hgle_asg5_summary_results.txt"

    # create file handles
    measurement_file    = open(measurement_file_name,    "r")
    detail_output_file  = open(detail_output_file_name,  "w")
    summary_output_file = open(summary_output_file_name, "a")

    # create counters
    hi_bmi_count = 0
    in_bmi_count = 0

    # read file
    for line in measurement_file:

        line = line.rstrip("\n")
        
        # split line by comma
        line_part_array = line.split(",")
        
        # pull pt id and concept id
        pt_id           = line_part_array[1]
        omop_concept_id = line_part_array[2]

        # process lines that have BMI (concept_id 3038553)
        if omop_concept_id == "3038553":

            # retrieve value as a Float64
            value = float(line_part_array[8])

            # increment appropriate counter
            # and print out appropriate value to detail file
            if value >= upper_bound:
                hi_bmi_count += 1
                detail_output_file.write(f"{pt_id}|{value}|HI\n")
            elif value >= lower_bound and value <= upper_bound:
                in_bmi_count += 1
                detail_output_file.write(f"{pt_id}|{value}|IN\n")

    #print out summary
    print(f"{bmi_val}|{lower_bound}-{upper_bound}|{in_bmi_count}|{hi_bmi_count}")

    summary_output_file.write(f"{bmi_val}|{lower_bound}-{upper_bound}|{in_bmi_count}|{hi_bmi_count}\n")

    # close 
    measurement_file.close()
    detail_output_file.close()
    summary_output_file.close()

# call main function
main()

