%let pgm=utl-using-dosubl-to-exceute-r-for-each-row-in-a-dataset;

github
https://tinyurl.com/22c327fn
https://github.com/rogerjdeangelis/utl-using-dosubl-to-exceute-r-for-each-row-in-a-dataset

Using dosubl to exceute R for each row in a dataset.
Should work with drop downs to other languages.

PROBLEM

   For rows with 'GeeksforSAS' and 'GeeksfoWPS' change the strings to 'BooksforSAS' and BooksforWPS by dropping down to R.

Quentin provides better ways to interface with dosubl in his paper.
https://support.sas.com/resources/papers/proceedings20/4958-2020.pdf

I also have related repos here an at the end of this post
github
https://github.com/rogerjdeangelis/utl-twelve-interfaces-for-dosubl
https://github.com/rogerjdeangelis/utl_dosubl_subroutine_interfaces  /*---- uses common block of storage ----*/
https://github.com/rogerjdeangelis/utl_sharing_a_block_of_memory_with_dosubl
https://github.com/rogerjdeangelis/utl_passing-in-memory-sas-objects-to-and-from-dosubl

You may see a early warning about unresolved macro variable, eventually it will be resolved.

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

libname sd1 "d:/sd1";
data sd1.have;
  input strInp $11.;
cards4;
GeeksforSAS
GeeksforWPS
;;;;
run;quit;

/**************************************************************************************************************************/
/*                       |               |                                                                                */
/* INPUT                 |  OUTPUT       |                                                                                */
/*                       |               |                                                                                */
/* SD1.HAVE total obs=2  |               |                                                                                */
/*                       |               |                                                                                */
/* Obs      STRINP       |     STRINP    |  Process ignore case and change gee to B00 in R                                */
/*                       |               |                                                                                */
/*  1     GeeksforSAS    |   BooksforSAS |  prxchange = prxchange('s/^gee/Boo/i', -1',GeeksforSAS');                      */
/*  2     GeeksforWPS    |   BooksforWPS |                                                                                */
/*                       |               |                                                                                */
/**************************************************************************************************************************/

/*           _               _
  ___  _   _| |_ _ __  _   _| |_
 / _ \| | | | __| `_ \| | | | __|
| (_) | |_| | |_| |_) | |_| | |_
 \___/ \__,_|\__| .__/ \__,_|\__|
                |_|
*/

/**************************************************************************************************************************/
/*                                                                                                                        */
/* %let strOut=mty;  This parent macro variable will be updated by R                                                      */
/*                                                                                                                        */
/* and                                                                                                                    */
/*                                                                                                                        */
/* Up to 40 obs from SD1.WANT total obs=2                                                                                 */
/*                                                                                                                        */
/* Obs      STRINP       RC      STROUT                                                                                   */
/*                                                                                                                        */
/*  1     GeeksforSAS     0    BooksforSAS                                                                                */
/*  2     GeeksforWPS     0    BooksforWPS                                                                                */
/*                                                                                                                        */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

/*---- SETUP                                                             ----*/
proc datasets lib=sd1 nolist nodetails;
  delete want;
run;quit;

/*---- Not sure why sas create mutiple macro libs                        ----*/
proc datasets lib=work nolist nodetails mt=cat;
  delete sasmac1 sasmac2 sasmac3 sasmac4;
run;quit;

%symdel  strInp strOut prx strot  / nowarn;

/*---- I think yu need this global variable in the parent and child      ----*/
%let strOut=mty;

/*---- END SETUP                                                         ----*/


