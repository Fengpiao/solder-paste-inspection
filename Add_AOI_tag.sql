/*增加AOI的状态标签*/
create  table SOLDER_2017_FAIL_ALL_update
as
select t1.fdate,
       t1.ftime,
       t1.cmodel,
       t1.boardsn,
       t1.status_b,
       t3.status status_b_aoi,
       t1.compname,
       t1.winname,
       t1.status_s,
       t1.v,
       t2.VHIGH,
       t2.VLOW,
       t1.a,
       t2.AHIGH,
       t2.ALOW,
       t1.h,
       t2.HHIGH,
       t2.HLOW,
       t1.px,
       t2.X,
       t1.py,
       t2.Y,
       t1.bridge_result, 
       case
         when t3.status = 'FAIL' then
          'FAIL'
         when t3.status = 'UTes' then
          'UTes'
         else
          'PASS'
       end status_aoi 
  from SOLDER_2017_FAIL_ALL   t1, ---233606
       solderpb5a_spec_201704 t2,
       BoardPB5A_update       t3
 where t1.cmodel = t2.cmodel
   and t1.compname = t2.compname
   and t1.winname = t2.winname
   and t1.ftime = t3.FTIME;
