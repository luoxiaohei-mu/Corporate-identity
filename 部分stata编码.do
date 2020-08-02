///ʶ��ת����ҵ�����ֱ��룩

///һ������������ݣ��ò�ֲ�����0 �����ҵ���뷢���仯����ҵ
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
format %45s _ʡ��
format %10s _ʡ
format %20s _��
format %20s _��
format %55s _��ַ
order id code name year ind4a_11 dif_ind4a_11 dum_ind4a_11 
save b1_98-07,replace
///������һ���±�������ҵ�������¡�����ҵ��ʾ������1����ͳ��2��������
use b1_98-07,clear
gen int LB =1
replace LB=2	if	ind4a_11==	170
replace LB=2	if	ind4a_11==	519
replace LB=2	if	ind4a_11==	529
replace LB=2	if	ind4a_11==	530///��������滻����׸�����˴�ʡ��
label var LB "1��ʾ��ͳ��ҵ��2��ʾ������ҵ"
save b1_98-07_xj,replace
///������ǳ����ɴ�ͳ�����˱仯����ҵ
use b1_98-07_xj.dta,clear
order LB, before (ind4a_11)
gen int old_new=0
order old_new, before(_��ҵ��λ���)
local N=_N
forvalues i= `N'(-1)1{
   if id[`i'] == id[`i'+1]{///��֤ǰ�������۲�����ͬһ�ҹ�˾
       if dum_ind4a_11[`i'] != dum_ind4a_11[`i'+1] {///��֤ǰ�������۲���ҵ���뷢���仯
           if LB[`i'] == 1 & LB[`i'+1]==2{///��֤ǰһ���Ǿ���ҵ����һ��������ҵ
	           replace old_new = 1 in `i'/`=`i'+1'
		   }
	   }
   }
}

label var old_new "��ͳת���ˣ�1��0��"
save b2_98-07_xj,replace









