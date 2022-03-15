from curses import raw
from operator import index
import sys
import os
from numpy import NaN
import pandas as pd
import warnings

combined_set_csv_dir = "../src_file/raw/combined_set.csv";
clean_combined_set_csv_dir = "../src_file/clean/combined_set.csv";
combined_set_arff_dir = "../src_file/clean/combined_set.arff";

training_set_csv_dir = "../src_file/raw/training_set.csv";
clean_training_set_csv_dir = "../src_file/clean/training_set.csv";
training_set_arff_dir = "../src_file/clean/training_set.arff";

testing_set_csv_dir  = "../src_file/raw/testing_set.csv";
clean_testing_set_csv_dir  = "../src_file/clean/testing_set.csv";
testing_set_arff_dir = "../src_file/clean/testing_set.arff";

weka_jar = "/home/ning/weka-3-8-5/weka.jar";

def clean_data_set(input_file, output_file):
    df = pd.read_csv(input_file);
    df = df.drop(columns=["Unnamed: 0", "package_name"]);
    df.to_csv(output_file, index=False);

def init_train():
    os.system("sh auto_train.sh " + training_set_arff_dir);

def init():
    clean_data_set(combined_set_csv_dir, clean_combined_set_csv_dir);
    os.system("sh csv2arff.sh " + weka_jar + " " + clean_combined_set_csv_dir + " " + combined_set_arff_dir);
    clean_data_set(training_set_csv_dir, clean_training_set_csv_dir);
    os.system("sh csv2arff.sh " + weka_jar + " " + clean_training_set_csv_dir + " " + training_set_arff_dir);
    clean_data_set(testing_set_csv_dir, clean_testing_set_csv_dir);
    os.system("sh csv2arff.sh " + weka_jar + " " + clean_testing_set_csv_dir + " " + testing_set_arff_dir);
    init_train();


def raw_to_csv(ori_file, dst_file):
    content = "";
    
    with open(ori_file, 'r') as f:
        buf = f.readline();
        while buf:
            buf = f.readline();
            if "Predictions on test data" in buf:
                buf = f.readline();
                buf = f.readline();
                while len(buf)>1:
                    content = content + buf;
                    buf = f.readline();
           
    with open(dst_file, 'w') as f:
        f.write(content);

def combine_pred_ori(ori_csv, pred_csv, dst_csv):
    ori_df = pd.read_csv(ori_csv);
    
    pred_df = pd.read_csv(pred_csv);
    if len(pred_df.index) == len(ori_df.index):
        result_df = pd.concat([ori_df, pred_df], axis=1);
        result_df.to_csv(dst_csv, index=False);
    else:
        print("Error: prediction files does not match raw file");
        print(ori_csv);
        print(pred_csv);
        
def retrain_remove_worng_pred(file_path):
    df = pd.read_csv(file_path);
    for index, row in df.iterrows():
        if row['label']=="malware":
            if row['error'] is not NaN:
                df = df.drop(index)
    df.to_csv(file_path, index=False);
    
def clean_retrain_prepared(file_path):
    df = pd.read_csv(file_path);
    df = df.drop(columns=["inst#","actual","predicted","error","prediction"])
    df.to_csv(file_path, index=False);

def retrain_prepare():
    raw_to_csv("../output/raw/BayesNet_train", "../src_file/trained/BayesNet_pred.csv");
    raw_to_csv("../output/raw/J48_train", "../src_file/trained/J48_pred.csv");
    raw_to_csv("../output/raw/PART_train", "../src_file/trained/PART_pred.csv");
    combine_pred_ori("../src_file/clean/training_set.csv", "../src_file/trained/BayesNet_pred.csv", "../src_file/trained/BayesNet_pretrained.csv");
    combine_pred_ori("../src_file/clean/training_set.csv", "../src_file/trained/J48_pred.csv", "../src_file/trained/J48_pretrained.csv");
    combine_pred_ori("../src_file/clean/training_set.csv", "../src_file/trained/PART_pred.csv", "../src_file/trained/PART_pretrained.csv");
    retrain_remove_worng_pred("../src_file/trained/BayesNet_pretrained.csv");
    retrain_remove_worng_pred("../src_file/trained/J48_pretrained.csv");
    retrain_remove_worng_pred("../src_file/trained/PART_pretrained.csv");
    clean_retrain_prepared("../src_file/trained/BayesNet_pretrained.csv");
    clean_retrain_prepared("../src_file/trained/J48_pretrained.csv");
    clean_retrain_prepared("../src_file/trained/PART_pretrained.csv");
    os.system("sh csv2arff.sh " + weka_jar + " " + "../src_file/trained/BayesNet_pretrained.csv" + " " + "../src_file/trained/BayesNet_pretrained.arff");
    os.system("sh csv2arff.sh " + weka_jar + " " + "../src_file/trained/J48_pretrained.csv" + " " + "../src_file/trained/J48_pretrained.arff");
    os.system("sh csv2arff.sh " + weka_jar + " " + "../src_file/trained/PART_pretrained.csv" + " " + "../src_file/trained/PART_pretrained.arff");
    
    
