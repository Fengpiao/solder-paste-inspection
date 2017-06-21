/*更新焊点规格*/
create table  solderpb5a_spec_update
as
select t1.cmodel,
       t1.idstation,
       t1.compname,
       t1.winname,
       case
         when vhigh_new is null then
          t1.vhigh
         else
          vhigh_new
       end vhigh,
       t1.v,
       case
         when vlow_new is null then
          t1.vlow
         else
          vlow_new
       end vlow,
       case
         when ahigh_new is null then
          t1.ahigh
         else
          ahigh_new
       end ahigh,
       t1.a,
       case
         when alow_new is null then
          t1.alow
         else
          alow_new
       end alow,
       case
         when hhigh_new is null then
          t1.hhigh
         else
          hhigh_new
       end hhigh,
       t1.h,
       case
         when hlow_new is null then
          t1.hlow
         else
          hlow_new
       end hlow,
       case
         when x_new is null then
          t1.x
         else
          x_new
       end x,
       case
         when y_new is null then
          t1.y
         else
          y_new
       end y,
       '2017-06-17 18:52:20' createdate
  from solderpb5a_spec_201704 t1,
       (select compname, winname, max(vhigh_new) vhigh_new
          from (select compname, winname, min(v) - 0.00000001 vhigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and v > vhigh
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(v) vhigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and v > vhigh
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t2,
       (select compname, winname, max(ahigh_new) ahigh_new
          from (select compname, winname, min(a) - 0.00000001 ahigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and a > ahigh
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(a) ahigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and a > ahigh
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t3,
       (select compname, winname, max(hhigh_new) hhigh_new
          from (select compname, winname, min(h) - 0.00000001 hhigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and h > hhigh
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(h) hhigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and h > hhigh
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t4,
       (select compname, winname, min(vlow_new) vlow_new
          from (select compname, winname, max(v) + 0.00000001 vlow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and v < vlow
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, min(v) vlow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and v < vlow
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t5,
       (select compname, winname, min(alow_new) alow_new
          from (select compname, winname, max(a) + 0.00000001 alow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and a < alow
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, min(a) alow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and a < alow
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t6,
       (select compname, winname, min(hlow_new) hlow_new
          from (select compname, winname, max(h) + 0.00000001 hlow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and h < hlow
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, min(h) hlow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and h < hlow
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t7,
           (select compname, winname, max(x_new) x_new
          from (select compname, winname, min(abs(px)) - 0.00000001 x_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and abs(px) > x
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(abs(px)) x_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                where v <> 0
                   and BRIDGE_RESULT = '1'
                   and abs(px) > x
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname)  t8,
    (select compname, winname, max(y_new) y_new
          from (select compname, winname, min(abs(py)) - 0.00000001 y_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and abs(py) > y
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(abs(py)) y_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where v <> 0
                   and BRIDGE_RESULT = '1'
                   and abs(py) > y
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname)  t9
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
   and t1.compname = t3.compname(+)
   and t1.winname = t3.winname(+)
   and t1.compname = t4.compname(+)
   and t1.winname = t4.winname(+)
   and t1.compname = t5.compname(+)
   and t1.winname = t5.winname(+)
   and t1.compname = t6.compname(+)
   and t1.winname = t6.winname(+)
   and t1.compname = t7.compname(+)
   and t1.winname = t7.winname(+)
   and t1.compname = t8.compname(+)
   and t1.winname = t8.winname(+)
   and t1.compname = t9.compname(+)
   and t1.winname = t9.winname(+);
