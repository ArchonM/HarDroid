#!/bin/bash


train_file="../src_file/training_set.arff";
combined_file="../src_file/combined_set.arff";
test_file="../src_file/testing_set.arff";
train_out_folder="../output/";
test_out_folder="../output/";
if [ ! -n "$2" ]; then
    train_out_folder="../output/raw/";
    echo "none";
fi


train_out=$train_out_folder"BayesNet_train";
test_out=$test_out_folder"BayesNet_test";
echo $train_out;

java -cp $WEKA_JAR weka.classifiers.bayes.BayesNet -t $1 -T $1 -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 -o -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 > $train_out
if [ -n "$2" ]; then
    java -cp $WEKA_JAR weka.classifiers.bayes.BayesNet -t $1 -T $2 -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 -o -D -Q weka.classifiers.bayes.net.search.local.K2 -- -P 1 -S BAYES -E weka.classifiers.bayes.net.estimate.SimpleEstimator -- -A 0.5 > $test_out
fi


train_out=$train_out_folder"J48_train";
test_out=$test_out_folder"J48_test";
echo $train_out;

java -cp $WEKA_JAR weka.classifiers.trees.J48 -C 0.25 -M 2 -t $1 -T $1 -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 > $train_out
if [ -n "$2" ]; then
    java -cp $WEKA_JAR weka.classifiers.trees.J48 -C 0.25 -M 2 -t $1 -T $2 -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 > $test_out
fi


train_out=$train_out_folder"PART_train";
test_out=$test_out_folder"PART_test";
echo $train_out;

java -cp $WEKA_JAR weka.classifiers.rules.PART -C 0.25 -M 2 -t $1 -T $1 -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 > $train_out
if [ -n "$2" ]; then
    java -cp $WEKA_JAR weka.classifiers.rules.PART -C 0.25 -M 2 -t $1 -T $2 -classifications weka.classifiers.evaluation.output.prediction.CSV -p 0 > $test_out
fi
