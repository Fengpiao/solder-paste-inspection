select t1.fdate,
       t1.ftime,
       interval_time_s,
       cmodel,
       boardsn,
       status_b,
       rpass_num,
       num,
       round(rpass_rate_s * 100, 3) || '%' rpass_rate_s,
       x_max,
       x_min,
       x_avg,
       x_std,
       x_10,
       x_median,
       x_increase_num,
       x_descend_num,
       x_90,
       y_max,
       y_min,
       y_avg,
       y_std,
       y_10,
       y_median,
       y_increase_num,
       y_descend_num,
       y_90
  from board_201704_d t1,
       (select ftime,
               sum(if_rpass) over(order by ftime rows between current row and 9 following) rpass_num
          from (select ftime,
                       status_b,
                       decode(status_b, 'RPASS', 1, 0) if_rpass
                  from board_201704_d)) t2,
       (select ftime,
               to_number(to_date(ftime_follow, 'yyyy-mm-dd hh24:mi:ss') -
                         ftime) * 24 * 60 * 60 as interval_time_s
          from (select ftime,
                       lead(to_char(ftime, 'yyyy-mm-dd hh24:mi:ss'), 1, 0) over(order by ftime) ftime_follow
                  from board_201704_d)
         where ftime_follow <> '0') t3,
       (select ftime,
               sum(if_x_increase) over(order by ftime rows between current row and 7 following) x_increase_num,
               sum(if_x_descend) over(order by ftime rows between current row and 7 following) x_descend_num,
               sum(if_y_increase) over(order by ftime rows between current row and 7 following) y_increase_num,
               sum(if_y_descend) over(order by ftime rows between current row and 7 following) y_descend_num
          from (select ftime,
                       case
                         when (lead(x_median, 1, 0)
                               over(order by ftime) - x_median > 0) then
                          1
                         else
                          0
                       end if_x_increase,
                       case
                         when (lead(x_median, 1, 0)
                               over(order by ftime) - x_median < 0) then
                          1
                         else
                          0
                       end if_x_descend,
                       case
                         when (lead(y_median, 1, 0)
                               over(order by ftime) - y_median > 0) then
                          1
                         else
                          0
                       end if_y_increase,
                       case
                         when (lead(y_median, 1, 0)
                               over(order by ftime) - y_median < 0) then
                          1
                         else
                          0
                       end if_y_descend
                  from board_201704_d)) t4
 where t1.ftime = t2.ftime(+)
   and t1.ftime = t3.ftime(+)
   and t1.ftime = t4.ftime(+)
 order by t1.ftime;
