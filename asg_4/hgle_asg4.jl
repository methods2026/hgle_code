# hgle _asg4.jl
# program for asg4 methods spring 2026
# 2026-03-08
function main()

    println("Hi and welcome to the BMI population analyzer!")

    println("Please choose Metric or Imperial to begin.")
    units = readline(stdin)

    if units == "Metric"
      # ask user for a metric weight value 
      print("Give me a weight in kilograms.")
      weight = parse(Float64, readline(stdin))

      # ask user for a metric height value 
      print("Give me a height in cm.")
      height = parse(Float64, readline(stdin))

      # convert cm height to m height
      height = height/100

      # calculate bmi using metric units
      bmi_val = (weight / height ^ 2) 

      # prints bmi value
      println("bmi is $bmi_val")
    elseif units == "Imperial"
      # ask user for a imperial weight value 
      print("Give me a weight in pounds.")
      weight = parse(Float64, readline(stdin))

      # ask user for a imperial height value 
      print("Give me a height in inches.")
      height = parse(Float64, readline(stdin))

      # calculate bmi using imperial units
      bmi_val = (weight / height ^ 2) * 703

      # prints bmi value
      println("bmi is $bmi_val")
    end
    
    # determine weight status
    if bmi_val >= 40.0
        upper_bound = Inf
        lower_bound = 40.0

        weight_status = "extreme or high risk obesity"
    elseif bmi_val <= 39.9 && bmi_val > 30.0
        upper_bound = 40.0
        lower_bound = 30.0

        weight_status = "obese"
    elseif bmi_val <= 30.0 && bmi_val > 25.0
        upper_bound = 30.0
        lower_bound = 25.0

        weight_status = "overweight"
    elseif bmi_val <= 25.0 && bmi_val > 18.5
        upper_bound = 25.0
        lower_bound = 18.5

        weight_status = "normal"
    else 
        upper_bound = 18.5
        lower_bound = -Inf

        weight_status = "underweight"
    end
    
    # prints weight status
    println("weight status is $weight_status")

    # define file names
    measurement_file_name    = "/oscar/data/shared/ursa/synthetic_ri/demo_omop/measurement.csv"
    detail_output_file_name  = "hgle_asg4_detail_results.txt"
    summary_output_file_name = "hgle_asg4_summary_results.txt"

    # create file handles
    measurement_file    = open(measurement_file_name,    "r")
    detail_output_file  = open(detail_output_file_name,  "w")
    summary_output_file = open(summary_output_file_name, "a")

    # create counters
    hi_bmi_count = 0
    in_bmi_count = 0

    # read file
    for line in eachline(measurement_file)

        # split line on comma
        line_part_array = split(line, ",")

        # pull out pt_id and concept_id
        pt_id           = line_part_array[2]
        omop_concept_id = line_part_array[3]

        # process lines that have BMI (concept_id 3038553)
        if omop_concept_id == "3038553"

            # retrieve value as a Float64
            value = parse(Float64,line_part_array[9])

            # increment appropriate counter
            # and print out appropriate value to detail file
            if value >= upper_bound
                hi_bmi_count += 1
                print(detail_output_file, "$pt_id|$value|HI\n")
            elseif value >= lower_bound && value <= upper_bound
                in_bmi_count += 1
                print(detail_output_file, "$pt_id|$value|IN\n")
            end

        end

    end

    #print out summary
    println("$bmi_val|$lower_bound-$upper_bound|$in_bmi_count|$hi_bmi_count")
    print(summary_output_file, "$bmi_val|$lower_bound-$upper_bound|$in_bmi_count|$hi_bmi_count\n")

end

# call main function
main()