def retrain():
    os.system("java -cp $WEKA_JAR weka.classifiers.bayes.BayesNet -t ../src_file/trained/BayesNet_pretrained.arff -T ../src_file/clean/testing_set.arff -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 -o -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 > ../output/retrained/BayesNet_retrain")
    os.system("java -cp $WEKA_JAR weka.classifiers.trees.J48 -C 0.25 -M 2 -t ../src_file/trained/J48_pretrained.arff -T ../src_file/clean/testing_set.arff -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 > ../output/retrained/J48_retrain")
    os.system("java -cp $WEKA_JAR weka.classifiers.rules.PART -C 0.25 -M 2 -t ../src_file/trained/PART_pretrained.arff -T ../src_file/clean/testing_set.arff -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 > ../output/retrained/PART_retrain")

def calc_accuracy_filtered(file_path):
    filter_value = 2;
    df = pd.read_csv(file_path);
    result_dict = {};
    for index, row in df.iterrows():
        if not row['package_name'] in result_dict:
            result_dict[row['package_name']] = [row['label']];
            result_dict[row['package_name']].append(0);

        if "malware" in row['predicted']:
            result_dict[row['package_name']][1] += 1;

    mal_t = 0;
    mal_f = 0;
    ben_t = 0;
    ben_f = 0;
    mal_total = 0;
    ben_total = 0;
    for key in result_dict.keys():
        if result_dict[key][0] == "malware":
            mal_total += 1;
            if result_dict[key][1] > filter_value:
                mal_t += 1;
            else:
                mal_f += 1;
        elif result_dict[key][0] == "benign":
            ben_total += 1;
            if result_dict[key][1] > filter_value:
                ben_f += 1;
            else:
                ben_t += 1;
        else:
            warnings.warn("Unrecognized item in result_dict: " + result_dict[key][0]);

    print("mal_t: "+str(mal_t));
    print("mal_f: "+str(mal_f));
    print("ben_t: "+str(ben_t));
    print("ben_f: "+str(ben_f));
    print("total: "+str(len(result_dict)));

def calc_accuracy_instance_level(file_path):
    df = pd.read_csv(file_path);
    mal_t = 0;
    mal_f = 0;
    ben_t = 0;
    ben_f = 0;
    mal_total = 0;
    ben_total = 0;
    for index, row in df.iterrows():
        if row['label'] == "benign":
            if row['error'] is not NaN:
                mal_f += 1;
            else:
                mal_t += 1;
        else:
            if row['error'] is not NaN:
                ben_f += 1;
            else:
                ben_t += 1;
    
    mal_total = mal_f+mal_t;
    ben_total = ben_t+ben_f;
    print("mal_t: "+str(mal_t));
    print("mal_f: "+str(mal_f));
    print("ben_t: "+str(ben_t));
    print("ben_f: "+str(ben_f));
    

def post_process():
    raw_to_csv("../output/retrained/BayesNet_retrain", "../output/retrained/BayesNet_retrain.csv");
    raw_to_csv("../output/retrained/J48_retrain", "../output/retrained/J48_retrain.csv");
    raw_to_csv("../output/retrained/PART_retrain", "../output/retrained/PART_retrain.csv");
    combine_pred_ori("../src_file/raw/testing_set.csv", "../output/retrained/BayesNet_retrain.csv", "../output/BayesNet_result.csv");
    combine_pred_ori("../src_file/raw/testing_set.csv", "../output/retrained/J48_retrain.csv", "../output/J48_result.csv");
    combine_pred_ori("../src_file/raw/testing_set.csv", "../output/retrained/PART_retrain.csv", "../output/PART_result.csv");

def test():
    os.system("sh csv2arff.sh " + weka_jar + " " + training_set_csv_dir + " " + training_set_arff_dir);

def main():
    init();
    retrain_prepare();
    retrain();
    post_process();
    calc_accuracy_filtered("../output/BayesNet_result.csv");
    calc_accuracy_filtered("../output/J48_result.csv");
    calc_accuracy_filtered("../output/PART_result.csv");
    calc_accuracy_instance_level("../output/BayesNet_result.csv");
    calc_accuracy_instance_level("../output/J48_result.csv");
    calc_accuracy_instance_level("../output/PART_result.csv");


if __name__ == "__main__":
    main();