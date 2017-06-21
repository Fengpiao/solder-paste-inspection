create table solder_20170406_d
as
select substr(fdate, 1, 10)||' '||substr(fdate, 12, 8) ftime,
       t.cmodel,
       t.boardsn,
       t.status_b,
       t.COMPNAME,
       t.winname,
       t.status status_a,
       t.v,
       t.a,
       t.h,
       t.px,
       t.py
  from solder_20170406 t
 order by FTIME;
 
/*************************************************************************************************/
 create table solder_20170406_d_2
 as
 select t.*,
        lead(v, 1, 0) over(partition by COMPNAME, winname order by ftime) v_f1,
        avg(V) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) v_avg,
        stddev(V) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) v_std,
        lead(a, 1, 0) over(partition by COMPNAME, winname order by ftime) a_f1,
        avg(a) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) a_avg,
        stddev(a) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) a_std,
        lead(h, 1, 0) over(partition by COMPNAME, winname order by ftime) h_f1,
        avg(h) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) h_avg,
        stddev(h) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) h_std,
        lead(PX, 1, 0) over(partition by COMPNAME, winname order by ftime) x_f1,
        avg(PX) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) x_avg,
        stddev(PX) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) x_std,
        lead(PY, 1, 0) over(partition by COMPNAME, winname order by ftime) y_f1,
        avg(PY) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) y_avg,
        stddev(PY) over(partition by COMPNAME, winname order by ftime rows between 99 PRECEDING and current row) y_std
   from solder_20170406_d t;
 
/*************************************************************************************************/
 create table solder_20170406_d_3
 as 
 select t.*,
        v_avg + 3 * v_std v_ucl,
        v_avg - 3 * v_std v_lcl,
        a_avg + 3 * a_std a_ucl,
        a_avg - 3 * a_std a_lcl,
        h_avg + 3 * h_std h_ucl,
        h_avg - 3 * h_std h_lcl,
        x_avg + 3 * x_std x_ucl,
        x_avg - 3 * x_std x_lcl,
        y_avg + 3 * y_std y_ucl,
        y_avg - 3 * y_std y_lcl,
        case
          when v_f1 > v_avg then
           1
          when v_f1 < v_avg then
           -1
          else
           0
        end v_if_side,
        case
          when v_f1 > v_avg + 3 * v_std or v_f1 < v_avg + 3 * v_std then
           1
          else
           0
        end v_if_out,
        case
          when a_f1 > a_avg then
           1
          when a_f1 < a_avg then
           -1
          else
           0
        end a_if_side,
        case
          when a_f1 > a_avg + 3 * a_std or a_f1 < a_avg + 3 * a_std then
           1
          else
           0
        end a_if_out,
        case
          when h_f1 > h_avg then
           1
          when h_f1 < h_avg then
           -1
          else
           0
        end h_if_side,
        case
          when h_f1 > h_avg + 3 * h_std or h_f1 < h_avg + 3 * h_std then
           1
          else
           0
        end h_if_out,
        case
          when x_f1 > x_avg then
           1
          when x_f1 < x_avg then
           -1
          else
           0
        end x_if_side,
        case
          when x_f1 > x_avg + 3 * x_std or x_f1 < x_avg + 3 * x_std then
           1
          else
           0
        end x_if_out,
        case
          when y_f1 > y_avg then
           1
          when y_f1 < y_avg then
           -1
          else
           0
        end y_if_side,
        case
          when y_f1 > y_avg + 3 * y_std or y_f1 < y_avg + 3 * y_std then
           1
          else
           0
        end y_if_out,
        case
          when v_f1 > v then
           1
          when v_f1 < v then
           -1
          else
           0
        end v_if_monotonicity,
        case
          when a_f1 > a then
           1
          when a_f1 < a then
           -1
          else
           0
        end a_if_monotonicity,
        case
          when h_f1 > h then
           1
          when h_f1 < h then
           -1
          else
           0
        end h_if_monotonicity,
        case
          when x_f1 > PY then
           1
          when x_f1 < PY then
           -1
          else
           0
        end x_if_monotonicity,
        case
          when y_f1 > PY then
           1
          when y_f1 < PY then
           -1
          else
           0
        end y_if_monotonicity
   from solder_20170406_d_2 t
  where compname = 'C9154_1'
    and winname = '2'   

/*************************************************************************************************/   
 create table solder_20170406_d_4
 as 
select t.*,
       sum(v_if_side) over(partition by COMPNAME, winname order by ftime rows between current row and 8 following) v_side_num,
       sum(a_if_side) over(partition by COMPNAME, winname order by ftime rows between current row and 8 following) a_side_num,
       sum(h_if_side) over(partition by COMPNAME, winname order by ftime rows between current row and 8 following) h_side_num,
       sum(x_if_side) over(partition by COMPNAME, winname order by ftime rows between current row and 8 following) x_side_num,
       sum(y_if_side) over(partition by COMPNAME, winname order by ftime rows between current row and 8 following) y_side_num,
       sum(v_if_monotonicity) over(partition by COMPNAME, winname order by ftime rows between current row and 4 following) v_monotonicity_num,
       sum(a_if_monotonicity) over(partition by COMPNAME, winname order by ftime rows between current row and 4 following) a_monotonicity_num,
       sum(h_if_monotonicity) over(partition by COMPNAME, winname order by ftime rows between current row and 4 following) h_monotonicity_num,
       sum(x_if_monotonicity) over(partition by COMPNAME, winname order by ftime rows between current row and 4 following) x_monotonicity_num,
       sum(y_if_monotonicity) over(partition by COMPNAME, winname order by ftime rows between current row and 4 following) y_monotonicity_num,
       sum(v_if_out) over(partition by COMPNAME, winname order by ftime rows between current row and 99 following) v_out_num,
       sum(a_if_out) over(partition by COMPNAME, winname order by ftime rows between current row and 99 following) a_out_num,
       sum(h_if_out) over(partition by COMPNAME, winname order by ftime rows between current row and 99 following) h_out_num,
       sum(x_if_out) over(partition by COMPNAME, winname order by ftime rows between current row and 99 following) x_out_num,
       sum(y_if_out) over(partition by COMPNAME, winname order by ftime rows between current row and 99 following) y_out_num
  from solder_20170406_d_3 t;
