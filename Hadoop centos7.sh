
от root:

yum update

yum install java-11-openjdk-devel

java -version

##openjdk version "11.0.19" 2023-04-18 LTS
##OpenJDK Runtime Environment (Red_Hat-11.0.19.0.7-1.el7_9) (build 11.0.19+7-LTS)
##OpenJDK 64-Bit Server VM (Red_Hat-11.0.19.0.7-1.el7_9) (build 11.0.19+7-LTS, mixed mode, sharing)


https://hadoop.apache.org/releases.html

wget https://dlcdn.apache.org/hadoop/common/hadoop-3.3.5/hadoop-3.3.5.tar.gz

mkdir /usr/local/hadoop

tar -zvxf hadoop-*.tar.gz -C /usr/local/hadoop --strip-components 1

adduser hadoop
passwd hadoop

chown -R hadoop:hadoop /usr/local/hadoop
###Создаем файл с профилем:
vi /etc/profile.d/hadoop.sh

export HADOOP_HOME=/usr/local/hadoop
export HADOOP_HDFS_HOME=$HADOOP_HOME
export HADOOP_MAPRED_HOME=$HADOOP_HOME
export HADOOP_COMMON_HOME=$HADOOP_HOME
export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib/native"
export YARN_HOME=$HADOOP_HOME
export PATH="$PATH:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin"

от hadoop:

su - hadoop

vi /usr/local/hadoop/etc/hadoop/hadoop-env.sh
export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.19.0.7-1.el7_9.x86_64

env | grep -i -E "hadoop|yarn"

#MAIL=/var/mail/hadoop
#USER=hadoop
#HADOOP_COMMON_HOME=/usr/local/hadoop
#HOME=/home/hadoop
#HADOOP_COMMON_LIB_NATIVE_DIR=/usr/local/hadoop/lib/native
#LOGNAME=hadoop
#PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/usr/local/hadoop/bin:/usr/local/hadoop/sbin
#YARN_HOME=/usr/local/hadoop
#HADOOP_MAPRED_HOME=/usr/local/hadoop
#HADOOP_HDFS_HOME=/usr/local/hadoop
#HADOOP_HOME=/usr/local/hadoop

hadoop version

#Hadoop 3.3.1
#Source code repository https://github.com/apache/hadoop.git -r a3b9c37a397ad4188041dd80621bdeefc46885f2
#Compiled by ubuntu on 2021-06-15T05:13Z
#Compiled with protoc 3.7.1
#From source with checksum 88a4ddb2299aca054416d6b7f81ca55
#This command was run using /usr/local/hadoop/share/hadoop/common/hadoop-common-3.3.1.jar

ssh-keygen

ssh-copy-id localhost

ssh localhost

exit

vi /usr/local/hadoop/etc/hadoop/core-site.xml (вместо HOSTNAME указать реальный hostname тачки)
<configuration>
   <property>
      <name>fs.default.name</name>
      <value>hdfs://HOSTNAME:9000</value>
   </property>
</configuration>

vi /usr/local/hadoop/etc/hadoop/hdfs-site.xml
<configuration>
   <property>
      <name>dfs.replication</name>
      <value>3</value>
   </property>
   <property>
      <name>dfs.name.dir</name>
      <value>file:///hadoop/hdfs/namenode</value>
   </property>
   <property>
      <name>dfs.data.dir</name>
      <value>file:///hadoop/hdfs/datanode</value>
   </property>
</configuration>

vi /usr/local/hadoop/etc/hadoop/mapred-site.xml
<configuration>
   <property>
      <name>mapreduce.framework.name</name>
      <value>yarn</value>
   </property>
</configuration>

vi /usr/local/hadoop/etc/hadoop/yarn-site.xml
<configuration>

<!-- Site specific YARN configuration properties -->
  <property>
    <name>yarn.nodemanager.aux-services</name>
    <value>mapreduce_shuffle</value>
  </property>
</configuration>

от root:

mkdir -p /hadoop/hdfs/{namenode,datanode}

chown -R hadoop:hadoop /hadoop

от hadoop:

su - hadoop

/usr/local/hadoop/bin/hdfs namenode -format

/usr/local/hadoop/sbin/start-dfs.sh

/usr/local/hadoop/sbin/start-yarn.sh

ipaddres:9870  -  заходим на веб морду хадупа

можно создать юнит systemd

vi /usr/lib/systemd/system/hdfs.service 
[Unit]
Description=Hadoop DFS namenode and datanode & yarn service
After=syslog.target network-online.target

[Service]
User=hadoop
Group=hadoop
Type=oneshot
ExecStart=/usr/local/hadoop/sbin/start-dfs.sh
ExecStop=/usr/local/hadoop/sbin/stop-dfs.sh
WorkingDirectory=/usr/local/hadoop
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target


vi /usr/lib/systemd/system/yarn.service 
[Unit]
Description=Hadoop DFS namenode and datanode & yarn service
After=syslog.target network-online.target

[Service]
User=hadoop
Group=hadoop
Type=oneshot
ExecStart=/usr/local/hadoop/sbin/start-yarn.sh
ExecStop=/usr/local/hadoop/sbin/stop-yarn.sh
WorkingDirectory=/usr/local/hadoop
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target


ГОТОВО