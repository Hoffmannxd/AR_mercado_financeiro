#!/bin/bash

#Rscript aquisitionv2.R <start date> <end date>

cd ../src/mdd/
#echo "Date arg: $1"
#echo "Delta arg: $2"
#echo "Idx arg: $3"
#ls
spark-submit --class "mddApp" --master local[4] target/scala-2.11/simple-project_2.11-1.0.jar "./../data/serieHistorica.csv"
