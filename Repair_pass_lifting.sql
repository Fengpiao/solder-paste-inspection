/*分别统计8个因素修复后的焊点通过率的提升量*/
select 'V >VHIGH' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when v > vhigh_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where v <> 0
           and BRIDGE_RESULT = '1'
           and v > vhigh) t1,
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
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
union
select 'A >AHIGH' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when a > ahigh_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where a <> 0
           and BRIDGE_RESULT = '1'
           and a > ahigh) t1,
       (select compname, winname, max(ahigh_new) ahigh_new
          from (select compname, winname, min(a) - 0.00000001 ahigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where a <> 0
                   and BRIDGE_RESULT = '1'
                   and a > ahigh
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(a) ahigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where a <> 0
                   and BRIDGE_RESULT = '1'
                   and a > ahigh
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
union
select 'H >HHIGH' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when h > hhigh_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where h <> 0
           and BRIDGE_RESULT = '1'
           and h > hhigh) t1,
       (select compname, winname, max(hhigh_new) hhigh_new
          from (select compname, winname, min(h) - 0.00000001 hhigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where h <> 0
                   and BRIDGE_RESULT = '1'
                   and h > hhigh
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(h) hhigh_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where h <> 0
                   and BRIDGE_RESULT = '1'
                   and h > hhigh
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
union
select 'V <VLOW' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when v < vlow_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where v <> 0
           and BRIDGE_RESULT = '1'
           and v < vlow) t1,
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
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
union
select 'A < ALOW' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when a < alow_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where a <> 0
           and BRIDGE_RESULT = '1'
           and a < alow) t1,
       (select compname, winname, min(alow_new) alow_new
          from (select compname, winname, max(a) + 0.00000001 alow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where a <> 0
                   and BRIDGE_RESULT = '1'
                   and a < alow
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, min(a) alow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where a <> 0
                   and BRIDGE_RESULT = '1'
                   and a < alow
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
union
select 'H < HLOW' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when h < hlow_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where h <> 0
           and BRIDGE_RESULT = '1'
           and h < hlow) t1,
       (select compname, winname, min(hlow_new) hlow_new
          from (select compname, winname, max(h) + 0.00000001 hlow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where h <> 0
                   and BRIDGE_RESULT = '1'
                   and h < hlow
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, min(h) hlow_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where h <> 0
                   and BRIDGE_RESULT = '1'
                   and h < hlow
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
union
select 'PX > X' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when abs(px) > x_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where BRIDGE_RESULT = '1'
           and abs(px) > x) t1,
       (select compname, winname, max(x_new) x_new
          from (select compname, winname, min(abs(px)) - 0.00000001 x_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where BRIDGE_RESULT = '1'
                   and abs(px) > x
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(abs(px)) x_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where BRIDGE_RESULT = '1'
                   and abs(px) > x
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+)
union
select 'PY > Y' cause,
       count(1) spi_fail_num,
       sum(decode(status_aoi, 'FAIL', 1, 0)) aoi_fail_num,
       sum(case
             when abs(py) > y_new then
              1
             else
              0
           end) update_fail_num
  from (select *
          from SOLDER_2017_FAIL_ALL_UPDATE
         where BRIDGE_RESULT = '1'
           and abs(py) > y) t1,
       (select compname, winname, max(y_new) y_new
          from (select compname, winname, min(abs(py)) - 0.00000001 y_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where BRIDGE_RESULT = '1'
                   and abs(py) > y
                   and status_aoi = 'FAIL'
                 group by compname, winname
                union
                select compname, winname, max(abs(py)) y_new
                  from SOLDER_2017_FAIL_ALL_UPDATE
                 where BRIDGE_RESULT = '1'
                   and abs(py) > y
                   and status_aoi = 'PASS'
                 group by compname, winname)
         group by compname, winname) t2
 where t1.compname = t2.compname(+)
   and t1.winname = t2.winname(+);
