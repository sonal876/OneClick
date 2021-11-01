#!/bin/sh
read -t 5 -p "Enter Username: "  userInput

echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Checking for Ubuntu system updates>>>>>"

sudo apt-get update
sudo apt-get upgrade


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Looking for kockpit-tools directory>>>>>"
echo " "

echo "Searching for kockpit-tools directory"
if [[ -d "/home/$userInput/kockpit-tools" ]]
then
    echo "kockpit-tools directory exists"
else
    echo "Directory does not exist. Creating now"
    sudo mkdir kockpit-tools
fi


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Installing Java>>>>>"
echo " "

echo "Looking for JAVA in your system."
if [[ -d "/home/$userInput/kockpit-tools/java-8-openjdk-amd64" ]]
then
    echo "JAVA is already installed in your filesystem."
else
    echo "JAVA does not exist. Installing JAVA"
    sudo apt install openjdk-8-jdk-headless
    sudo cp -r /usr/lib/jvm/java-8-openjdk-amd64 /home/$userInput/kockpit-tools/
fi

read -t 5 -p "Java Version is: "
java -version
read -t 5 -p "   "


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Installing Python>>>>>"
echo " "

echo "Looking for Python in your system."
if [[ -d "/home/$userInput/kockpit-tools/Python-3.6.5" ]]
then
    echo "Python is already installed in your filesystem."
else
    echo "Python does not exist. Installing Python"
    sudo apt install python3
    cd /home/$userInput/kockpit-tools/
    sudo wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tgz
    sudo tar -xvf Python-3.6.5.tgz
    sudo rm -rf Python-3.6.5.tgz
    sudo apt install python3-testresources
    sudo apt install python3-pip
    python3 -m pip install -U pip
fi

read -t 5 -p "Python Version is: "
python3 --version
read -t 5 -p "   "

echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Installing Hadoop>>>>>"
echo " "


echo "Looking for HADOOP in your system."
if [[ -d "/home/$userInput/kockpit-tools/hadoop-3.2.2" ]]
then
    echo "HADOOP is already installed in your filesystem."
else
    echo "HADOOP does not exist. Downloading HADOOP"
    cd /home/$userInput/kockpit-tools/
    sudo wget https://mirrors.estointernet.in/apache/hadoop/common/hadoop-3.2.2/hadoop-3.2.2.tar.gz

    sudo tar -xvf hadoop-3.2.2.tar.gz
    sudo rm -rf hadoop-3.2.2.tar.gz
    sudo mkdir /home/$userInput/kockpit-tools/hadoop_store/
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop_store
    sudo mkdir -p /home/$userInput/kockpit-tools/hadoop_store/hdfs/namenode
    sudo mkdir -p /home/$userInput/kockpit-tools/hadoop_store/hdfs/datanode
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop_store/hdfs/namenode
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop_store/hdfs/datanode

    read -p "Enter your username for change of ownership from root to user: "
    
    sudo chown -R $REPLY.root /home/$userInput/kockpit-tools/hadoop_store/hdfs
    sudo chmod 777 /home/$userInput/kockpit-tools
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop
    cd /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/

    echo " "

    a=1
    x=1
    while [ $x -le $a ]
    do
      read -p "Enter the master cluster IP which you want to add in your master file: "
      printf "You entered %s " "$REPLY"
      # If userInput is not empty show what the user typed in and run ls -l
    
      read -p "Continue (y/n)?" choice
      case "$choice" in
        y|Y ) sudo echo "$REPLY" >> master
                  x=$(( $x + 1 ));;
        n|N ) echo "no";;
        * ) echo "invalid";;
      esac
    done

    echo " "

    #echo "$userInputhost" > master
    #sudo touch workers
    #echo "$userInputhost" > workers
    sudo touch workers
    a=1
    x=1
    while [ $x -le $a ]
    do
      read -p "Enter the slave cluster IP which you want to add in your slaves file: "
      printf "You entered %s " "$REPLY"
      # If userInput is not empty show what the user typed in and run ls -l
    
      read -p "Continue (y/n)?" choice
      case "$choice" in
        y|Y ) sudo echo "$REPLY" >> workers
                  x=$(( $x + 1 ));;
        n|N ) echo "no";;
        * ) echo "invalid";;
      esac
      #sudo echo "$REPLY" >> hosts
    done
    echo " "


    cd /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/

    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/core-site.xml
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/hdfs-site.xml
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/mapred-site.xml
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/yarn-site.xml


    sudo rm core-site.xml
    sudo rm hdfs-site.xml
    sudo rm mapred-site.xml
    sudo rm yarn-site.xml


    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/hadoop-env.sh
    echo "export JAVA_HOME=/home/$userInput/kockpit-tools/java-8-openjdk-amd64" >> hadoop-env.sh
    
    echo "==================================================="
    read -t 5 -p "Setting up the configuration files in /etc/hadoop" 
    echo " "

    sudo touch core-site.xml
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/core-site.xml
    sudo echo "  <configuration>
                        <property>
                                  <name>fs.defaultFS</name>
                                  <value>hdfs://localhost:9000</value>
                        </property>
            </configuration>" >> core-site.xml

           
    read -p "Enter the number of servers you want to replicate data: "
    sudo touch hdfs-site.xml
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/hdfs-site.xml
    sudo echo "  <configuration>
                            <property> 

                                      <name>dfs.replication</name> 
                                      <value>$REPLY</value> 

                            </property> 
                            <property>
                                      <name>dfs.namenode.name.dir</name>
                                      <value>file:/home/$userInput/kockpit-tools/hadoop_store/hdfs/namenode</value>
                            </property>
                            <property>
                                      <name>dfs.datanode.data.dir</name>
                                      <value>file:/home/$userInput/kockpit-tools/hadoop_store/hdfs/datanode</value>
                            </property>
            </configuration>" >> hdfs-site.xml   

    sudo touch mapred-site.xml
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/mapred-site.xml
    sudo echo "  <configuration>
                            <property>
                                     <name>mapreduce.framework.name</name>
                                     <value>yarn</value>
                            </property>
                            <property>
                                     <name>mapred.job.tracker</name>
                                     <value>localhost:54311</value>
                            </property>
            </configuration>" >> mapred-site.xml

    sudo touch yarn-site.xml
    sudo chmod 777 /home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop/yarn-site.xml
    sudo echo "  <configuration>
                            <property>
                                     <name>yarn.resourcemanager.resource-tracker.address</name>
                                     <value>localhost:8025</value>
                            </property>
                            <property>
                                     <name>yarn.resourcemanager.scheduler.address</name>
                                     <value>localhost:8030</value>
                            </property>
                            <property>
                                     <name>yarn.resourcemanager.address</name>
                                     <value>localhost:8050</value>
                            </property>
                            <property>
                                     <name>yarn.nodemanager.aux-services</name>
                                     <value>mapreduce_shuffle</value>
                            </property>
                            <property>
                                     <name>yarn.nodemanager.aux-services.mapreduce.shuffle.class</name>
                                     <value>org.apache.hadoop.mapred.ShuffleHandler</value>
                            </property>
                            <property>
                                     <name>yarn.nodemanager.disk-health-checker.min-healthy-disks</name>
                                     <value>0</value>
                            </property>         
            </configuration>" >> yarn-site.xml        

