select max(recorded_date), min(recorded_date) from PADX_ASSIGNMENT_RECORD;
-- 2017-10-17, 1970-01-04

/* 07-11 소유권 이전이 일어난 특허 */
-- 이전 건수
select to_char(A.RECORDED_DATE,'yyyy'), count(*) from PADX_ASSIGNMENT_RECORD A
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
group by to_char(A.RECORDED_DATE,'yyyy')
order by to_char(A.RECORDED_DATE,'yyyy') asc
;
select count(*) from PADX_ASSIGNMENT_RECORD A
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
; --172532

select * from PADX_ASSIGNMENT_RECORD A
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
;

/* 각 rf-id, property-id별 마지막 문서 - 공개 또는 등록 */
select C.PROPERTY_ID, max(C.DATE_DOCUMENT) as max_date_document, A.REEL_FRAME_NO
            from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
and A.reel_frame_no = C.reel_frame_no
group by C.PROPERTY_ID, A.REEL_FRAME_NO
;

/* 5년 간 실질이전된 모든 특허(최종버전)x 모든 이전 x 모든 양수인 */
select C.doc_number, A.REEL_FRAME_NO, A.RECORDED_DATE, A.CONVEY_TY, A.PROPERTY_COUNT,
        C.PROPERTY_ID, C.KIND, C.DATE_DOCUMENT,
        E.NAME
    from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C, PADX_PATENT_ASSIGNEES E
    , (
    select C.PROPERTY_ID, max(C.DATE_DOCUMENT) as max_date_document, A.REEL_FRAME_NO
            from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
and A.reel_frame_no = C.reel_frame_no
group by C.PROPERTY_ID, A.REEL_FRAME_NO
    ) temp
where temp.reel_frame_no = A.reel_frame_no
and temp.reel_frame_no = C.reel_frame_no
and temp.property_id = C.PROPERTY_ID
and temp.max_date_document = C.DATE_DOCUMENT
and temp.reel_frame_no = E.reel_frame_no
and C.KIND in ('B1','B2')
;
/* 공개특허 번호 형식 맞추기*/
select concat(substr(C.doc_number,1,4), substr(C.doc_number,-6,6)) as doc_number,
        A.REEL_FRAME_NO, A.RECORDED_DATE, A.CONVEY_TY, A.PROPERTY_COUNT,
        C.PROPERTY_ID, C.KIND, C.DATE_DOCUMENT,
        E.NAME
    from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C, PADX_PATENT_ASSIGNEES E
    , (
    select C.PROPERTY_ID, max(C.DATE_DOCUMENT) as max_date_document, A.REEL_FRAME_NO
            from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
and A.reel_frame_no = C.reel_frame_no
group by C.PROPERTY_ID, A.REEL_FRAME_NO
    ) temp
where temp.reel_frame_no = A.reel_frame_no
and temp.reel_frame_no = C.reel_frame_no
and temp.property_id = C.PROPERTY_ID
and temp.max_date_document = C.DATE_DOCUMENT
and temp.reel_frame_no = E.reel_frame_no
and C.KIND = 'A1'
;

/* from uspa to t211 */
-- test 20100208789, 20100187611 - 20100729
select * from TLS211_PAT_PUBLN t211
where t211.PUBLN_NR = '2010208789'
and t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE ='20100819';


/* 공개-등록 집합 합쳐서 temp_r1_uspa */
create table temp_r1_uspa as
select C.doc_number, A.REEL_FRAME_NO, A.RECORDED_DATE, A.CONVEY_TY, A.PROPERTY_COUNT,
        C.PROPERTY_ID, C.KIND, C.DATE_DOCUMENT,
        E.NAME
    from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C, PADX_PATENT_ASSIGNEES E
    , (
    select C.PROPERTY_ID, max(C.DATE_DOCUMENT) as max_date_document, A.REEL_FRAME_NO
            from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
and A.reel_frame_no = C.reel_frame_no
group by C.PROPERTY_ID, A.REEL_FRAME_NO
    ) temp
