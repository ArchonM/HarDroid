#!/bin/bash

java -cp $1 weka.core.converters.CSVLoader $2 -B 10000 -L "label:malware,benign"> $3;