fi


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Installing Hive>>>>>" 
echo " "
echo "Looking for Hive in your system."
if [[ -d "/home/$userInput/kockpit-tools/apache-hive-3.1.2-bin" ]]
then
    echo "Hive is already installed in your filesystem."
else
    echo "Hive does not exist. Downloading Hive"
    cd /home/$userInput/kockpit-tools/
    sudo wget https://downloads.apache.org/hive/hive-3.1.2/apache-hive-3.1.2-bin.tar.gz
    sudo tar xzf apache-hive-3.1.2-bin.tar.gz
    cd /home/$userInput/kockpit-tools/apache-hive-3.1.2-bin/bin/
    sudo chmod 777 hive-config.sh 
    echo "export HADOOP_HOME=/home/$userInput/kockpit-tools/hadoop-3.2.2" >> hive-config.sh
    cd /home/$userInput/kockpit-tools/apache-hive-3.1.2-bin/conf/
    sudo wget https://github.com/Anmol-Recker/Hive/archive/refs/heads/main.zip
    sudo apt install unzip
    sudo unzip main.zip
    cd /home/$userInput/kockpit-tools/apache-hive-3.1.2-bin/conf/Hive-main/
    sudo mv hive-site.xml /home/$userInput/kockpit-tools/apache-hive-3.1.2-bin/conf/
    cd /home/$userInput/kockpit-tools/apache-hive-3.1.2-bin/lib/
    sudo rm guava-19.0.jar
    sudo wget https://github.com/Anmol-Recker/Hive/raw/main/guava-27.0-jre.jar
fi


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Installing Spark>>>>>" 
echo " "

echo "Looking for Spark in your system."
if [[ -d "/home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2" ]]
then
    echo "Spark is already installed in your filesystem."
