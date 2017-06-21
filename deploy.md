### 安装环境
    三节点 [166.111.7.244，166.111.7.245，166.111.7.246]
    Ubuntu 14.04.4
    JDK8
    cassandra 3.0.1 
    spark 2.0.0
    scala 2.11.8
    tableau 10

### SSH免密匙登陆
    $ ssh-keygen -t rsa  

一路回车直至结束, 默认情况下会在~/.ssh文件夹下生成两个文件,id_rsa和id_rsa.pub, 将id_rsa.pub输出到authorized_keys文件中。  
 
    $ cd ~/.ssh  
    $ cat id_rsa.pub >>authorized_key_1  

所有的机器上均执行上述操作生成authorized_key_* 文件后，将所有机器上的authorized_key_* 文件拷贝到第一台机器的~/.ssh文件夹下。  

    cst@s2:~/.ssh$ scp authorized_key_2 cst@s1:~/.ssh/authorized_key_2  
    cst@s3:~/.ssh$ scp authorized_key_3 cst@s1:~/.ssh/authorized_key_3  

在pc1上将所有的authorized_keys合并为一个  

    cat authorized_keys_* > authorized_keys  

将authorized_keys发送到每台机器  

    cst@s1:~/.ssh$ scp authorized_keys cst@166.111.7.245:~/.ssh/authorized_keys  
    cst@s1:~/.ssh$ scp authorized_keys cst@166.111.7.246:~/.ssh/authorized_keys

将authorized_keys文件的权限改为600，每台机子上操作：  

    $ chmod 600 authorized_keys  

在任何一台机器上使用ssh 免密码登陆，则说明配置成功  

### 安装JDK

    $ cd /home/cst/src  
    $ tar -zxvf  jdk-8u111-linux-x64.gz  
    $ mv jdk-8u111-linux-x64.gz java  
    $ vim ~/.bashrc  

解压后 编辑bashrc文件添加以下内容

    # setting java
    export JAVA_HOME=/home/cst/src/java
    export PATH=$JAVA_HOME/bin:$PATH

wq 保存退出  

    #source ~/.bashrc  
 
更新成功，其余两台机子上执行相同操作。

### cassandra 分布式部署
安装cassandra  

    $ tar -zxvf  apache-cassandra-3.0.10-bin.tar.gz  
    $ mv apache-cassandra-3.0.10-bin.tar.gz cassandra  
 
按照默认配置创建相关的目录  

    $ sudo mkdir -p /var/log/cassandra  
    $ sudo mkdir -p /var/lib/cassandra  
    $ sudo chown -R cst /var/log/cassandra  
    $ sudo chown -R cst /var/lib/cassandra  

修改cassandra.yaml文件，把对应的IP地址改掉。  
第一台作为种子节点 -seeds: "166.111.7.244"   
然后配置节点之前通信的IP地址：listen_address: 166.111.7.244  
Cassandra Thrift 客户端（应用程序）访问的IP地址：rpc_address: 166.111.7.244  
另外的两台机子上执行相同的操作，cassandra.yaml文件：seeds: "166.111.7.244" 不变，listen_address 和 rpc_address 为实际机器的IP地址。  

启动集群  
先启动种子节点，后启动另外两个节点  

    $ /bin/cassandra -f  

