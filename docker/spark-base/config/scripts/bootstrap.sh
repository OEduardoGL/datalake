/etc/init.d/ssh start

if [[ $HOSTNAME = spark-master ]]; then
    
    hdfs namenode -format

    $HADOOP_HOME/sbin/start-dfs.sh
    $HADOOP_HOME/sbin/start-yarn.sh

    service mysql start

    hdfs dfs -mkdir /raw
    hdfs dfs -mkdir /clean
    hdfs dfs -mkdir /enrich
    hdfs dfs -mkdir /sandbox

    # Configs de Hive, configurando o metastore, definindo senha, etc...
    mysql -u root -Bse \
    "CREATE DATABASE metastore; \
    USE metastore; \
    SOURCE /usr/hive/scripts/metastore/upgrade/mysql/hive-schema-2.3.0.mysql.sql; \
    CREATE USER 'hive'@'localhost' IDENTIFIED BY 'password'; \
    REVOKE ALL PRIVILEGES, GRANT OPTION FROM 'hive'@'localhost'; \
    GRANT ALL PRIVILEGES ON metastore.* TO 'hive'@'localhost' IDENTIFIED BY 'password'; \
    FLUSH PRIVILEGES; quit;"

    nohup hive --service metastore > /dev/null 2>&1 &
    nohup hive --service hiveserver2 > /dev/null 2>&1 &

else
    $HADOOP_HOME/sbin/hadoop-daemon.sh start datanode &
    $HADOOP_HOME/bin/yarn nodemanager &
    
fi

while :; do sleep 2073600; done