

echo "/well/oncology/users/matteodg/git/Multiple_phen_tester/MPT.sh \
--chromlist /well/oncology/users/matteodg/Projects/ArrayGenerator/results/2019-06-11_phen_interaction/Chrom_list.txt \
--phen Breast_GWAS,23101-0_0-Whole_body_fat-free_mass \
--outstring WBFFMxBreast \
--snplist /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/data/2018-12-12_breast-prostate-colorectal/Breast_gwascat_match_No_QC_Balrog.txt \
--bgen /well/ukbb-wtchg/v3/imputation/ \
--sample /well/oncology/users/matteodg/Projects/PhenoScan/results/2019-04-01-UKB-24899-PhenoScan_sample/ \
--DIR /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/results/Breast-body-interaction/snptest_out/" \
| qsub -N WFFM-breast -t 1-23 -o /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/qlogs/Breast/MPT/snptest -cwd -V -P oncology.prjc -q short.qc -j y -b n