where temp.reel_frame_no = A.reel_frame_no
and temp.reel_frame_no = C.reel_frame_no
and temp.property_id = C.PROPERTY_ID
and temp.max_date_document = C.DATE_DOCUMENT
and temp.reel_frame_no = E.reel_frame_no
and C.KIND in ('B1','B2')
UNION
select concat(substr(C.doc_number,1,4), substr(C.doc_number,-6,6)) as doc_number,
        A.REEL_FRAME_NO, A.RECORDED_DATE, A.CONVEY_TY, A.PROPERTY_COUNT,
        C.PROPERTY_ID, C.KIND, C.DATE_DOCUMENT,
        E.NAME
    from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C, PADX_PATENT_ASSIGNEES E
    , (
    select C.PROPERTY_ID, max(C.DATE_DOCUMENT) as max_date_document, A.REEL_FRAME_NO
            from PADX_ASSIGNMENT_RECORD A, PADX_DOCUMENT_ID C
where A.RECORDED_DATE >= '2007-01-01'
and A.RECORDED_DATE <= '2011-12-31'
and A.employer_assign = '0'
and A.convey_ty in ('assignment', 'merger', 'namecha')
and A.reel_frame_no = C.reel_frame_no
group by C.PROPERTY_ID, A.REEL_FRAME_NO
    ) temp
where temp.reel_frame_no = A.reel_frame_no
and temp.reel_frame_no = C.reel_frame_no
and temp.property_id = C.PROPERTY_ID
and temp.max_date_document = C.DATE_DOCUMENT
and temp.reel_frame_no = E.reel_frame_no
and C.KIND = 'A1'
;
select count(distinct doc_number) from temp_r1_uspa; --470216
select count(distinct doc_number) from temp_r1_uspa where kind in ('B1','B2'); --공개 65074 등록 405142
select count(distinct REEL_FRAME_NO) from temp_r1_uspa; --172455
select count(distinct name) from temp_r1_uspa; --63430

/* from uspa to t211 */
-- test 20100208789, 20100187611 - 20100729
drop table temp_r1_uspa_to_t211;
create table temp_r1_uspa_to_t211 AS
select temp.*, t211.publn_kind, t211.PAT_PUBLN_ID, t211.APPLN_ID from temp_r1_uspa temp, TLS211_PAT_PUBLN t211
where temp.DOC_NUMBER = t211.PUBLN_NR
and t211.PUBLN_AUTH = 'US' 
and temp.DATE_DOCUMENT = t211.PUBLN_DATE
and t211.publn_kind != 'S' and t211.publn_kind != 'P1'; -- 디자인, 식물특허 제외
select count(distinct doc_number) from temp_r1_uspa_to_t211; --463141 / 444100 (-디자인!)
select count(distinct doc_number) from temp_r1_uspa_to_t211 where kind in ('B1','B2'); -- 65067, 398074 /65036,379064
select publn_kind, count(*) from temp_r1_uspa_to_t211 group by publn_kind;
select * from temp_r1_uspa_to_t211 where publn_kind = 'P1';
select publn_kind, count(*) from temp_r1_uspa_to_t211 group by publn_kind;
-- 뭐가 빠졌나?
select doc_number,REEL_FRAME_NO, RECORDED_DATE, CONVEY_TY, PROPERTY_COUNT,
        PROPERTY_ID, KIND, DATE_DOCUMENT
        from temp_r1_uspa
minus
select doc_number,REEL_FRAME_NO, RECORDED_DATE, CONVEY_TY, PROPERTY_COUNT,
        PROPERTY_ID, KIND, DATE_DOCUMENT
        from temp_r1_uspa_to_t211;
    -- 결국 빠진 것은 2017년 이후 등록/공개 특허들. (데이터의 한계)

