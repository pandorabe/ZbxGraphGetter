# coding: utf-8
require './ZbxGraphGetter'

### Configuration Section
## ZabbixAPI Section
# ZabbixAuth
USER = 'admin'
PASSWORD = 'zabbix'
# ZabbixServer Address or FQDN
HOST = '192.168.33.101'
APIPAGE = "http://#{HOST}/zabbix/api_jsonrpc.php"
# ZabbixServer Version X.Y
ZBXVER = 2.4

## Graphs Section
# FileListHeader (Required for getting graphs.)
FNAME = 'hoge'
# Graph width
WD = 550 
# Graph height
HG = 100
# Graph period
# Example : 1day == '86400', 30days == '2592000' , 1year == '31536000'
PD = '86400'
# GraphStartTime
# Format : 'YYYYmmddHHMMSS'
ST = '20150407000000'

### Your Code Section
fuga = ZbxGraphGetter.new
fuga.http_request(fuga.auth_json) 
fuga.http_request(fuga.host_json) 
fuga.hostlist_gen
fuga.png_getter