else
    echo "Spark does not exist. Downloading Spark"
    cd /home/$userInput/kockpit-tools/
    sudo wget https://mirrors.estointernet.in/apache/spark/spark-3.1.2/spark-3.1.2-bin-hadoop3.2.tgz
    sudo tar -xvf spark-3.1.2-bin-hadoop3.2.tgz
    sudo rm -rf spark-3.1.2-bin-hadoop3.2.tgz
    sudo chmod 777 /home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2
    
    cd /home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2/conf/
    
    sudo touch spark-env.sh
    sudo chmod 777 /home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2/conf/spark-env.sh

    echo "Example for how to create worker cores and memory"
    echo "export SPARK_WORKER_CORES=32"
    echo "export SPARK_WORKER_MEMORY=60g"

    read -p "Enter number of Spark Worker Cores: "
    sudo echo "export SPARK_WORKER_CORES=$REPLY" >> spark-env.sh

    read -p "Enter your Spark Worker Memory: "
    sudo echo "export SPARK_WORKER_MEMORY=$REPLY" >> spark-env.sh

    
    sudo echo "export JAVA_HOME=/home/$userInput/kockpit-tools/java-8-openjdk-amd64" >> spark-env.sh

    cd /home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2/jars

    sudo wget --no-check-certificate --content-disposition https://github.com/anmolpal/Spark-Drivers/raw/main/sqljdbc42.jar

    sudo wget --no-check-certificate --content-disposition https://github.com/anmolpal/Spark-Drivers/raw/main/postgresql-42.2.20.jre7.jar

    sudo wget --no-check-certificate --content-disposition https://github.com/anmolpal/Spark-Drivers/raw/main/mssql-jdbc-7.2.0.jre8.jar

fi


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Configuring SSH>>>>>" 
echo " "

echo "Do you want to add SSH key to the home directory? [yes/no]"
read  x
if [[ "${x}" = "yes" ]]
then
    echo "Installing openssh-server"
    sudo apt-get install openssh-server

    ssh-keygen -t rsa

    #sudo chmod 777 $HOME/.ssh
    #sudo chmod 777 $HOME/.ssh/authorized_keys
    #sudo chmod 777 $HOME/.ssh/authorized_keyscat

    sudo cat ~/.ssh/id_rsa.pub >>  ~/.ssh/authorized_keys

    chmod 700 ~/.ssh/

    #cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys


    #cd /home/$userInput/kockpit-tools/hadoop-3.2.2/bin
    #hdfs namenode -format
    #start-dfs.sh
    #start-yarn.sh
    sudo service ssh --full-restart

    service ssh status
    
else
    echo "No SSH key added"
fi


#cd /home/$userInput/kockpit-tools/
#start-master.sh
#start-slaves.sh

echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Adding Paths to .bashrc>>>>>" 
echo " "

echo "Do you want to add PATH to .bashrc? [yes/no]"
read  x
if [[ "${x}" = "yes" ]]
then
    echo "export JAVA_HOME=/home/$userInput/kockpit-tools/java-8-openjdk-amd64" >> ~/.bashrc

    echo "export HADOOP_HOME=/home/$userInput/kockpit-tools/hadoop-3.2.2" >> ~/.bashrc
    echo 'export PATH=$PATH:'"/home/$userInput/kockpit-tools/hadoop-3.2.2/bin" >> ~/.bashrc
    echo 'export PATH=$PATH:'"/home/$userInput/kockpit-tools/hadoop-3.2.2/sbin" >> ~/.bashrc
    echo "export HADOOP_MAPRED_HOME=/home/$userInput/kockpit-tools/hadoop-3.2.2" >> ~/.bashrc
    echo "export HADOOP_COMMON_HOME=/home/$userInput/kockpit-tools/hadoop-3.2.2" >> ~/.bashrc
    echo "export HADOOP_HDFS_HOME=/home/$userInput/kockpit-tools/hadoop-3.2.2" >> ~/.bashrc
    echo "export YARN_HOME=/home/$userInput/kockpit-tools/hadoop-3.2.2" >> ~/.bashrc
    echo "export HADOOP_CONF_DIR=/home/$userInput/kockpit-tools/hadoop-3.2.2/etc/hadoop" >> ~/.bashrc
    echo "export HADOOP_COMMON_local_NATIVE_DIR=/home/$userInput/kockpit-tools/hadoop-3.2.2/local/native" >> ~/.bashrc

    echo "export SPARK_HOME=/home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2" >> ~/.bashrc
    echo 'export PATH=$PATH:'"/home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2/bin" >> ~/.bashrc
    echo 'export PATH=$PATH:'"/home/$userInput/kockpit-tools/spark-3.1.2-bin-hadoop3.2/sbin" >> ~/.bashrc
    echo 'export LD_localRARY_PATH=$HADOOP/local/native:$LD_localRARY_PATH' >> ~/.bashrc
    echo "export PYSPARK_PYTHON=/usr/bin/python3" >> ~/.bashrc
    echo 'export PYSPARK_DRIVER_PYTHON=$PYSPARK_PYTHON' >> ~/.bashrc
    echo "export HIVE_HOME=/home/$userInput/kockpit-tools/apache-hive-3.1.2-bin" >> ~/.bashrc
    echo 'export PATH=$PATH:$HIVE_HOME/bin' >> ~/.bashrc

    