select * from TEMP_R1_USPA_TO_T211;
select count(distinct UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', ''))) from  TEMP_R1_USPA_TO_T211; -- 58221
select count(distinct PAT_PUBLN_ID) from  TEMP_R1_USPA_TO_T211; -- 444100

/* 5년간 이전된 특허 집합(위)을 인용한 특허 - 즉, 그 이후의 특허들.. */
-- 테스트
select r1.DOC_NUMBER, t212.PAT_PUBLN_ID as citing_pat_publn_id, t212.CITED_PAT_PUBLN_ID
        from TEMP_R1_USPA_TO_T211 r1, TLS212_CITATION t212
where r1.pat_publn_id = t212.CITED_PAT_PUBLN_ID ;
-- 본 테이블 (2073초)
create table temp_r1_citing_applt as
select r1.DOC_NUMBER, t212.PAT_PUBLN_ID as citing_pat_publn_id, t212.CITED_PAT_PUBLN_ID, t227.PERSON_ID, t206.PERSON_NAME
        from TEMP_R1_USPA_TO_T211 r1, TLS212_CITATION t212, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where
    r1.pat_publn_id = t212.CITED_PAT_PUBLN_ID
and t227.INVT_SEQ_NR = '0'
and t212.PAT_PUBLN_ID = t227.PAT_PUBLN_ID
and t227.PERSON_ID = t206.PERSON_ID
;
select count(distinct doc_number) from TEMP_R1_CITING_APPLT; -- 377242 (피인용 발생한 특허가 이만큼)
select * from TEMP_R1_USPA_TO_T211 where NAME = 'AMBRILIA BIOPHARMA INC.'; --2008200393
select * from TEMP_R1_CITING_APPLT where CITED_PAT_PUBLN_ID = '2008200393';

/* 공백, 특수문자 제거 */
select UPPER(REGEXP_REPLACE(PERSON_NAME, '[[:punct:]]| ', '')) as person_name_clean
  FROM TEMP_R1_CITING_APPLT;
--test
select count(distinct A.DOC_NUMBER, A.NAME, B.PERSON_NAME, A.PAT_PUBLN_ID, B.CITING_PAT_PUBLN_ID, A.REEL_FRAME_NO)
        from TEMP_R1_USPA_TO_T211 A, TEMP_R1_CITING_APPLT B
where A.PAT_PUBLN_ID = B.CITED_PAT_PUBLN_ID
and UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) = UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', ''))
  ;
  
  /* temp_r1_uspa_to_t211과 temp_r1_citing_applt 의 이름 비교 */

create table temp_r1_ind_self_cited AS;
select distinct A.DOC_NUMBER, A.NAME, B.PERSON_NAME, C.PUBLN_NR, A.REEL_FRAME_NO
        from TEMP_R1_USPA_TO_T211 A, TEMP_R1_CITING_APPLT B, TLS211_PAT_PUBLN C
where A.PAT_PUBLN_ID = B.CITED_PAT_PUBLN_ID
and UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) = UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', ''))
and B.CITING_PAT_PUBLN_ID = C.PAT_PUBLN_ID
and C.PUBLN_AUTH ='US'
  ;

select count(*) from temp_r1_ind_self_cited; -- 491642
select count(distinct doc_number) from temp_r1_ind_self_cited; -- 99919
select count(distinct PUBLN_NR) from temp_r1_ind_self_cited; -- 188466
select count(distinct UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', ''))) from temp_r1_ind_self_cited; -- 13060
select count(distinct UPPER(REGEXP_REPLACE(PERSON_NAME, '[[:punct:]]| ', ''))) from temp_r1_ind_self_cited; -- 13060

/* 새분석 통계 */
/* 07-11 실질 소유권 이전 with patstat 전체 */
select count(distinct doc_number) from TEMP_R1_USPA_TO_T211; --444100
select count(distinct UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', ''))) from TEMP_R1_USPA_TO_T211; -- 58221
select count(distinct doc_number) from TEMP_R1_USPA_TO_T211 where kind in ('B1', 'B2'); -- 379064
select count(distinct UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', ''))) from TEMP_R1_USPA_TO_T211 where kind in ('B1', 'B2'); -- 50725

select UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) as namestd, count(distinct doc_number) as doc_cnt from TEMP_R1_USPA_TO_T211
group by UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) order by doc_cnt desc;
-- grant만
select UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) as namestd, count(distinct doc_number) as doc_cnt from TEMP_R1_USPA_TO_T211 where kind in ('B1', 'B2')
group by UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) order by doc_cnt desc;

select avg(doc_cnt), stddev(doc_cnt), max(doc_cnt), min(doc_cnt)
from (
select UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) as namestd, count(distinct doc_number) as doc_cnt from TEMP_R1_USPA_TO_T211 
group by UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) ) temp ;
-- grant만
select avg(doc_cnt), stddev(doc_cnt), max(doc_cnt), min(doc_cnt)
from (
select UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) as namestd, count(distinct doc_number) as doc_cnt from TEMP_R1_USPA_TO_T211 where kind in ('B1', 'B2')
group by UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) ) temp ;

