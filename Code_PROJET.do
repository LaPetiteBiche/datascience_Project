// Join 2 .dta file with same iso_code using seconddatafile

joinby iso_code using Quaterly_covid_stats, unm(m)
drop _merge

// My y - not useful

 egen id = group(countrycode)
 drop if year <2010
 drop if year > 2020
 xtset id year
 by id: gen Ldgp = L.gdp_growth
 by id: egen mean_2010_2019 = mean(Ldgp)
 by id: keep if _n==_N
 gen change_in_gdp = - (mean_2010_2019 - gdp_growth)
 
 
 // If multiple date and want to keep only last row by country
 
 egen id = group(iso_code)
 gen date4 =date(date,"YMD")
 format date4 %td
 drop if missing(total_cases)
drop if total_cases == 0
sort id date4
by id : keep if _n==_N

//winsor

winsor change_in_gdp, gen(temp) p(0.02)
replace change_in_gdp = temp
drop temp

//panel by continent exemple

egen id_cont = group(continent)
xtset id_cont
xtreg change_in_gdp death_cov per_trav_tour_gdp per_rur

//xtset, clear to close panel reg

// Useful for worldbank dataset, keep v64 or v63, v62 , the one with more data

keep v2 v64
rename v2 iso_code
rename v64 whatyouwanttonameit

//Some regressions

reg change_in_gdp death_cov per_trav_tour_gdp per_rur
reg change_in_gdp death_cov per_trav_tour_gdp asia oceania
reg change_in_gdp death_cov per_trav_tour_gdp per_rur unemp_per if sa == 1
reg change_in_gdp death_cov per_trav_tour_gdp expo_GS if eu == 1
reg change_in_gdp death_cov per_trav_tour_gdp per_rur expo_GS unemp_per if eu == 1