else
    echo "No Path added to .bashrc"
fi


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Setup Delta Lake v1.0.0>>>>>" 
echo " "

echo "Do you want to Install DeltaLake? [yes/no]"
read  x
if [[ "${x}" = "yes" ]]
then
    pyspark --packages io.delta:delta-core_2.12:1.0.0 --conf "spark.sql.extensions=io.delta.sql.DeltaSparkSessionExtension" --conf "spark.sql.catalog.spark_catalog=org.apache.spark.sql.delta.catalog.DeltaCatalog"
else
    echo "Delta Lake Installation Skipped."
fi


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Installing Airflow V2.1>>>>>" 
echo " "

echo "Looking for Apache Airflow in your system." 
if [[ -d "/home/$userInput/kockpit-tools/env_airflow" ]] 
then 
    echo "Apache Airflow is already installed in your filesystem." 

    echo "Do you want start the airflow webserver? [yes/no]" 

    read  x 

    if [[ "${x}" = "yes" ]] 

    then     

        cd /home/$userInput/kockpit-tools/ 

        source env_airflow/bin/activate 

        airflow webserver -p 8181 -d 

        source env_airflow/bin/activate 

        airflow scheduler 

    else 

        echo "Airflow webserver is stopped" 

    fi     

else 
    echo "Apache Airflow does not exist. Downloading Apache Airflow"
    cd /home/$userInput/kockpit-tools/
    sudo -H pip3 install --ignore-installed PyYAML
    sudo apt install python3-pip
    sudo apt-get install python3-venv
    sudo python3 -m venv env_airflow
    source env_airflow/bin/activate
    sudo pip3 install apache-airflow
    airflow db init
    cd /home/$userInput/kockpit-tools/
    flask fab
    airflow users  create --role Admin --username admin --email admin --firstname admin --lastname admin --password admin
    cd /home/$userInput/airflow/
    sudo mkdir dags
    cd /home/$userInput/kockpit-tools/
    source env_airflow/bin/activate
    airflow webserver -p 8181 -d
    source env_airflow/bin/activate
    airflow scheduler
fi


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Hadoop and Spark daemons>>>>>"
echo " "

echo "Do you want start all the hadoop and spark daemons? [yes/no]" 
read  x 

if [[ "${x}" = "yes" ]] 

then  
    hdfs namenode -format
    start-dfs.sh
    start-yarn.sh
    start-master.sh
    start-slaves.sh
    
    cd /home/$userInput/kockpit-tools/
    source env_airflow/bin/activate
    #airflow scheduler
else
    echo "You have selected not start the hadoop and spark daemons"     
fi

echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Hive Path to HDFS>>>>>"
echo " "
echo "Do you want to add Hadoop Path to HDFS? [yes/no]"
read  x
if [[ "${x}" = "yes" ]]
then
    cd /home/$userInput/
    hdfs dfs -mkdir /tmp
    hdfs dfs -chmod g+w /tmp
    hdfs dfs -ls /
    hdfs dfs -mkdir -p /user/hive/warehouse
    hdfs dfs -chmod g+w /user/hive/warehouse
    hdfs dfs -ls /user/hive
    cd /home/$userInput/
    $HIVE_HOME/bin/schematool -dbType derby -initSchema
else
    echo "No Paths in HDFS"     
fi  


echo " "
echo "==================================================="
echo "==================================================="
read -t 5 -p "<<<<<Installing Presto>>>>>"
echo " "
echo "Do you want to Install Presto? [yes/no]"
read  x
if [[ "${x}" = "yes" ]]
then
    cd /home/$userInput/kockpit-tools/
    sudo wget https://repo1.maven.org/maven2/com/facebook/presto/presto-server/0.261/presto-server-0.261.tar.gz
    sudo tar -xvf presto-server-0.261.tar.gz
    cd /home/$userInput/kockpit-tools/presto-server-0.261/
    sudo wget http://media.sundog-soft.com/hadoop/presto-hdp-config.tgz
    sudo tar -xvf presto-hdp-config.tgz
    cd /home/$userInput/kockpit-tools/presto-server-0.261/bin/
    sudo wget https://repo1.maven.org/maven2/com/facebook/presto/presto-cli/0.260.1/presto-cli-0.260.1-executable.jar
    sudo mv presto-cli-0.260.1-executable.jar presto
    sudo chmod +x presto
    sudo apt -y install python
    sudo ./launcher start
    cd /var/presto/data/var/log
    tail 1000 -f server.log
else
    echo "Presto not installed"     
fi     








