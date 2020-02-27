select count(distinct A.PUBLN_NR) from TEMP_R1_MATCHED_ALL_UTIL2 A; -- 692840


--기술별 0711 특허 (1200s) / 1213 / 1416 -> xls로 복붙.
select t901.TECHN_FIELD_NR, count(distinct t211a.publn_nr) as grants0711
from temp_r1_0711_stdname_index std, TLS211_PAT_PUBLN_US t211a, TLS227_PERS_PUBLN t227a, TLS209_APPLN_IPC t209, TLS901_TECHN_FIELD_IPC t901
where t211a.PUBLN_DATE >= '2007-01-01' and t211a.PUBLN_DATE <= '2011-12-31'
and t211a.pat_publn_id = t227a.pat_publn_id
and t227a.person_id = std.person_id
and t211a.publn_kind in ('B1','B2','E')
and t227a.INVT_SEQ_NR = '0'
and t209.APPLN_ID = t211a.APPLN_ID
and t901.IPC_MAINGROUP_SYMBOL in (substr(t209.IPC_CLASS_SYMBOL,1,4), substr(t209.IPC_CLASS_SYMBOL,1,8))
group by t901.TECHN_FIELD_NR;

select B.PUBLN_KIND, count(distinct B.PAT_PUBLN_ID) from TEMP_R1_USPA_T211_GRT_TECH_CVG A, TLS211_PAT_PUBLN_US B
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID group by B.PUBLN_KIND; -- 378845

select count(distinct B.PAT_PUBLN_ID) from TEMP_R1_USPA_T211_GRT_TECH_CVG A, TLS211_PAT_PUBLN_US B
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID
and B.PUBLN_KIND not in ('P2','P3'); -- 377802

select B.PUBLN_KIND, count(distinct B.PAT_PUBLN_ID) from TEMP_R1_USPA_TO_T211_GRT_UTIL2 A, TLS211_PAT_PUBLN_US B
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID group by B.PUBLN_KIND; -- 378020, 

select count(distinct A.PAT_PUBLN_ID) from TEMP_R1_USPA_T211_GRT_TECH_CVG A, TEMP_R1_USPA_TO_T211_GRT_UTIL2 B
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID; --378802


-- 잠시 도입 특허 자체의 통계 / tech_field 수준에서.
select B.TECHN_FIELD_NR, B.CVG, count(distinct B.DOC_NUMBER) as Acq
from TEMP_R1_USPA_T211_GRT_TECH_CVG B, TEMP_R1_USPA_TO_T211_GRT_UTIL2 A
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID
group by B.TECHN_FIELD_NR, B.CVg
order by B.TECHN_FIELD_NR, B.CVG;

-- 잠시 도입 특허 자체의 통계 / tech_field 수준에서.
select B.TECHN_FIELD_NR, B.CVG, count(distinct UPPER(REGEXP_REPLACE(B.NAME, '[[:punct:]]| ', ''))) as STD_NAME
from TEMP_R1_USPA_T211_GRT_TECH_CVG B, TEMP_R1_USPA_TO_T211_GRT_UTIL2 A
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID
group by B.TECHN_FIELD_NR, B.CVg
order by B.TECHN_FIELD_NR, B.CVG;
-- 잠시 도입 특허 자체의 통계 / tech_field 수준에서.
select B.TECHN_FIELD_NR, count(distinct UPPER(REGEXP_REPLACE(B.NAME, '[[:punct:]]| ', ''))) as STD_NAME
from TEMP_R1_USPA_T211_GRT_TECH_CVG B, TEMP_R1_USPA_TO_T211_GRT_UTIL2 A, TEMP_R1_0711_STDNAME_INDEX C
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID
and UPPER(REGEXP_REPLACE(B.NAME, '[[:punct:]]| ', '')) = C.STD_NAME
and B.cvg = 'AM1'
group by B.TECHN_FIELD_NR
order by B.TECHN_FIELD_NR;


-- MAINT_FEE 탐색
select * from USPA_MAINT_FEE_EVENT;


select C.EVENT_CODE, count(distinct A.PAT_PUBLN_ID) from TEMP_R1_USPA_T211_GRT_TECH_CVG A, TEMP_R1_USPA_TO_T211_GRT_UTIL2 B, USPA_MAINT_FEE_EVENT C
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID
and A.doc_number = C.PAT_NUM
group by C.EVENT_CODE; --378802

-- 만료된 특허
select A.TECHN_FIELD_NR, count(distinct A.PAT_PUBLN_ID) from TEMP_R1_USPA_T211_GRT_TECH_CVG A, TEMP_R1_USPA_TO_T211_GRT_UTIL2 B, USPA_MAINT_FEE_EVENT C
where A.PAT_PUBLN_ID = B.PAT_PUBLN_ID
and A.doc_number = C.PAT_NUM
and C.EVENT_CODE = 'EXP.' 
group by A.TECHN_FIELD_NR
order by A.TECHN_FIELD_NR;

--TEMP_R1_USPA_TO_T211_GRT_UTIL2 B
select * from TEMP_R1_USPA_TO_T211_GRT_UTIL2 B
where B.doc_number = '9458370';
order by B.DOC_NUMBER desc;

select * from USPA_MAINT_FEE_EVENT C
where C.PAT_NUM = '9458370';

