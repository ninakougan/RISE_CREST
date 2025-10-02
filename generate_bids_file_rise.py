# -*- coding: utf-8 -*-
import os
import json
import csv

def find_dates():
    csv_file = "/projects/b1108/studies/rise/scripts/rise-qc-log.csv"
    partic_list = {}
    with open(csv_file) as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        #skip header
        next(reader, None) 
        for row in reader:
            partic_id = row[0]
            if(not partic_id in partic_list.keys()):
                partic_list[partic_id] = row[1]   
    return partic_list


def scans_to_file(partic, date, log_file):
    #set working dir
    work_dir = "/projects/b1108/data/RISE/sub-" + partic \
                + "/ses-1/"
    #open file:
    log_file_path = work_dir + log_file
    with open(log_file_path, 'w') as logfile:
        print(log_file_path) 
        logfile.write("filname\tacq_time\n")
        #iterate through scans and add line to .tsv file
        for scan in os.listdir(work_dir):
            print(work_dir + scan)
            if(os.path.isdir(work_dir + scan)):
                for file in os.listdir(work_dir + scan):   
                    #check to make sure it's a .json\
                    if("json" in file):      
                        # Opening JSON file
                        f = open(work_dir + scan + '/' + file)
                        # returns JSON object as dict
                        data = json.load(f)
                        # Get aquisition time
                        time = data['AcquisitionTime']
                        nomiltime = time.split(".")[0]
                        # Closing file
                        f.close()
                        #write to logfile
                        datetime = date + "T" + nomiltime
                        line = scan + "/" + file + "\t" + datetime + "\n"
                        logfile.write(line)
        logfile.close()

def main(): 
    pd_dict = find_dates()
    for partic, date in pd_dict.items():
        #format = sub-####_ses-1_scans.tsv
        file = "sub-" + partic + "_ses-1_scans.tsv"
        print(partic, date, file)
        scans_to_file(partic, date, file)



if __name__ == "__main__":
    main()