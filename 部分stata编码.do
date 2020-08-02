///识别转型企业（部分编码）

///一、生成面板数据，用差分不等于0 标记行业代码发生变化的企业
use p2_98-07,clear
rename id code
sort code
egen id=group( code )
order id code
xtset id year
xtdes
bysort id : gen dif_ind4a_11=D.ind4a_11
bysort id : drop if _N==1
replace dif_ind4a_11=0 if dif_ind4a_11==.
gen dum_ind4a_11=0
replace dum_ind4a_11=1 if dif_ind4a!=0
format %50s name
format %45s _省市
format %10s _省
format %20s _市
format %20s _县
format %55s _地址
order id code name year ind4a_11 dif_ind4a_11 dum_ind4a_11 
save b1_98-07,replace
///二、用一个新变量把行业代码是新、旧行业表示出来，1代表传统，2代表新兴
use b1_98-07,clear
gen int LB =1
replace LB=2	if	ind4a_11==	170
replace LB=2	if	ind4a_11==	519
replace LB=2	if	ind4a_11==	529
replace LB=2	if	ind4a_11==	530///多余代码替换不做赘述，此处省略
label var LB "1表示传统行业，2表示新兴行业"
save b1_98-07_xj,replace
///三、标记出了由传统向新兴变化的企业
use b1_98-07_xj.dta,clear
order LB, before (ind4a_11)
gen int old_new=0
order old_new, before(_企业单位类别)
local N=_N
forvalues i= `N'(-1)1{
   if id[`i'] == id[`i'+1]{///保证前后两个观测来自同一家公司
       if dum_ind4a_11[`i'] != dum_ind4a_11[`i'+1] {///保证前后两个观测行业代码发生变化
           if LB[`i'] == 1 & LB[`i'+1]==2{///保证前一个是旧行业，后一个是新行业
	           replace old_new = 1 in `i'/`=`i'+1'
		   }
	   }
   }
}

label var old_new "传统转新兴，1是0否"
save b2_98-07_xj,replace









