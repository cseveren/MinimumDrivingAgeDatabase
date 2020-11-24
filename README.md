# Minimum Driving Age Database

Christopher Severen ([website](https://cseveren.github.io)), with assistance from  PJ Elliott and support from the Research Library at the Federal Reserve Bank of Philadelphia.

[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4289086.svg)](https://doi.org/10.5281/zenodo.4289086)

This is a database of Minimum Driving Ages in the United States that is meant cover the formative driving years of most current drivers. Currently, the database attempts to accurately cover state driving license regulations from 1967 to 2015. The database is meant to make publically available a supplement to other sources of data about driver licensing ages (see below) that have more limited coverage.

The primary data file for public use is `/output/assembled_panel.xlsx`, and suggested code for using this is under `/postprocessing/` (currently only Stata code is provided; I hope to provide R code as well). 

### Sources

Sources used are list below. This is currently only a partial list; a more complete list yet needs to be compiled from the supporting materials. 

There are two primary data sources:
1. The Federal Highway Administration’s (FHWA) *Driver License Administration Requirements and Fees* booklets. These were published roughly biennially; we have found and processed volumes from 1967, 1972, 1980, 1982, 1984, 1986, 1988, 1994 and 1996. Where there are changes in between these years, we have tried to fill in the gaps with various sources, including legislative documents, state department of transportation records, and newspaper articles. 

2. The Insurance Institute of Highway Safety’s (IIHS) database on graduated driver licensing programs, which they provided the authors upon request.

We also pull a few statistics from other sources to help fill in gaps in FHWA and IIHS reporting; pdf’s are included where permitted:

3. Williams, Allan F., Anne T. McCartt, and Laurel B. Sims. "History and current status of state graduated driver licensing (GDL) laws in the United States." *Journal of Safety Research* 56 (2015): 9-15.

4. Williams, Allan F., and David F. Preusser. "Night driving restrictions for youthful drivers: a literature review and commentary." *Journal of Public Health Policy* 18, no. 3 (1997): 334-345.

5. Williams, Allan F., Karen Weinberg, Michele Fields, and Susan A. Ferguson. "Current requirements for getting a drivers license in the United States." *Journal of Safety Research* 27, no. 2 (1996): 93-101.

6. Florida Department of Highway Safety and Motor Vehicles, “Historical Timeline: Division of Driver Licenses.” Accessed 2/21/2019 at https://flhsmv.gov/pdf/about/history/DDLtimeline.pdf

7. “Idaho to Change Legal Driving Age From 14 to 16 Years in September,” *Deseret News* April 16, 1989. Accessed February 21, 2019 at https://www.deseret.com/1989/4/16/18802852/idaho-to-change-legal-driving-age-from-14-to-16-years-in-september

8. “Idaho Driving Age Decrease to 15,” *Deseret News* March 22, 1991. Accessed February 21, 2019 at https://www.deseret.com/1991/3/22/18911588/idaho-driving-age-decreases-to-15

9. Senate Proposal 277 – Legislative Document 841, Second Regular Session of 116th Legislature (Maine 1994). LexisNexis, 1994 Me. SP 277.

### Processing

The document called `assembled_panel` is hand assembled from the above sources, with additional notes and justification provided where necessary in the `Summary` document. I hope to provide much more extensive documentation.
