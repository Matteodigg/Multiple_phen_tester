

#########################################################################
## Define qsub variables                                                #
#########################################################################


#########################################################################
## Example run                                                          #
#########################################################################

# EXAMPLE RUN:

#echo "/well/bond/users/matteodg/Projects/Multiple_phen_tester/MPT.sh \
#--chromlist /well/oncology/users/matteodg/Projects/ArrayGenerator/results/2019-06-11_phen_interaction/Chrom_list.txt \
#--phen Breast_GWAS 23101-0_0-Whole_body_fat-free_mass \
#--outstring WBFFMxBreast \
#--snplist /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/data/2018-12-12_breast-prostate-colorectal/Breast_gwascat_match_No_QC_Balrog.txt \
#--bgen /well/ukbb-wtchg/v3/imputation/ \
#--sample /well/oncology/users/matteodg/Projects/PhenoScan/results/2019-04-01-UKB-24899-PhenoScan_sample/ \
#--DIR /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/results/Breast-body-interaction/snptest_out/" \
#| qsub -N WFFM-breast -t 1-23 -o /well/oncology/users/matteodg/Projects/SNP-wide/qlogs/snptest/ -cwd -V -P oncology.prjc -q short.qc -j y -b n


#########################################################################
## Define the command line arguments                                    #
#########################################################################

HELP () {

echo -e "\n\nMPT (Multiple phenotypes tester) by Matteo Di Giovannantonio. This tool use snptest on SGE for running multivariate analysis on UKB.\n"
echo -e "USAGE:     bash MPT.sh [OPTION(s)]\n
OPTIONS:\n

--h, --help          Print this HELP.

--chromlist  [String]    Path to chrom list array to be included in the SNP-wise analysis.\n\n

--snplist  [String]    Path to SNP list to be included in the SNP-wise analysis.\n\n

--phen  [String]    Phenotype to be tested. Same name of the header section. Multiple phen can be tested. (write as csv values).\n\n

--outstring  [String]    string to be added to the output file.\n\n

--bgen  [String]    Path to the directory containing bgen folders (chr1 - 22 - X - XY).\n\n

--sample  [String]    Path to the directory containing sample files.\n\n

--DIR, --outDIR [String]   Path to out folder. Please, note that this should be the main folder path\n\n"

}


if [ "$#" == "0" ]
then
    echo "\nERROR: No INPUT command(s). To read the HELP type [-h] [--help] option.\n"
    exit 1;
else
    while [[ $# -gt 0 ]]
    do
    key="$1"
    case $key in
        --chromlist)
        ChromList="$2"
        shift # past argument
        ;;
        --snplist)
        snplist="$2"
        shift # past argument
        ;;
        --phen)
        phen="$2"
        shift # past argument
        ;;
        --outstring)
        outstring="$2"
        shift # past argument
        ;;
        --B|--bgen)
        bgen_dir="$2"
        shift # past argument
        ;;
        --s|--sample)
        sample_dir="$2"
        shift # past argument
        ;;
        --DIR|--outDIR)
        OUTDIR="$2"
        shift # past argument
        ;;
        --h|--help)
        HELP
        exit 1;
        ;;
        --default)
        DEFAULT=1
        ;;
        *)
        echo "ERROR: Wrong command(s). To read the HELP type [-h] [--help] option."
        exit 1;
        ;;
    esac
    shift 
    done
fi


#########################################################################
## Define INPUT variables (chrom and phen files)                        #
#########################################################################

SECONDS=0

number=$SGE_TASK_ID

CHR=`sed -n ${number}p $ChromList | awk '{print $1}'`

new_phen=$(echo $phen | tr "," " ")


#########################################################################
## Executing the program                                                #
#########################################################################

echo -e "\n###################################################\n"
echo -e "###################################################\n"
echo -e "#############----- $CHR-----##############\n"
echo -e "###################################################\n"
echo -e "###################################################\n\n"

