/*更新焊点规格后焊点状态重新打标签*/
create table SOLDER_2017_FAIL_ALL_UPGRADE
as
select t1.fdate,
               t1.ftime,
               t1.cmodel,
               t1.boardsn,
               t1.status_b,
               t1.status_b_aoi,
               t1.compname,
               t1.winname,
               t1.status_s,
               t1.v,
               t2.vhigh,
               t2.vlow,
               t1.a,
               t2.ahigh,
               t2.alow,
               t1.h,
               t2.hhigh,
               t2.hlow,
               t1.px,
               t2.x,
               t1.py,
               t2.y,
               t1.bridge_result,
               t1.status_aoi,
               case
                 when (t1.v >= t2.vlow and t1.v <= t2.vhigh and
                      t1.a >= t2.alow and t1.a <= t2.ahigh and
                      t1.h >= t2.hlow and t1.h <= t2.hhigh and
                      abs(t1.px) <= t2.x and abs(t1.py) <= t2.y) then
                  'PASS'
                 else
                  'FAIL'
               end status_update
          from (select *
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and (v < vlow or v > vhigh or a < alow or a > ahigh or
                       h < hlow or h > hhigh or abs(px) > x or abs(py) > y)) t1,
               solderpb5a_spec_update t2
         where t1.compname = t2.compname
           and t1.winname = t2.winname
           
/*统计比较主板通过率  */         
select status_b_update,count(1) 
from
(select ftime, BOARDSN,
   case
         when sum(decode(STATUS_S, 'FAIL', 1, 0)) <> 0 then
          'FAIL'
         else
          'PASS'
       end status_spi,
       case
         when sum(decode(status_aoi, 'FAIL', 1, 0)) <> 0 then
          'FAIL'
         else
          'PASS'
       end status_b,
       case
         when sum(decode(STATUS_UPDATE, 'FAIL', 1, 0)) <> 0 then
          'FAIL'
         else
          'PASS'
       end status_b_update
  from
   SOLDER_2017_FAIL_ALL_UPGRADE
 group by ftime,  BOARDSN)
 group by status_b_update