/* self-ind-citation, doc_cnt by name */
select UPPER(REGEXP_REPLACE(PERSON_NAME, '[[:punct:]]| ', '')), count(doc_number, PUBLN_NR) from temp_r1_ind_self_cited
group by UPPER(REGEXP_REPLACE(PERSON_NAME, '[[:punct:]]| ', '')); -- 13060

/* 대조군 만들기 */
select 
-- t211.PUBLN_KIND, 
count(distinct t206.person_id) 
from TLS211_PAT_PUBLN t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
-- group by t211.PUBLN_KIND
; -- 134565

select 
count(distinct t211.pat_publn_id) 
from TLS211_PAT_PUBLN t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
;
select count(distinct t211.pat_publn_id) from TLS211_PAT_PUBLN_US t211 where t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31' and t211.publn_kind in ('B1','B2','E');

/*대조군의 person_name 과 temp_r1_uspa_to_t211의 name 연결 (얼마나 구멍이 나나?) */
create table temp_r1_all_applt_asgn_match as
select distinct A.NAME, t206.PERSON_NAME, t206.PERSON_ID
        from TEMP_R1_USPA_TO_T211 A, TLS211_PAT_PUBLN t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
and UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', ''))
        = UPPER(REGEXP_REPLACE(t206.PERSON_NAME, '[[:punct:]]| ', ''))
;
select count(*) from TEMP_R1_ALL_APPLT_ASGN_MATCH; --55,524개 기업 확인
-- 55,524개 기업이 5년간 등록한 utility patent from t211 (2580초)
create table temp_r1_matched_all_utility as
select A.PERSON_ID, A.PERSON_NAME, t211.PAT_PUBLN_ID, t211.PUBLN_NR, t211.APPLN_ID, t206.PSN_SECTOR
        from TEMP_R1_ALL_APPLT_ASGN_MATCH A, TLS211_PAT_PUBLN t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
and A.person_id = t206.person_id
;
-- 위 기업의 5년간 등록 특허 수 통계
select PERSON_NAME, count(distinct pat_publn_id) cnt from TEMP_R1_MATCHED_ALL_UTILITY group by PERSON_NAME order by cnt desc;

/* A,B,C 구하고, 두 지표 계산 */
/* A - 매입한 등록 특허 */
select count(distinct doc_number) from TEMP_R1_USPA_TO_T211 where kind in ('B1', 'B2'); -- 379064
select count(distinct UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', ''))) from TEMP_R1_USPA_TO_T211 where kind in ('B1', 'B2'); -- 50725
select UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) as assignee_std, count(A.doc_number) as doc_cnt
    from TEMP_R1_USPA_TO_T211 A 
    where A.kind in ('B1', 'B2')
    group by UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) order by doc_cnt desc
;
/* B - 등록한 특허 */
select UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', '')) as assignee_std, count(distinct pat_publn_id) cnt 
    from TEMP_R1_MATCHED_ALL_UTILITY B
    group by UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', '')) order by cnt desc;

/* C - 간접 피인용한 매입 특허 */

create table temp_r1_ind_self_cited2 AS
select distinct A.DOC_NUMBER, A.NAME, B.PERSON_NAME, C.PUBLN_NR, A.REEL_FRAME_NO
        from TEMP_R1_USPA_TO_T211 A, TEMP_R1_CITING_APPLT B, TLS211_PAT_PUBLN C
where A.kind in ('B1', 'B2')
and A.PAT_PUBLN_ID = B.CITED_PAT_PUBLN_ID
and UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) = UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', ''))
and B.CITING_PAT_PUBLN_ID = C.PAT_PUBLN_ID
and C.PUBLN_AUTH ='US'
  ;
select count(*) from temp_r1_ind_self_cited2; -- 439426
select count(distinct doc_number) from temp_r1_ind_self_cited2; -- 86947
select count(distinct PUBLN_NR) from temp_r1_ind_self_cited2; -- 170542
select count(distinct UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', ''))) from temp_r1_ind_self_cited2; -- 11843
select count(distinct UPPER(REGEXP_REPLACE(PERSON_NAME, '[[:punct:]]| ', ''))) from temp_r1_ind_self_cited2; -- 11843
  
select UPPER(REGEXP_REPLACE(C.NAME, '[[:punct:]]| ', '')) as assignee_std, count(distinct C.DOC_NUMBER) as cnt
    from temp_r1_ind_self_cited2 C
    group by UPPER(REGEXP_REPLACE(C.NAME, '[[:punct:]]| ', '')) order by cnt desc; -- 13060
    
/* A, B, C 조인하고 */
select UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')), A.
    from TEMP_R1_USPA_TO_T211 A, TEMP_R1_MATCHED_ALL_UTILITY B, temp_r1_ind_self_cited C
    where A.kind in ('B1', 'B2')
        and UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) = UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', ''))
        and UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) = UPPER(REGEXP_REPLACE(C.NAME, '[[:punct:]]| ', ''))