data sd1.want;

  set sd1.have;

  /*---- Pass this macro variable to R                                   ----*/
  call symputx('strInp',strInp);

  rc=dosubl(%tslit('
     %symdel  prx / nowarn;
     %utl_submit_r64x('
          prx<-gsub("^gee", "Boo", "&strInp", ignore.case = TRUE, perl=TRUE);
          prx;
          writeClipboard(prx);
     ',return=prx,resolve=Y);

     /*---- Replace the parent global macro variable in the parent       ----*/
     %let strOut=&prx;
   '));

   strOut = symget('strOut');

run;quit;

/*
 _ __ ___ _ __   ___  ___
| `__/ _ \ `_ \ / _ \/ __|
| | |  __/ |_) | (_) \__ \
|_|  \___| .__/ \___/|___/
         |_|
*/

https://github.com/rogerjdeangelis/Dynamic_variable_in_a_DOSUBL_execute_macro_in_SAS
https://github.com/rogerjdeangelis/utl-DOSUBL-running-sql-inside-a-datastep-to-check-if-variables-exist-in-another-table
https://github.com/rogerjdeangelis/utl-No-need-to-convert-your-datastep-code-to-macro-code-use-DOSUBL
https://github.com/rogerjdeangelis/utl-a-better-call-execute-using-dosubl
https://github.com/rogerjdeangelis/utl-academic-pipes-dosubl-open-defer-and-dropping-dowm-to-multiple-languages-in-one-datastep
https://github.com/rogerjdeangelis/utl-adding-female-students-to-an-all-male-math-class-using-sql-insert_and_dosubl
https://github.com/rogerjdeangelis/utl-append-and-split-tables-into-two-tables-one-with-common-variables-and-one-without-dosubl-hash
https://github.com/rogerjdeangelis/utl-applying-meta-data-and-dosubl-to-create-mutiple-subset-tables
https://github.com/rogerjdeangelis/utl-cleaner-macro-code-using-dosubl
https://github.com/rogerjdeangelis/utl-dosubl-a-more-powerfull-macro-sysfunc-command
https://github.com/rogerjdeangelis/utl-dosubl-and-do-over-as-alternatives-to-explicit-macros
https://github.com/rogerjdeangelis/utl-dosubl-more-precise-eight-byte-float-computations-at-macro-excecution-time
https://github.com/rogerjdeangelis/utl-dosubl-persistent-hash-across-datasteps-and-procedures
https://github.com/rogerjdeangelis/utl-dosubl-remove-text-within-parentheses-of-macro-variable-using-regex
https://github.com/rogerjdeangelis/utl-dosubl-using-meta-data-with-column-names-and-labels-to-create-mutiple-proc-reports
https://github.com/rogerjdeangelis/utl-drop-down-using-dosubl-from-sas-datastep-to-wps-r-perl-powershell-python-msr-vb
https://github.com/rogerjdeangelis/utl-embed-sql-code-inside-proc-report-using-dosubl
https://github.com/rogerjdeangelis/utl-error-checking-sql-and-executing-a-datastep-inside-sql-dosubl
https://github.com/rogerjdeangelis/utl-extracting-sas-meta-data-using-sas-macro-fcmp-and-dosubl
https://github.com/rogerjdeangelis/utl-in-memory-hash-output-shared-with-dosubl-hash-subprocess
https://github.com/rogerjdeangelis/utl-let-dosubl-and-the-sas-interpreter-work-for-you
https://github.com/rogerjdeangelis/utl-load-configuation-variable-assignments-into-an-sas-array-macro-and-dosubl
https://github.com/rogerjdeangelis/utl-loop-through-one-table-and-find-data-in-next-table--hash-dosubl-arts-transpose
https://github.com/rogerjdeangelis/utl-macro-klingon-solution-or-simple-dosubl-you-decide
https://github.com/rogerjdeangelis/utl-macro-with-dosubl-to-compute-last-day-of-month
https://github.com/rogerjdeangelis/utl-maitainable-macro-function-code-using-dosubl
https://github.com/rogerjdeangelis/utl-passing-a-datastep-array-to-dosubl-squaring-the-elements-passing-array-back-to-parent
https://github.com/rogerjdeangelis/utl-potentially-useful-dosubl-interface
https://github.com/rogerjdeangelis/utl-re-ordering-variables-into-alphabetic-order-in-the-pdv-macros-dosubl
https://github.com/rogerjdeangelis/utl-rename-variables-with-the-same-prefix-dosubl-varlist
https://github.com/rogerjdeangelis/utl-sas-array-macro-fcmp-or-dosubl-take-your-choice
https://github.com/rogerjdeangelis/utl-select-high-payment-periods-and-generating-code-with-do_over-and-dosubl
https://github.com/rogerjdeangelis/utl-some-interesting-applications-of-dosubl
https://github.com/rogerjdeangelis/utl-transpose-multiple-rows-into-one-row-do_over-dosubl-and-varlist-macros
https://github.com/rogerjdeangelis/utl-twelve-interfaces-for-dosubl
https://github.com/rogerjdeangelis/utl-use-dosubl-to-save-your-format-code-inside-proc-report
https://github.com/rogerjdeangelis/utl-using-dosubl-and-a-dynamic-arrays-to-add-new-variables
https://github.com/rogerjdeangelis/utl-using-dosubl-to-avoid-klingon-obsucated-macro-coding
https://github.com/rogerjdeangelis/utl-using-dosubl-to-avoid-macros-and-add-an-error-checking-log
https://github.com/rogerjdeangelis/utl-using-dosubl-with-data-driven-business-rules-to-split-a-table
https://github.com/rogerjdeangelis/utl-using-dynamic-tables-to-interface-with-dosubl
https://github.com/rogerjdeangelis/utl_avoiding_macros_and_call_execute_by_using_dosubl_with_log
https://github.com/rogerjdeangelis/utl_dosubl_do_regressions_when_data_is_between_dates
https://github.com/rogerjdeangelis/utl_dosubl_macros_to_select_max_value_of_a_column_at_datastep_execution_time
https://github.com/rogerjdeangelis/utl_dosubl_subroutine_interfaces
https://github.com/rogerjdeangelis/utl_dynamic_subroutines_dosubl_with_error_checking
https://github.com/rogerjdeangelis/utl_overcoming_serious_deficiencies_in_call_execute_with_dosubl
https://github.com/rogerjdeangelis/utl_pass_character_and_numeric_arrays_to_dosubl
https://github.com/rogerjdeangelis/utl_passing-in-memory-sas-objects-to-and-from-dosubl
https://github.com/rogerjdeangelis/utl_read_all_datasets_in_a_library_and_conditionally_split_them_with_error_checking_dosubl
https://github.com/rogerjdeangelis/utl_sharing_a_block_of_memory_with_dosubl
https://github.com/rogerjdeangelis/utl_using_dosubl_instead_of_a_macro_to_avoid_numeric_truncation
https://github.com/rogerjdeangelis/utl_using_dosubl_to_avoid_klingon_macro_quoting_functions
https://github.com/rogerjdeangelis/utl_why_proc_import_export_needs_to_be_deprecated_and_dosubl_acknowledged

/*     _   _               _               _ _             __   _  _
 _   _| |_| |    ___ _   _| |__  _ __ ___ (_) |_     _ __ / /_ | || |__  __
| | | | __| |   / __| | | | `_ \| `_ ` _ \| | __|   | `__| `_ \| || |\ \/ /
| |_| | |_| |   \__ \ |_| | |_) | | | | | | | |_    | |  | (_) |__   _>  <
 \__,_|\__|_|___|___/\__,_|_.__/|_| |_| |_|_|\__|___|_|   \___/   |_|/_/\_\
           |_____|                             |_____|
*/

%macro utl_submit_r64x(
      pgmx
     ,resolve=N
     ,return=
     )/des="Semi colon separated set of R commands - drop down to R";
  %utlfkil(%sysfunc(pathname(work))/r_pgm.txt);
  /* clear clipboard */
  filename _clp clipbrd;
  data _null_;
    file _clp;
    put " ";
  run;quit;
  * write the program to a temporary file;
  filename r_pgm "%sysfunc(pathname(work))/r_pgm.txt" lrecl=32766 recfm=v;
  data _null_;
    length pgm $32756;
    file r_pgm;
    if substr(upcase("&resolve"),1,1)="Y" then do;
        pgm=resolve(&pgmx);
     end;
    else do;
        pgm=&pgmx;
     end;
     if index(pgm,"`") then cmd=tranwrd(pgm,"`","27"x);
    put pgm;
    putlog pgm;
  run;
  %let __loc=%sysfunc(pathname(r_pgm));
  * pipe file through R;
  filename rut pipe "D:\r412\R\R-4.1.2\bin\R.exe --vanilla --quiet --no-save < &__loc";
  data _null_;
    file print;
    infile rut recfm=v lrecl=32756;
    input;
    put _infile_;
    putlog _infile_;
  run;
  filename rut clear;
  filename r_pgm clear;
  * use the clipboard to create macro variable;
  %if "&return" ^= "" %then %do;
    filename clp clipbrd ;
    data _null_;
     infile clp;
     input;
     putlog "macro variable &return = " _infile_;
     call symputx("&return.",_infile_,"G");
    run;quit;
  %end;
%mend utl_submit_r64x;



/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
