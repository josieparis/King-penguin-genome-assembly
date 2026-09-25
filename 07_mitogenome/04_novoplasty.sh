#!/bin/bash
# [original] cluster: <path>/novoplasty.sh
#SBATCH -D . 
#SBATCH -p debug
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=200G
#SBATCH --time=8:00:00
#SBATCH --job-name=novoplasty_K04
#SBATCH --error=logs/novoplasty_K04.err.txt  
#SBATCH --output=logs/novoplasty_K04.out.txt  
#SBATCH --export=All

MASTER=<path>/K04_assembly

cd $MASTER


perl NOVOPlasty4.3.5.pl -c config.txt
