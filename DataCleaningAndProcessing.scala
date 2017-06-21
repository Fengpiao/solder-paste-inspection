import org.apache.spark.sql.SQLContext
val sqlContext = new SQLContext(sc)

val solder_2017 = sqlContext.read.format("com.databricks.spark.csv").option("header","true").option("inferSchema","true").load("/home/agittarius/SolderPB5A2017.csv")
solder_2017.createOrReplaceTempView("solder_2017")

val board_2017 = sqlContext.read.format("com.databricks.spark.csv").option("header","true").option("inferSchema","true").load("/home/agittarius/BoardPB5A2017.csv")
board_2017.createOrReplaceTempView("board_2017")

val board_solder_info_201704 = spark.sql("select t1.fdate, t1.compname, t1.winname, t1.status as status_s, t1.v, t1.a, t1.h, t1.px, t1.py, t2.cmodel, t2.status as status_b, t2.boardsn from solder_2017 t1,(select distinct fdate,cmodel,status,boardsn from board_2017 where status <> 'SKIP') t2 where t1.fdate =t2.fdate and t1.status <> 'SKIP'")
board_solder_info_201704.createOrReplaceTempView("board_solder_info_201704")

val solder_201704_d = spark.sql("select substr(fdate,1,10) fdate, cmodel, compname, winname, count(1) num, sum(case when status_s ='FAIL' then 1 else 0 end)/count(1) rpass_rate_s, sum(case when status_b ='FAIL' then 1 else 0 end)/count(1) rpass_rate_b, round(max(v),2) v_max, round(min(v),2) v_min, round(avg(v),2) v_avg, round(std(v),2) v_std, percentile_approx(v,0.1) v_10, percentile_approx(v,0.5) v_median, percentile_approx(v,0.9) v_90, round(max(a),2) a_max, round(min(a),2) a_min, round(avg(a),2) a_avg, round(std(a),2) a_std,percentile_approx(a,0.1) a_10, percentile_approx(a,0.5) a_median, percentile_approx(a,0.9) a_90, round(max(h),2) h_max, round(min(h),2) h_min, round(avg(h),2) h_avg, round(std(h),2) h_std,percentile_approx(h,0.1) h_10, percentile_approx(h,0.5) h_median, percentile_approx(h,0.9) h_90, round(max(px),2) x_max, round(min(px),2) x_min, round(avg(px),2) x_avg, round(std(px),2) x_std, percentile_approx(px,0.1) x_10, percentile_approx(px,0.5) x_median, percentile_approx(px,0.9) x_90, round(max(py),2) y_max, round(min(py),2) y_min, round(avg(py),2) y_avg, round(std(py),2) y_std, percentile_approx(py,0.1) y_10, percentile_approx(py,0.5) y_median, percentile_approx(py,0.9) y_90 from board_solder_info_201704 group by substr(fdate,1,10), cmodel,compname,winname")
solder_201704_d.write.format("com.databricks.spark.csv").save("/home/agittarius/solder_201704_d")

val board_201704_d = spark.sql("select fdate, cmodel, boardsn,status_b, count(1) num, sum(case when status_s ='FAIL' then 1 else 0 end)/count(1) rpass_rate_s, round(max(px),2) x_max, round(min(px),2) x_min, round(avg(px),2) x_avg, round(std(px),2) x_std, percentile_approx(px,0.1) x_10, percentile_approx(px,0.5) x_median, percentile_approx(px,0.9) x_90, round(max(py),2) y_max, round(min(py),2) y_min, round(avg(py),2) y_avg, round(std(py),2) y_std, percentile_approx(py,0.1) y_10, percentile_approx(py,0.5) y_median, percentile_approx(py,0.9) y_90 from board_solder_info_201704 group by fdate, cmodel, boardsn, status_b")
board_201704_d.write.format("com.databricks.spark.csv").save("/home/agittarius/board_201704_d")

val solders_2017_fail = spark.sql("select t1.*, t2.cmodel, t2.status status_b, t2.boardsn from solder_2017 t1,(select distinct fdate,cmodel,status,boardsn from board_2017 where status <> 'SKIP') t2,(select substr(fdate,1,10) fdate, compname, winname, sum(case when status ='FAIL' then 1 else 0 end) fail_num from solder_2017 group by substr(fdate,1,10), compname, winname) t3 where t1.fdate =t2.fdate and t1.fdate =t3.fdate and t1.compname = t3.compname and t1.winname =t3.winname and t1.status <> 'SKIP' and t3.fail_num > 50")
solders_2017_fail.write.format("com.databricks.spark.csv").save("/home/agittarius/solders_2017_fail")

val solder_20170406 = spark.sql("select t1.*, t2.cmodel, t2.status status_b, t2.boardsn from (select * from solder_2017 where substr(fdate,1,10) ='2017-04-06' and status <> 'SKIP')t1,(select distinct fdate,cmodel,status,boardsn from board_2017 where status <> 'SKIP') t2 where t1.fdate =t2.fdate")
solder_20170406.write.format("com.databricks.spark.csv").save("/home/agittarius/solder_20170406")


val solder_20170406 = sqlContext.read.format("com.databricks.spark.csv").option("header","true").option("inferSchema","true").load("/home/agittarius/solder_20170406/solder_20170406.csv")
solder_20170406.createOrReplaceTempView("solder_20170406")


val solder_2017_fail = spark.sql("select t1.*, t2.cmodel, t2.status status_b, t2.boardsn from solder_2017 t1,(select distinct fdate,cmodel,status,boardsn from board_2017 where status <> 'SKIP') t2,(select substr(fdate,1,10) fdate, compname, winname, sum(case when status ='FAIL' then 1 else 0 end) fail_num from solder_2017 group by substr(fdate,1,10), compname, winname) t3 where t1.fdate =t2.fdate and substr(t1.fdate,1,10) = t3.fdate and t1.compname = t3.compname and t1.winname =t3.winname and t1.status <> 'SKIP' and t3.fail_num > 10")
solder_2017_fail.write.format("com.databricks.spark.csv").save("/home/agittarius/solder_2017_fail")

val solder_201704_3sigma =spark.sql("select cmodel, compname, winname, count(1) num, sum(case when status_s ='FAIL' then 1 else 0 end) fail_num, round(avg(v),2) v_avg, round(std(v),2) v_std,round(avg(a),2) a_avg, round(std(a),2) a_std, round(avg(h),2) h_avg, round(std(h),2) h_std, round(avg(px),2) x_avg, round(std(px),2) x_std, round(avg(py),2) y_avg, round(std(py),2) y_std from board_solder_info_201704 group by cmodel,compname,winname")
solder_201704_3sigma.write.format("com.databricks.spark.csv").save("/home/agittarius/solder_201704_3sigma")