等待输出日志，另外一台机子执行相同的操作时会看到前面的电脑上输出如下信息：
![cassandra log](https://github.com/Fengpiao/solder-paste-inspection/blob/master/images/log.png)

进入交互式  

    $ bin/cqlsh 166.111.7.244  
    cqlsh> create keyspace rocket with replication = { 'class' : 'SimpleStrategy', 'replication_factor' : 3};  
    cqlsh> USE rocket;  
    cqlsh:rocket> create table rocket_temp(RN int,SAMPLE varchar,TIMES float,P float,T1 float,T2 float,U float,Z1 float,Z2 float,K1 int,K2 int,PRIMARY kEY(RN,SAMPLE,TIMES));  
    cqlsh:rocket> COPY rocket_temp(RN,SAMPLE,TIMES,P,T1,T2,U,Z1,Z2,K1,K2) FROM '/home/cst/src/rocket_10samples_temp.csv' with delimiter =',' and header =TRUE;  

### 安装scala

    $ tar -zxvf  scala-2.11.8.tgz  
    $ mv scala-2.11.8.tgz scala  
    
编辑bashrc文件添加以下内容  

    # setting scala  
    export SCALA_HOME=/home/cst/src/scala  
    export PATH=$SCALA_HOME/bin:$PATH  
    
wq 保存退出。  

    # source ~/.bashrc  
 
其余两台机子上执行相同操作

### spark集群配置  
安装spark  

    $ tar -zxvf  spark-2.0.0-bin-hadoop2.7.tgz  
    $ mv spark-2.0.0-bin-hadoop2.7.tgz spark  

编辑bashrc文件添加以下内容  

    # setting spark  
    export SPARK_HOME=/home/cst/src/spark  
    export PATH=$SPARK_HOME/bin:$PATH  
    
wq 保存退出。  

    # source ~/.bashrc  
 
其余两台机子上执行相同操作。  

编辑spark-env.sh文件  

    $ cp conf/spark-env.sh.template conf/spark-env.sh  
    $ vim conf/spark-env.sh  

在底部加上  

    export JAVA_HOME=/home/cst/src/java  
    export SCALA_HOME=/home/cst/src/scala  
    export SPARK_MASTER_IP=166.111.7.244  

修改配置文件slaves，加上所有的work节点  

    $ cp conf/slaves.template conf/slaves  
    $ vim conf/slaves  
    # A Spark Worker will be started on each of the machines listed below.
    166.111.7.245  
    166.111.7.246  

编辑spark-defaults.conf  

    $ cp conf/spark-defaults.conf.template conf/spark-defaults.conf  
    $ vim conf/spark-defaults.conf  
    
在末尾添加上  

    spark.cassandra.connection.host    166.111.7.244,166.111.7.245,166.111.7.246  

scp给两外两台机器  

    $ scp -r spark cst@166.111.7.245:/home/cst/src/  
    $ scp -r spark cst@166.111.7.246:/home/cst/src/  

启动spark集群,主节点执行  

    $ sbin/start-all.sh  

主节点进入spark shell  

    $ bin/spark-shell --jars /home/cst/src/spark-cassandra-connector.jar  
    (spark-cassandra-connector.jar是已经提前编译好的，如果cassandra和spark的版本号改变了, spark-cassandra-connector.jar 需要另行编译。)  
    scala> sc.stop  
    scala> import com.datastax.spark.connector._, org.apache.spark.SparkContext, org.apache.spark.SparkContext._, org.apache.spark.SparkConf  
    scala> val conf = new SparkConf(true).set("spark.cassandra.connection.host", "166.111.7.244")  
    scala> val sc = new SparkContext(conf)  
    scala> var rdd = sc.cassandraTable("rocket","rocket_temp")  
    scala> rdd.first  

启动thriftserver 

    $ sbin/start-thriftserver.sh --hiveconf hive.server2.thrift.bind.host 166.111.7.244 --hiveconf hive.server2.thrift.port 10000 --jars /home/cst/src/spark-cassandra-connector.jar --driver-class-path /home/cst/src/spark-cassandra-connector.jar  
    $ ./bin/beeline  
    beeline> !connect jdbc:hive2://166.111.7.244:10000  
    Connecting to jdbc:hive2://166.111.7.244:10000  
    Enter username for jdbc:hive2://166.111.7.244:10000: cassandra  
    Enter password for jdbc:hive2://166.111.7.244:10000: *********  
    log4j:WARN No appenders could be found for logger (org.apache.hive.jdbc.Utils).  
    log4j:WARN Please initialize the log4j system properly.  
    log4j:WARN See http://logging.apache.org/log4j/1.2/faq.html#noconfig for more info.  
    Connected to: Spark SQL (version 2.0.0)  
    Driver: Hive JDBC (version 1.2.1.spark2)  
    Transaction isolation: TRANSACTION_REPEATABLE_READ  

    jdbc:hive2://166.111.7.244:10000> create database mykeyspace;  
    jdbc:hive2://166.111.7.244:10000> use mykeyspace;  
    jdbc:hive2://166.111.7.244:10000> CREATE TABLE rocket_table USING org.apache.spark.sql.cassandra OPTIONS (cluster 'Test Cluster', keyspace  'mykeyspace', table 'rocket_table');  
    jdbc:hive2://166.111.7.244:10000> select * from rocket_table;  

SQL server 通过ODBC连接cassandra+spark集群。
参照 http://wiki.servicenow.com/index.php?title=Using_ODBC_Driver_in_SQL_Server#gsc.tab=0

另外也可以通过配置访问接口字符串的方法
"[Provider=MSDASQL;] { DSN=Simba Spark };  
[DATABASE=mykeyspace;] UID=cassandra; PWD=cassandra"

配好后查询语句：
select * from OPENQUERY(SPARK, 'select * from [rocket_temp] limit 10') a
