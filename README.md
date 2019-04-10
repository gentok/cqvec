## Combining Data Obtained from CQ Voting and Elections Collection

**Author** Gento Kato (gento.badgerATgmail.com)

### Description

Codes to combine election results data obtained from [CQ Voting and Elections Collection](http://library.cqpress.com/elections/).

### Get original datasets

This repository DOES NOT contain original datasets. To get original datasets, you need to have an access to [CQ Voting and Elections Collection](http://library.cqpress.com/elections/) and do one of follows:

1. Shoot an E-mail to an author (Gento Kato) with some proof that you have valid access right to download the data from [CQ Voting and Elections Collection](http://library.cqpress.com/elections/). The author may give out original datasets upon request. 

2. Follow the below procedure to get data:  
    1. Access [CQ Voting and Elections Collection](http://library.cqpress.com/elections/).
    2. Click on "DOWNLOAD DATA" tab on upper right-hand side.
    3. Search and download raw data files (in csv format) to appropriate folders with names following the rules below.
    4. The rule to name downloaded data files should follow "office_detail_year_states.csv" format with:
       1. "office" indicating type of office. One of "president", "house", "senate", "governor". The data should be stored in the folder with name of the office.
       2. "_detail" should be added if downloaded data is about county/district details. If you are downloading national summary, just drop "_detail" from the file name.
       3. "year" indicates year(s) of the file in four-digits (yyyy) form. If data spans across multiple years, it should be written as "XXXXtoYYYYY" where XXXX indicating the starting year and YYYY indicating the ending year (e.g., 1992to2000). 
       4. "_states" must be added if you are downloading detailed level data. If national summary, drop this part from the file name. Detailed data can only be downloaded in subsets (can include only up 10 states), so the name must be one of following six (the states in STATE field of search window must be alphabetically ordered):
        * "_ALtoGA" Alabama to Georgia (excluding District of Columbia)
        * "_HItoMD" Hawaii to Maryland
        * "_MAtoNJ" Massachusetts to New Jersey
        * "_NMtoSC" New Mexico to South Carolina
        * "_SDtoWY" South Dakota to Wyoming
        * "_DC" District of Columbia (only)

### Combining datasets

Use the following codes to combine data:

[CQ_VEC_combine_president.R](CQ_VEC_combine_president.R): Presidential election data from 2000 to 2016 (only from 2000 to 2012 for county level data).
[CQ_VEC_combine_president_wAlaska.R](CQ_VEC_combine_president_wAlaska.R): Add Alaska county level data to Presidential election data (see Notes on Alaska).
[CQ_VEC_combine_house.R](CQ_VEC_combine_house.R): House election data from 1992 to 2016.

### Resultant datasets

After executing codes, following files will be created.

* <code>cqvec_president_nation.rds</code>: National level election returns for US president, 2000 to 2016.
* <code>cqvec_president_state.rds</code>: State level election returns for US president, 2000 to 2016.
* <code>cqvec_president_county.rds</code>: County level election returns for US president (no county level returns for Alaska), 2000 to 2012.
* <code>cqvec_president_county_wAlaska.rds</code>: County level election returns for US president (Alaska included), 2000 to 2012.
* <code>cqvec_house_nation.rds</code>: National level election returns for US House, 1992 to 2016.
* <code>cqvec_house_state.rds</code>: State level election returns for US House, 1992 to 2016.
* <code>cqvec_house_district.rds</code>: Congressional district level election returns for US House, 1992 to 2016.

### Notes on Alaska

CQ Voting and Elections Collections do not contain county level election returns from the State of Alaska. For presidential elections, to supplement this missing data, I borrow the data published in [HERE](https://rrhelections.com/index.php/2018/02/02/alaska-results-by-county-equivalent-1960-2016/
) that are stored in "president_Alaksa" folder.

**License**: The programming code used to generate the result is licensed under the [MIT license](https://choosealicense.com/licenses/mit/).