if [ $CHR = "X" ] ; then

    /apps/well/bgenix/20160708/bgenix $bgen_dir/ukb_imp_chr$CHR\_v3.bgen -incl-rsids $snplist | \
    /apps/well/snptest/2.5.4-beta3_CentOS6.6_x86_64_dynamic/snptest_v2.5.4-beta3 \
    -filetype bgen \
    -data - $sample_dir/UKB-24899-phen-X-QC.sample \
    -bayesian 1 \
    -method expected \
    -mpheno $new_phen \
    -o $OUTDIR/chr$CHR.$outstring.out \
    -include_samples /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/data/2019-04-09_Additional_files/List_of_people_in_epid_study/QC_INCLUDE_epid/Post_menopausal_breast_Cox_QC.txt \
    -stratify_on sex \
    -prior_qt_mean_b 0 \
    -prior_qt_V_b 0.02 \
    -prior_mqt_c 6 \
    -prior_mqt_Q 4 \
    -cov_names 21022-0_0-Age_at_recruitment 22009-0_1-Genetic_principal_components 22009-0_2-Genetic_principal_components \
    22009-0_3-Genetic_principal_components 22009-0_4-Genetic_principal_components 22009-0_5-Genetic_principal_components \
    22009-0_6-Genetic_principal_components 22009-0_7-Genetic_principal_components 22009-0_8-Genetic_principal_components \
    22009-0_9-Genetic_principal_components 22009-0_10-Genetic_principal_components

elif [ $CHR = "XY" ] ; then

    /apps/well/bgenix/20160708/bgenix $bgen_dir/ukb_imp_chr$CHR\_v3.bgen -incl-rsids $snplist | \
    /apps/well/snptest/2.5.4-beta3_CentOS6.6_x86_64_dynamic/snptest_v2.5.4-beta3 \
    -filetype bgen \
    -data - $sample_dir/UKB-24899-phen-Y-QC.sample \
    -bayesian 1 \
    -method expected \
    -mpheno $new_phen \
    -o $OUTDIR/chr$CHR.$outstring.out \
    -prior_qt_mean_b 0 \
    -prior_qt_V_b 0.02 \
    -prior_mqt_c 6 \
    -prior_mqt_Q 4 \
    -include_samples /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/data/2019-04-09_Additional_files/List_of_people_in_epid_study/QC_INCLUDE_epid/Post_menopausal_breast_Cox_QC.txt \
    -cov_names 21022-0_0-Age_at_recruitment 22009-0_1-Genetic_principal_components 22009-0_2-Genetic_principal_components \
    22009-0_3-Genetic_principal_components 22009-0_4-Genetic_principal_components 22009-0_5-Genetic_principal_components \
    22009-0_6-Genetic_principal_components 22009-0_7-Genetic_principal_components 22009-0_8-Genetic_principal_components \
    22009-0_9-Genetic_principal_components 22009-0_10-Genetic_principal_components


else

    /apps/well/bgenix/20160708/bgenix $bgen_dir/ukb_imp_chr$CHR\_v3.bgen -incl-rsids $snplist | \
    /apps/well/snptest/2.5.4-beta3_CentOS6.6_x86_64_dynamic/snptest_v2.5.4-beta3 \
    -filetype bgen \
    -data - $sample_dir/UKB-24899-phen-autosome-QC-Breast-cont.sample \
    -bayesian 1 \
    -method expected \
    -mpheno $new_phen \
    -o $OUTDIR/chr$CHR.$outstring.out \
    -prior_qt_mean_b 0 \
    -prior_qt_V_b 0.02 \
    -prior_mqt_c 6 \
    -prior_mqt_Q 4 \
    -include_samples /well/oncology/users/matteodg/Projects/UKB_obesity_GWAS/data/2019-04-09_Additional_files/List_of_people_in_epid_study/QC_INCLUDE_epid/Post_menopausal_breast_Cox_QC.txt \
    -cov_names 21022-0_0-Age_at_recruitment 22009-0_1-Genetic_principal_components 22009-0_2-Genetic_principal_components \
    22009-0_3-Genetic_principal_components 22009-0_4-Genetic_principal_components 22009-0_5-Genetic_principal_components \
    22009-0_6-Genetic_principal_components 22009-0_7-Genetic_principal_components 22009-0_8-Genetic_principal_components \
    22009-0_9-Genetic_principal_components 22009-0_10-Genetic_principal_components

fi

duration=$SECONDS
echo "$(($duration / 60)) minutes and $(($duration % 60)) seconds elapsed."