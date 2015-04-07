# ZbxGraphGetter

ZbxGrphGetter is chart picture collection ruby module for Zabbix.
(Made for only to get chart picture via Zabbix API.)

IF you want to find and use the other functions, then I strongly reccomend to use 'zabbixapi', 'zbxapi', and so on.

##Specification and Excuse
 - This tool supports only zabbix 2.0.x, 2.2.x, snd 2.4.x.
 - This tool tested on ruby 2.0.0p481.
 - All Chart files are downloaded by current directory.
 - This tool use hostlist-file. The hostlist-file generated automatically. (All of the hostname that registered on Zabbix are written in the hostlist-file.) 

##Usage
###1.Clone files your local directory
 > `git clone` or download *.rb files.

###2.Modifying 'client.rb'
`# ZabbixAuth`  
`USER = 'admin'`  
`PASSWORD = 'zabbix'`  

`# ZabbixServer Address or FQDN`  
`HOST = '192.168.33.101'`  

`# ZabbixServer Version X.Y`  
`ZBXVER = 2.4`  

`# FileListHeader (Required for getting graphs.)`  
`FNAME = 'hoge'`  

`# Graph width`  
`WD = 550 `  

`# Graph height`  
`HG = 100`  

`# Graph period`  
`# Example : 1day == '86400', 30days == '2592000' , 1year == '31536000'`  
`PD = '2592000'`  

`# GraphStartTime`  
`# Format : 'YYYYmmddHHMMSS'`  
`ST = '20150401000000'`  

###3.Run
`$ ruby client.rb` 

## Tips
 - If you want to get selected graphs manually.
 
 ####1.Modifying *'hoge_hostlist.txt'*
  `hoge_01`
  `hoge_02`
  `Zabbix Server`
  
  > Remain hostnames that you want to collect.
 
 ####2.Modifying *'client.rb'*
   `### Your Code Section`
   `fuga = ZbxGraphGetter.new`
   `fuga.http_request(fuga.auth_json)` 
   `fuga.http_request(fuga.host_json) `
   `fuga.png_getter`
 
 ####3.Run
 `$ ruby client.rb`
  