;
select 
        TA.assignee_std as name_from_assignment_db, TA.doc_cnt as CA, 
        TB.assignee_std as name_from_gran_db, TB.cnt as cB, 
        TC.assignee_std as name_from_selfcit, TC.cnt as cC
-- count(TA.assignee_std)
-- TA.assignee_std, TA.doc_cnt as CA, TB.cnt as cB, TC.cnt as cC, (TA.doc_cnt/(TA.doc_cnt+TB.cnt)) as ext_dep, (TC.cnt/TA.doc_cnt) as asorp_r
from
    (select UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) as assignee_std, count(distinct A.doc_number) as doc_cnt
    from TEMP_R1_USPA_TO_T211 A 
    where A.kind in ('B1', 'B2')
    group by UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) order by doc_cnt desc) TA
left outer join 
    (select UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', '')) as assignee_std, count(distinct pat_publn_id) cnt 
    from TEMP_R1_MATCHED_ALL_UTILITY B
    group by UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', '')) order by cnt desc) TB
on TA.assignee_std = TB.assignee_std
left outer join
(select UPPER(REGEXP_REPLACE(C.NAME, '[[:punct:]]| ', '')) as assignee_std, count(distinct C.DOC_NUMBER) as cnt
    from temp_r1_ind_self_cited2 C
    group by UPPER(REGEXP_REPLACE(C.NAME, '[[:punct:]]| ', '')) order by cnt desc) TC
on TA.assignee_std = TC.assignee_std;

-- std 이름을 가장 많이 쓰인 보통 이름으로 대체하자. - 엑셀로 받아둔 상태 name(TA)
select org.assignee_std, org.name from 
(
select UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) as assignee_std, A.NAME, count(distinct A.DOC_NUMBER) as doc_cnt
    from TEMP_R1_USPA_TO_T211 A 
    where A.kind in ('B1', 'B2')
    group by (UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')), A.name) order by UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) , doc_cnt desc
) org
inner join
(
select assignee_std, max(doc_cnt) as max_cnt
from (
select UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')) as assignee_std, A.NAME, count(distinct A.DOC_NUMBER) as doc_cnt
    from TEMP_R1_USPA_TO_T211 A 
    where A.kind in ('B1', 'B2')
    group by (UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', '')), A.name) )
group by assignee_std
) grp
on org.assignee_std = grp.assignee_std and org.doc_cnt = grp.max_cnt
;

/* 07-11, 특허 매입 혹은 등록을 한 기업들의 12-16 활동 */
-- 최대 범위는, 07-11 등록특허 출원인기업 union 07-11 실질소유권 양수인이 12-16 등록특허 출판
-- 맞나??

select count(distinct t206.person_id) 
from TLS211_PAT_PUBLN_US t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
; -- 134565, 53초
select count(distinct t227.person_id) 
from TLS211_PAT_PUBLN_US t211, TLS227_PERS_PUBLN t227
where t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t211.publn_kind in ('B1x','B2','E')
and t227.INVT_SEQ_NR = '0'
; -- 134565, 56초 (동일하네??)
select count(distinct t211.pat_publn_id) from TLS211_PAT_PUBLN_US t211 where t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31' and t211.publn_kind in ('B1','B2','E');

select count(distinct t206.person_id)
from TLS211_PAT_PUBLN_US t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206, tls227_pers_publn t227_2, tls211_pat_publn_us t211_2
where t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
and t227_2.PERSON_ID = t206.person_id
and t211_2.pat_publn_id = t227_2.PAT_PUBLN_ID
and t227_2.INVT_SEQ_NR = '0'
and t211_2.publn_kind in ('B1','B2','E')
and t211_2.PUBLN_DATE >= '2012-01-01' and t211_2.PUBLN_DATE <= '2016-12-31'
; -- 38517, 1004초
select count(distinct t211_2.pat_publn_id)
from TLS211_PAT_PUBLN_US t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206, tls227_pers_publn t227_2, tls211_pat_publn_us t211_2
where t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
and t227_2.PERSON_ID = t206.person_id
and t211_2.pat_publn_id = t227_2.PAT_PUBLN_ID
and t227_2.INVT_SEQ_NR = '0'
and t211_2.publn_kind in ('B1','B2','E')
and t211_2.PUBLN_DATE >= '2012-01-01' and t211_2.PUBLN_DATE <= '2016-12-31'
; -- 1047011, 1011초
-- 12-16 전체 통계
select count(distinct t211.pat_publn_id) from TLS211_PAT_PUBLN_US t211 where t211.PUBLN_DATE >= '2012-01-01' and t211.PUBLN_DATE <= '2016-12-31' and t211.publn_kind in ('B1','B2','E'); -- 5초, 1436323건
select count(distinct t206.person_id) 
from TLS211_PAT_PUBLN_US t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_DATE >= '2012-01-01' and t211.PUBLN_DATE <= '2016-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
; -- 186009, 54초

-- 07-11 실질양수인이 12-16에 등록한 특허

/*12-16미국등록특허의 person_name 과 temp_r1_uspa_to_t211의 name 연결 */ -- 743초
drop table temp_r1_all_applt_asgn_match2;
create table temp_r1_all_applt_asgn_match2 as
select distinct A.NAME, t206.PERSON_NAME, t206.PERSON_ID
        from TEMP_R1_USPA_TO_T211 A, TLS211_PAT_PUBLN t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE >= '2012-01-01' and t211.PUBLN_DATE <= '2016-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E') -- 등록특허로 한정
and t227.INVT_SEQ_NR = '0'
and UPPER(REGEXP_REPLACE(A.NAME, '[[:punct:]]| ', ''))
        = UPPER(REGEXP_REPLACE(t206.PERSON_NAME, '[[:punct:]]| ', ''))
and A.kind in ('B1','B2');

select count(distinct name) from temp_r1_all_applt_asgn_match2; -- 19954

-- 21976개 기업이 12-16년간 등록한 utility patent from t211 
drop table temp_r1_matched_all_util_1216;
create table temp_r1_matched_all_util_1216 as
select A.PERSON_ID, A.PERSON_NAME, t211.PAT_PUBLN_ID, t211.PUBLN_NR, t211.APPLN_ID, t206.PSN_SECTOR
        from TEMP_R1_ALL_APPLT_ASGN_MATCH2 A, TLS211_PAT_PUBLN t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE >= '2012-01-01' and t211.PUBLN_DATE <= '2016-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
and A.person_id = t206.person_id
;
select count(distinct publn_nr) from temp_r1_matched_all_util_1216; -- 993625
select count(distinct person_id) from temp_r1_matched_all_util_1216; -- 41964
select count(distinct UPPER(REGEXP_REPLACE(PERSON_NAME, '[[:punct:]]| ', ''))) from temp_r1_matched_all_util_1216; -- 18401

select UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', '')) as app1216_asgn0711_namestd, count(distinct pat_publn_id) grants1216
    from temp_r1_matched_all_util_1216 B
    group by UPPER(REGEXP_REPLACE(B.PERSON_NAME, '[[:punct:]]| ', '')) order by grants1216 desc;

select * from temp_r1_uspa_to_t211 where UPPER(REGEXP_REPLACE(NAME, '[[:punct:]]| ', '')) = 'GRITINC';
-- 2011162931	258300862	11/02/18	assignment	1	1	A1	11/07/07	GRIT INC.	A1	335361155	335349003



-- 0711동안 실질이전 없는 기업목록
create table temp_r1_nonasign_applts_0711 as
select distinct t206.person_id
from TLS211_PAT_PUBLN t211, TLS227_PERS_PUBLN t227, TLS206_PERSON3 t206
where t211.PUBLN_AUTH = 'US' and t211.PUBLN_DATE >= '2007-01-01' and t211.PUBLN_DATE <= '2011-12-31'
and t211.pat_publn_id = t227.pat_publn_id
and t227.person_id = t206.person_id
and t211.publn_kind in ('B1','B2','E')
and t227.INVT_SEQ_NR = '0'
MINUS
select distinct person_id from TEMP_R1_ALL_APPLT_ASGN_MATCH
;
